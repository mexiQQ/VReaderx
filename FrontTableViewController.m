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
@interface FrontTableViewController ()

@end

@implementation FrontTableViewController
{
    NSArray *myarray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // Return the number of sections.
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
    
    
    NSLog(@"lijianwei playerName = %@", [[myarray objectAtIndex:indexPath.row] objectForKey:@"playerName"]);
    
    cell.newsTitle.text = [[myarray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.publishTime.text = [NSString stringWithFormat:@"%@", [[myarray objectAtIndex:indexPath.row] objectForKey:@"publishTime"]];
    
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
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"module1"];
        [bquery selectKeys:@[@"title",@"publishTime"]];
        [bquery setLimit:15];
        [bquery orderByDescending:@"createdAt"];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            myarray = array;
            [self performSelector:@selector(reloadData) withObject:nil afterDelay:0];
        }];
        
        }
}

-(void)reloadData{
     [self.tableView reloadData];
     [self.refreshControl endRefreshing];

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
        destViewController.titleName = [[myarray objectAtIndex:indexPath.row] objectForKey:@"title"];
        destViewController.createTime = [[myarray objectAtIndex:indexPath.row] objectForKey:@"CreateTime"];
    }
}


@end
