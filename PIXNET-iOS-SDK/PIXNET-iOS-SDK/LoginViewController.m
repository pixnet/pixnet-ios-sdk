//
//  LoginViewController.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 7/16/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "LoginViewController.h"
#import "PIXNETSDK.h"

@interface LoginViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];

//        _webView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:_webView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"webView frame: %@", NSStringFromCGRect(_webView.frame));
    [PIXNETSDK loginByOAuthLoginView:_webView completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"succeed: %@", result);
        } else {
            NSLog(@"failed: %@", error);
        }
    }];
    [[PIXNETSDK new] getAlbumMainWithCompletion:^(BOOL succeed, id result, NSError *error) {
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
