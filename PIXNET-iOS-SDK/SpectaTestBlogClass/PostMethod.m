//
//  PostMethod.m
//  PIXNET-iOS-SDK
//
//  Created by dennis on 2015/10/5.
//  Copyright © 2015年 Dolphin Su. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import "Nocilla.h"
#import "PIXBlog.h"
#import "UserForTest.h"
#import "PIXNETSDK.h"

SpecBegin(BlogPost)
describe(@"For Post Methed", ^{
    
    beforeAll(^{
        
        [PIXNETSDK setConsumerKey:[[UserForTest alloc] init].consumerKey consumerSecret:[[UserForTest alloc] init].consumerSecret];
        [PIXNETSDK logout];
        
        id <UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
        UIView *rootView = appDelegate.window.rootViewController.view;
        UIWebView *webView = [[UIWebView alloc] initWithFrame:rootView.bounds];
        [rootView addSubview:webView];
        
        setAsyncSpecTimeout(30);
        waitUntil(^(DoneCallback done) {
            [PIXNETSDK loginByOAuthLoginView:webView completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                done();
            }];
        });
        
    });
    
});
SpecEnd