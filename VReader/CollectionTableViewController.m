//
//  CollectionTableViewController.m
//  VReader
//
//  Created by liwenqian on 14-10-10.
//  Copyright (c) 2014年 CoDeveloper. All rights reserved.
//

#import "CollectionTableViewController.h"

@interface CollectionTableViewController ()

@end

@implementation CollectionTableViewController{
    NSArray *myarray;
}

@synthesize tag;
@synthesize revealButtonItem;

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
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }

    
    if (![self isLocalData]) {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [myarray count];
}

-(BOOL)isLocalData{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CollectionNews"];
    [fetchRequest setFetchLimit:15];
    NSArray *news = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(news.count > 0)
    {
        myarray = news;
        return true;
    }
    return false;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CoustomerTableIdentifier = @"FrontCell";
    
    FrontTableViewCell *cell =(FrontTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CoustomerTableIdentifier];
    
    if (cell == nil) {
        cell = [[FrontTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CoustomerTableIdentifier];
    }
    
    cell.newsTitle.text = [[myarray objectAtIndex:indexPath.row] valueForKey:@"newsTitle"];
    cell.publishTime.text = [[myarray objectAtIndex:indexPath.row] valueForKey:@"newsPublishTime"];
    
    //cell.newsTitle.text = @"hello world";
    //cell.publishTime.text = @"2014-1009";
    return cell;

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
     NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DetailViewContrpller *destViewController = segue.destinationViewController;
    destViewController.tag = @"local";
    destViewController.titleName = [[myarray objectAtIndex:indexPath.row] valueForKey:@"newsTitle"];
    destViewController.publishTime = [[myarray objectAtIndex:indexPath.row] valueForKey:@"newsPublishTime"];
}


@end
