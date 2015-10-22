//
//  PostMethod.m
//  PIXNET-iOS-SDK
//
//  Created by dennis on 2015/10/5.
//  Copyright © 2015年 Dolphin Su. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import "PIXBlog.h"
#import "UserForTest.h"
#import "PIXNETSDK.h"

SpecBegin(BlogPost)
__block UserForTest *userForTest = nil;
describe(@"For Post Methed", ^{
    
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
    /*
    it(@"New Blog Article", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            NSDate *now = [[NSDate alloc] init];
            [[PIXBlog new] createBlogArticleWithTitle:@"抬頭3" body:@"巴帝4" status:PIXArticleStatusPassword publicAt:now userCategoryID:@"6494551" siteCategoryID:@"5" useNewLineToBR:YES commentPerm:PIXArticleCommentPermPublic commentHidden:NO tags:@[@"API",@"NEW"] thumbURL:nil trackback:@[@"http://google.com",@"http://tw.yahoo.com"] password:userForTest.userPassword passwordHint:@"9487" friendGroupID:nil notifyTwitter:NO notifyFacebook:NO notifyPlurk:NO cover:nil completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();

            }];
            
        });
    });
    */
//修改部落格個人文章
    /*
    it(@"Modify Blog Atricle", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] updateBlogArticleWithArticleID:@"373856665" title:@"修改部落格抬頭" body:@"修改部落格巴帝" status:PIXArticleStatusPublic publicAt:nil userCategoryID:nil siteCategoryID:nil useNewLineToBR:YES commentPerm:PIXArticleCommentPermPublic commentHidden:NO tags:@[@"blah",@"and blah"] thumbURL:nil trackback:nil password:nil passwordHint:nil friendGroupID:nil notifyTwitter:NO notifyFacebook:NO notifyPlurk:NO cover:nil completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
                
            }];
        });
    });
    */
//新增部落格留言
    it(@"New Blog Comment in Public Article", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] createBlogCommentWithArticleID:userForTest.publicArticle body:@"好棒" userName:userForTest.userName author:nil title:@"哇！" url:nil isOpen:YES email:nil blogPassword:nil articlePassword:nil completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();

            }];
            
        });
    });
//回覆部落格留言
    /*
    it(@"Reply Blog Comment in Public Article", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] replyBlogCommentWithCommnetID:@"40324126" body:@"喔！是喔！" completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();

            }];
            
        });
    });
     */
//將留言設為公開
    it(@"Modify Blog Comment to Public", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] updateBlogCommentsOpenWithComments:@[@"40323253"] isOpen:YES completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
                
            }];
            
        });
    });
//將留言設為廣告留言
    it(@"Modify Blog Comment to Spam", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] updateBlogCommentsSpamWithComments:@[@"40324111",@"40324099",@"40324096",@"40324087"] isSpam:YES completion:^(BOOL succeed, id result, NSError *error) {
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