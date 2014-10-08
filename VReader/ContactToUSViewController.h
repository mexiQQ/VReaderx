//
//  ContactToUSViewController.h
//  VReader
//
//  Created by liwenqian on 14-10-8.
//  Copyright (c) 2014年 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactToUSViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *mytableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@end
