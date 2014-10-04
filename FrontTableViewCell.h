//
//  FrontTableViewCell.h
//  VReader
//
//  Created by liwenqian on 14-10-2.
//  Copyright (c) 2014年 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrontTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *publishTime;

@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@end
