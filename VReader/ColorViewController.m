//
//  ColorViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "ColorViewController.h"

@interface ColorViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation ColorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customSetup];
}


- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
    [_myUIActivityIndicatorView setHidesWhenStopped:YES];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mp.weixin.qq.com/s?__biz=MzA5MzM4MzMwNA==&mid=200919458&idx=1&sn=884c7e8bd4b94a15f722dbf6a652d481#rd"]];
    [_myWebView loadRequest:request];
    [_myWebView setDelegate:self];
    
}

#pragma mark state preservation / restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Save what you need here

    
    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here

    
    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
}

- (void )webViewDidStartLoad:(UIWebView  *)webView{
    [_myUIActivityIndicatorView startAnimating];

}

- (void )webViewDidFinishLoad:(UIWebView  *)webView{
    [_myUIActivityIndicatorView stopAnimating];
}


- (void)webView:(UIWebView *)webView  didFailLoadWithError:(NSError *)error{
    [_myUIActivityIndicatorView stopAnimating];
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"友情提示"
                              message:@"无法获取数据，请检查网络(☆_☆)"
                              delegate:self cancelButtonTitle:@"关闭"
                              otherButtonTitles:nil, nil];
    [alertView show];

}


@end
