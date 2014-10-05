//
//  DetailViewContrpller.h
//  VReader
//
//  Created by liwenqian on 14-10-5.
//  Copyright (c) 2014年 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewContrpller : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScroller;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;

@property (weak, nonatomic) IBOutlet UITextView *newsContent;

@end
