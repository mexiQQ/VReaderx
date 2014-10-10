//
//  DetailViewContrpller.h
//  VReader
//
//  Created by liwenqian on 14-10-5.
//  Copyright (c) 2014年 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewContrpller : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *myScroller;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UITextView *newsContent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myprogress;
- (IBAction)saveNews:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SaveButton;

@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, strong) NSString* tag;

@end
