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
@end
@implementation DetailViewContrpller
@synthesize myScroller;
@synthesize newsContent;
@synthesize newsTitle;
@synthesize titleName;
@synthesize myprogress;

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
    
    if(![self isLocalData])
    {
        BmobQuery  *bquery = [BmobQuery queryWithClassName:@"module1"];
        [bquery selectKeys:@[@"content"]];
        [bquery whereKey:@"title" equalTo:titleName];
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
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RecentlyNews"];
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
    NSString *desContent = newsContent.text;
    CGSize  textSize = [desContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 2000) lineBreakMode:NSLineBreakByWordWrapping];
    
    //[newsContent setContentSize:CGSizeMake(newsContent.frame.size.width,textSize.height+20)];
    
    [newsContent setFrame:CGRectMake(0, 0,newsContent.frame.size.width,textSize.height+20)];
    [newsContent setShowsVerticalScrollIndicator:NO];
    [newsContent setEditable:NO];
    [myScroller setMaximumZoomScale:1];
    [myScroller setMinimumZoomScale:1];
    [myScroller setShowsVerticalScrollIndicator:NO];
    [myScroller setScrollEnabled:YES];
    [myScroller setPagingEnabled:YES];
    [myScroller setContentSize:CGSizeMake(newsContent.frame.size.width, newsContent.frame.size.height)];
    //[myScroller setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)isLocalData{
    //NSLog(@"titlename%@",titleName);
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RecentlyNews"];
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

@end
