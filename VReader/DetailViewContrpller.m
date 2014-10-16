//
//  DetailViewContrpller.m
//  VReader
//
//  Created by liwenqian on 14-10-5.
//  Copyright (c) 2014年 CoDeveloper. All rights reserved.
//

#import "DetailViewContrpller.h"
#import <BmobSDK/Bmob.h>
#import <CoreData/CoreData.h>

@interface DetailViewContrpller ()
{
    NSString *module;
    NSString *myEntimty;
}
@end
@implementation DetailViewContrpller
@synthesize myScroller;
@synthesize newsContent;
@synthesize newsTitle;
@synthesize titleName;
@synthesize myprogress;
@synthesize tag;
@synthesize SaveButton;
@synthesize publishTime;

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    newsTitle.text = titleName;
    [myprogress setHidesWhenStopped:YES];
    [myprogress startAnimating];
    [self selectModule];
    if(![self isLocalData])
    {
        BmobQuery  *bquery = [BmobQuery queryWithClassName:module];
        [bquery selectKeys:@[@"content"]];
        [bquery whereKey:@"title" equalTo:titleName];
        [bquery whereKey:@"publishTime" equalTo:publishTime];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            BmobObject *bomb = [array objectAtIndex:0];
            [newsContent setText:[bomb objectForKey:@"content"]];
            [NSThread detachNewThreadSelector:@selector(saveContent:) toTarget:self withObject:bomb];
            [self performSelector:@selector(changeFrameSizeOfTextView) withObject:nil afterDelay:0];
        }];
    }
}

-(void)saveContent:(BmobObject *)bomb{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:myEntimty];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"newsTitle == %@",titleName];
    [fetchRequest setPredicate:predicate];

    NSArray *news = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if (news.count > 0) {
        NSManagedObject *entiy = [news objectAtIndex:0];
        [entiy setValue:[bomb objectForKey:@"content"] forKey:@"newsContent"];
        
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
            return;
        }else{
            NSLog(@"save success");
        }
    }
}

-(void)changeFrameSizeOfTextView{
    [myprogress stopAnimating];
    [newsContent setShowsVerticalScrollIndicator:NO];
    [newsContent setEditable:NO];
    [myScroller setMaximumZoomScale:1];
    [myScroller setMinimumZoomScale:1];
    [myScroller setShowsVerticalScrollIndicator:NO];
    [myScroller setScrollEnabled:YES];
    [myScroller setPagingEnabled:YES];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)isLocalData{
    //NSLog(@"titlename%@",titleName);
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:myEntimty];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"newsTitle == %@",titleName];
    [fetchRequest setPredicate:predicate];
    
    NSArray *news = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(news.count > 0)
    {
        NSManagedObject *entiy = [news objectAtIndex:0];
        if(![entiy valueForKey:@"newsContent"]){
            return false;
        }else{
            [newsContent setText:[entiy valueForKey:@"newsContent"]];
            [self changeFrameSizeOfTextView];
            return true;
        }
    }
    return false;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)selectModule{
    
    if([tag isEqual:@"news1"]||(tag == nil)){
        module = @"module1";
        myEntimty = @"RecentlyNews";
    }else if([tag isEqual:@"news2"]){
        module = @"module2";
        myEntimty = @"SchoolEmploy";
    }else if([tag isEqual:@"news3"]){
        module = @"module3";
        myEntimty = @"OnlineEmploy";
    }else if([tag isEqual:@"news4"]){
        module = @"module4";
        myEntimty = @"PractiseEmploy";
    }else if([tag isEqual:@"local"]){
        module = @"module5";
        myEntimty = @"CollectionNews";
    }
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return nil;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //NSLog(@"Did end decelerating");
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"Did scroll");
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
    //NSLog(@"Did end dragging");
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //NSLog(@"Did begin decelerating");
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //NSLog(@"Did begin dragging");
}

- (IBAction)saveNews:(id)sender {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CollectionNews"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"newsTitle == %@",titleName];
    [fetchRequest setPredicate:predicate];
    NSArray *news = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    if (news.count == 0) {
        NSManagedObject *newRecentlyNews = [NSEntityDescription insertNewObjectForEntityForName:@"CollectionNews" inManagedObjectContext:managedObjectContext];
        [newRecentlyNews setValue:titleName forKey:@"newsTitle"];
        [newRecentlyNews setValue:publishTime forKey:@"newsPublishTime"];
        [newRecentlyNews setValue:newsContent.text forKey:@"newsContent"];
        //[newRecentlyNews setValue:[obj objectForKey:@"playerName"] forKey:@"newsContent"];
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"友情提示"
                                      message:@"发生意外(☆_☆)"
                                      delegate:self cancelButtonTitle:@"关闭"
                                      otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"友情提示"
                                      message:@"保存成功Y(^_^)Y"
                                      delegate:self cancelButtonTitle:@"关闭"
                                      otherButtonTitles:nil, nil];
            [alertView show];

        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"友情提示"
                                  message:@"重复保存哦，亲(☆_☆)"
                                  delegate:self cancelButtonTitle:@"关闭"
                                  otherButtonTitles:nil, nil];
        [alertView show];

    }
}
@end
