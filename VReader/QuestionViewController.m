//
//  QuestionViewController.m
//  VReader
//
//  Created by liwenqian on 14-10-10.
//  Copyright (c) 2014年 CoDeveloper. All rights reserved.
//

#import "QuestionViewController.h"
#import <BmobSDK/Bmob.h>

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)submitQuestion:(id)sender {
    if(![_myQuestion.text isEqualToString:@"在此输入："]){
        BmobObject *gameScore = [BmobObject objectWithClassName:@"Questions"];
        [gameScore setObject:_myQuestion.text forKey:@"question"];
        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            //进行操作
            if(error ==nil){
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"友情提示"
                                          message:@"提交成功Y(^_^)Y"
                                          delegate:self cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil, nil];
                [alertView show];

            }else{
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"友情提示"
                                          message:@"提交失败，请检查网络(☆_☆)"
                                          delegate:self cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil, nil];
                [alertView show];

            }
        }];
    }else{
    
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"友情提示"
                                  message:@"请输入有效文字(☆_☆)"
                                  delegate:self cancelButtonTitle:@"关闭"
                                  otherButtonTitles:nil, nil];
        [alertView show];

    }
}
@end
