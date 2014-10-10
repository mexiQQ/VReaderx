//
//  CollectionTableViewController.h
//  VReader
//
//  Created by liwenqian on 14-10-10.
//  Copyright (c) 2014年 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FrontTableViewCell.h"
#import "DetailViewContrpller.h"
@interface CollectionTableViewController : UITableViewController
@property (nonatomic, strong) NSString* tag;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@end
