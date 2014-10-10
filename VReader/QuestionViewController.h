//
//  QuestionViewController.h
//  VReader
//
//  Created by liwenqian on 14-10-10.
//  Copyright (c) 2014年 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionViewController : UIViewController
- (IBAction)submitQuestion:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *myQuestion;

@end
