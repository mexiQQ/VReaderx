//
//  DetailViewContrpller.m
//  VReader
//
//  Created by liwenqian on 14-10-5.
//  Copyright (c) 2014年 CoDeveloper. All rights reserved.
//

#import "DetailViewContrpller.h"
#import <BmobSDK/Bmob.h>

@interface DetailViewContrpller ()
@end
@implementation DetailViewContrpller
@synthesize myScroller;
@synthesize newsContent;
@synthesize newsTitle;
@synthesize titleName;
@synthesize createTime;
@synthesize myprogress;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    newsTitle.text = titleName;
    [myprogress setHidesWhenStopped:YES];
    [myprogress startAnimating];
    BmobQuery  *bquery = [BmobQuery queryWithClassName:@"module1"];
    [bquery selectKeys:@[@"content"]];
    [bquery whereKey:@"title" equalTo:titleName];
    [bquery whereKey:@"CreateTime" equalTo:createTime];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
    BmobObject *bomb = [array objectAtIndex:0];
        newsContent.text = [bomb objectForKey:@"content"];
    [self performSelector:@selector(showContent) withObject:nil afterDelay:0];
    }];
}


-(void)showContent{
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
    [myScroller setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"Did end decelerating");
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"Did scroll");
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
    NSLog(@"Did end dragging");
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did begin decelerating");
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"Did begin dragging");
}

@end
