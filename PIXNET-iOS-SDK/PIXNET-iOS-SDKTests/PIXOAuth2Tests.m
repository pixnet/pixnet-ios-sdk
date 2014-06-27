//
//  PIXOAuth2Tests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/24/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "PIXNETSDK.h"
#import "AppDelegate.h"
#import "UserForTest.h"

@interface PIXOAuth2Tests : XCTestCase
@property (nonatomic, strong) UserForTest *testUser;

@end

@implementation PIXOAuth2Tests

- (void)setUp
{
    [super setUp];
    _testUser = [[UserForTest alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMain{
    [PIXNETSDK setConsumerKey:_testUser.consumerKey consumerSecret:_testUser.consumerSecret callbackURL:_testUser.callbaclURL];
    if ([PIXNETSDK isAuthed]) {
        [PIXNETSDK logout];
    }
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIView *rootView = appDelegate.window.rootViewController.view;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:rootView.bounds];
    [rootView addSubview:webView];

    __block BOOL done = NO;
    [PIXAPIHandler authByOAuth2WithCallbackURL:@"pixnetsdk://www.com.tw" loginView:webView completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            if ([PIXAPIHandler isAuthed]) {
                NSLog(@"login token: %@", result);
            } else {
                XCTFail(@"login not succeed");
            }
        } else {
            XCTFail(@"login failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}

@end
