//
//  FrontTableViewController.h
//  VReader
//
//  Created by liwenqian on 14-10-2.
//  Copyright (c) 2014年 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrontTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (nonatomic, strong) NSString* tag;
@property (weak, nonatomic) IBOutlet UINavigationItem *appTitle;
@end
