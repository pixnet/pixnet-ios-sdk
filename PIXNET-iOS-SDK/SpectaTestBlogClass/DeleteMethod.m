//
//  DeleteMethod.m
//  PIXNET-iOS-SDK
//
//  Created by dennis on 2015/10/6.
//  Copyright © 2015年 Dolphin Su. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import "PIXBlog.h"
#import "UserForTest.h"
#import "PIXNETSDK.h"

SpecBegin(BlogDelete)
__block UserForTest *userForTest = nil;
describe(@"For Delete Methed", ^{
    
    beforeAll(^{
        
        userForTest = [[UserForTest alloc] init];
        [PIXNETSDK setConsumerKey:userForTest.consumerKey consumerSecret:userForTest.consumerSecret];
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
    
//刪除部落格個人分類
    /*
    it(@"Delete Blog Category", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] deleteBlogCategoriesByID:@"6492877" type:PIXBlogCategoryTypeCategory completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
                
            }];
        });
    });
    */
//刪除部落格個人文章
    /*
    it(@"Delete Blog Article", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] deleteBlogArticleByArticleID:@"373856665" completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
                
            }];
        });
    });
     */
//刪除部落格留言
    /*
    it(@"Delete Blog Comment", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] deleteBlogComments:@[@"40321249",@"40320964"] completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
                
            }];
        });
    });
     */
});
SpecEnd