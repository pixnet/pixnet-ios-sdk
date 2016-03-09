//
//  GetMethodWithAuth.m
//  PIXNET-iOS-SDK
//
//  Created by dennis on 2015/10/2.
//  Copyright © 2015年 Dolphin Su. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import "PIXBlog.h"
#import "UserForTest.h"
#import "PIXNETSDK.h"

SpecBegin(BlogAuth)
__block UserForTest *userForTest = nil;
describe(@"For Auth", ^{
    
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

//列出所有部落格個人文章
    it(@"blog articles should Auth but no password", ^{
        setAsyncSpecTimeout(60);

        waitUntil(^(DoneCallback done) {
            [[PIXBlog new] getBlogAllArticlesWithUserName:userForTest.userName password:nil page:0 perpage:0 userCategories:nil status:PIXArticleStatusPassword isTop:NO trimUser:NO shouldAuth:YES thumbSize:0 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
            }];

        });
    });
    
//讀取部落格個人文章
    it(@"blog articles which need password", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogSingleArticleWithUserName:userForTest.userName articleID:userForTest.privateArticle needAuth:NO blogPassword:nil articlePassword:userForTest.userPassword thumbSize:0 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();

            }];
        });
    });
    it(@"blog articles need but no password", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogSingleArticleWithUserName:userForTest.userName articleID:userForTest.privateArticle needAuth:NO blogPassword:nil articlePassword:nil thumbSize:0 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).notTo.beTruthy();
                expect(result).to.beNil();
                done();
                
            }];
        });
    });
    it(@"blog articles need but login", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogSingleArticleWithUserName:userForTest.userName articleID:userForTest.privateArticle needAuth:YES blogPassword:nil articlePassword:nil thumbSize:0 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
                
            }];
        });
    });
//讀取指定文章之相關文章
    it(@"blog articles related need password", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogRelatedArticleByArticleID:userForTest.privateArticle userName:userForTest.userName withBody:YES relatedLimit:10000 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();

            }];
        });
    });
//讀取指定文章之留言
    it(@"blog articles comments", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogArticleCommentsWithUserName:userForTest.userName articleID:userForTest.privateArticle blogPassword:nil articlePassword:userForTest.userPassword page:1 commentsPerPage:100 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
                
                
            }];
        });
    });
    it(@"blog articles comments wrong password", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogArticleCommentsWithUserName:userForTest.userName articleID:userForTest.privateArticle blogPassword:nil articlePassword:@"wrongPassword" page:1 commentsPerPage:100 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).notTo.beTruthy();
                expect(result).to.beNil();
                done();
                
            }];
        });
    });
//列出部落格最新文章
    it(@"blog articles latest", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogLatestArticleWithUserName:userForTest.userName blogPassword:nil limit:1000 trimUser:YES thumbSize:0 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();

            }];
        });
    });
//列出部落格熱門文章
    it(@"blog articles hot has date", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogHotArticleWithUserName:userForTest.userName password:nil fromDate:[[NSDate alloc] initWithTimeInterval:-60*60*60 sinceDate:[NSDate date]] toDate:[NSDate date] limit:1000 trimUser:YES thumbSize:0 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
                
            }];
        });
    });
    it(@"blog articles hot no date", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogHotArticleWithUserName:userForTest.userName password:nil fromDate:nil toDate:nil limit:1000 trimUser:YES thumbSize:0 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
                
            }];
        });
    });
    it(@"blog articles hot date upside down", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogHotArticleWithUserName:userForTest.userName password:nil fromDate:[NSDate date] toDate:[[NSDate alloc] initWithTimeInterval:-60*60*60 sinceDate:[NSDate date]] limit:1000 trimUser:YES thumbSize:0 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).notTo.beTruthy();
                expect(result).to.beNil();
                done();
                
            }];
        });
    });
//搜尋部落格文章
    it(@"blog articles search", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getblogSearchArticleWithKeyword:@"@#$%^&*(" userName:userForTest.userName searchType:PIXArticleSearchTypeKeyword page:1000 perPage:1 thumbSize:0 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();

            }];
        });
    });
//列出部落格留言
    it(@"blog comments need password", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogCommentsWithUserName:userForTest.userName articleID:userForTest.privateArticle blogPassword:nil articlePassword:nil filter:PIXBlogCommentFilterTypeAll isSortAscending:YES page:1 perPage:100 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                done();
                
            }];
        });
    });
    it(@"blog comments no need password", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogCommentsWithUserName:userForTest.userName articleID:userForTest.publicArticle blogPassword:nil articlePassword:nil filter:PIXBlogCommentFilterTypeAll isSortAscending:YES page:1 perPage:100 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                for(NSDictionary *tmpDic in result[@"comments"]){
                    expect(tmpDic[@"body"]).notTo.beNil();
                }
                done();
                
            }];
        });
    });
//讀取單一留言
    it(@"blog single comment", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogSingleCommentWithUserName:userForTest.userName commmentID:userForTest.publicComment completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                expect(result[@"comment"][@"body"]).notTo.beNil();
                done();
                
            }];
        });
    });
    it(@"blog single comment which need Auth", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogSingleCommentWithUserName:userForTest.userName commmentID:userForTest.privateComment completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                expect(result[@"comment"][@"body"]).notTo.beNil();
                done();
                
            }];
        });
    });
//列出部落格最新留言
    it(@"blog latest comment", ^{
        setAsyncSpecTimeout(60);
        
        waitUntil(^(DoneCallback done) {
            
            [[PIXBlog new] getBlogLatestCommentWithUserName:userForTest.userName completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                for(NSDictionary *tmpDic in result[@"latest_comments"]){
                    expect(tmpDic[@"comment"][@"body"]).notTo.beNil();
                }
                done();

            }];
        });
    });

});
SpecEnd