//
//  FrontTableViewController.m
//  VReader
//
//  Created by liwenqian on 14-10-2.
//  Copyright (c) 2014年 CoDeveloper. All rights reserved.
//

#import "FrontTableViewController.h"
#import <BmobSDK/Bmob.h>
#import "FrontTableViewCell.h"
#import "DetailViewContrpller.h"
#import <CoreData/CoreData.h>

@interface FrontTableViewController ()

@end

@implementation FrontTableViewController
{
    NSArray *myarray;
    BOOL *local;
    NSString *module;
    NSString *myEntimty;
}
@synthesize tag;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self selectModule];
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];

    if (![self isLocalData]) {
       
        //todo 可设置自动获取数据
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (myarray) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
     return myarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CoustomerTableIdentifier = @"FrontCell";
    
    FrontTableViewCell *cell =(FrontTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CoustomerTableIdentifier];
    
    if (cell == nil) {
        cell = [[FrontTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CoustomerTableIdentifier];
    }
    
    if(local){
        cell.newsTitle.text = [[myarray objectAtIndex:indexPath.row] valueForKey:@"newsTitle"];
        cell.publishTime.text = [[myarray objectAtIndex:indexPath.row] valueForKey:@"newsPublishTime"];
    }else{
        cell.newsTitle.text = [[myarray objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.publishTime.text = [NSString stringWithFormat:@"%@", [[myarray objectAtIndex:indexPath.row] objectForKey:@"publishTime"]];
    }
    //cell.newsTitle.text = @"hello world";
    //cell.publishTime.text = @"2014-1009";
    return cell;
}


- (void)getLatestLoans{
    if (self.refreshControl.refreshing) {
       
        //获取上次刷新时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        //请求数据
        BmobQuery   *bquery = [BmobQuery queryWithClassName:module];
        [bquery selectKeys:@[@"title",@"publishTime"]];
        [bquery setLimit:15];
        [bquery orderByDescending:@"createdAt"];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if(!error){
                local = false;
                myarray = array;
                [NSThread detachNewThreadSelector:@selector(saveContent:) toTarget:self withObject:array];
                [self performSelector:@selector(reloadData) withObject:nil afterDelay:0];
            }else{
                [self.refreshControl endRefreshing];
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"友情提示"
                                          message:@"无法获取数据，请检查网络(☆_☆)"
                                          delegate:self cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
        
    }
}

-(void)reloadData{
     [self.tableView reloadData];
     [self.refreshControl endRefreshing];
     [self.tableView setBackgroundView:nil];
}

-(void)saveContent:(NSArray *)array{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:myEntimty];
    [fetchRequest setFetchLimit:15];
    NSArray *news = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for(NSManagedObject *obj in news){
        [context deleteObject:obj];
    }
    
    for (BmobObject *obj in array) {
        NSManagedObject *newRecentlyNews = [NSEntityDescription insertNewObjectForEntityForName:myEntimty inManagedObjectContext:context];
        [newRecentlyNews setValue:[obj objectForKey:@"title"] forKey:@"newsTitle"];
        [newRecentlyNews setValue:[obj objectForKey:@"publishTime"] forKey:@"newsPublishTime"];
        //[newRecentlyNews setValue:[obj objectForKey:@"playerName"] forKey:@"newsContent"];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }else{
            NSLog(@"save success!");
        }
    }
}

-(BOOL)isLocalData{

    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:myEntimty];
    [fetchRequest setFetchLimit:15];
    NSArray *news = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(news.count > 0)
    {
        myarray = news;
        local = true;
        return true;
    }
    local = false;
    return false;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewContrpller *destViewController = segue.destinationViewController;
        if(local){
            destViewController.titleName = [[myarray objectAtIndex:indexPath.row] valueForKey:@"newsTitle"];
            destViewController.publishTime = [[myarray objectAtIndex:indexPath.row] valueForKey:@"newsPublishTime"];
            destViewController.tag = tag;
        }else{
            destViewController.titleName = [[myarray objectAtIndex:indexPath.row] objectForKey:@"title"];
            destViewController.publishTime = [[myarray objectAtIndex:indexPath.row] objectForKey:@"publishTime"];
            destViewController.tag = tag;
        }
    }
}

-(void)selectModule{
    
    if([tag isEqual:@"news1"]||(tag == nil)){
        module = @"module1";
        myEntimty = @"RecentlyNews";
        _appTitle.title = @"新闻动态";
    }else if([tag isEqual:@"news2"]){
        module = @"module2";
        myEntimty = @"SchoolEmploy";
        _appTitle.title = @"校园招聘";
    }else if([tag isEqual:@"news3"]){
        module = @"module3";
        myEntimty = @"OnlineEmploy";
        _appTitle.title = @"在线招聘";
    }else if([tag isEqual:@"news4"]){
        module = @"module4";
        myEntimty = @"PractiseEmploy";
        _appTitle.title = @"实习招聘";
    }
}

@end
