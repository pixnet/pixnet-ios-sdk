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
    
//修改部落格資訊
    it(@"Modify Blog user info. ", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] updateBlogInformationWithBlogName:nil blogDescription:nil keywords:nil siteCategoryId:@"5" completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
                
            }];

        });
    });
    
//新增部落格個人分類
    /*
    it(@"New Blog Category", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] createBlogCategoriesWithName:@"全新的個人分類唷" type:PIXBlogCategoryTypeCategory description:nil siteCategory:nil completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();

            }];
            
        });
    });
     */
    
//修改部落格個人分類
    it(@"Modify Blog Category", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] updateBlogCategoryFromID:@"6494551" newName:@"修改個人分類" type:PIXBlogCategoryTypeCategory description:@"" completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
                
            }];
            
        });
    });
//修改部落格個人分類排序
    it(@"Modify Blog Category Sort", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] sortBlogCategoriesTo:@[@"6492877", @"6494551"] completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();

            }];
            
        });
    });
//新增部落格個人文章createBlogArticleWithTitle
    it(@"New Blog Article", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] createBlogArticleWithTitle:@"抬頭" body:@"巴帝" status:PIXArticleStatusPassword publicAt:[NSDate date] userCategoryID:@"6494551" siteCategoryID:@"5" useNewLineToBR:YES commentPerm:PIXArticleCommentPermPublic commentHidden:NO tags:nil thumbURL:nil trackback:@[@"http://google.com",@"http://tw.yahoo.com"] password:[[UserForTest alloc] init].userPassword passwordHint:@"9487" friendGroupID:nil notifyTwitter:NO notifyFacebook:NO notifyPlurk:NO cover:nil completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();

            }];
            
        });
    });

    

    it(@"end", ^{
        
    });
});
SpecEnd