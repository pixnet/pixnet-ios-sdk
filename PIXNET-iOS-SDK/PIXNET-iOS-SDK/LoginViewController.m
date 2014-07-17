//
//  LoginViewController.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 7/16/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "LoginViewController.h"
#import "PIXNETSDK.h"

@interface LoginViewController ()
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:_webView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    登不進去
    [PIXNETSDK loginByOAuthLoginView:_webView completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"succeed: %@", result);
        } else {
            NSLog(@"failed: %@", error);
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
