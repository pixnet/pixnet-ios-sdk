//
//  PIXBlogTests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 5/5/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIXNETSDK.h"
#import "UserForTest.h"

@interface PIXBlogTests : XCTestCase
@property (nonatomic, strong) UserForTest *testUser;

@end

@implementation PIXBlogTests

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

- (void)testFlow
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    [PIXNETSDK setConsumerKey:_testUser.consumerKey consumerSecret:_testUser.consumerSecret];
    
    //取得部落格全站分類
    [self getBlogSiteCategories];
    //取得使用者部落格資訊
    [self getBlogInformation];
    //登出
    [PIXNETSDK logout];
    //登入
    __block BOOL done = NO;
    __block BOOL authed = NO;
    
    [PIXNETSDK authByXauthWithUserName:_testUser.userName
                          userPassword:_testUser.userPassword
                     requestCompletion:^(BOOL succeed, id result, NSError *error) {
                         done = YES;
                         if (succeed) {
                             authed = YES;
                         } else {
                             XCTFail(@"auth failed: %@", error);
                         }
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if (!authed) {
        return;
    }

    //新增部落格個人分類
    NSString *categoryId = [self createBlogCategory:PIXBlogCategoryTypeCategory];
    NSString *folderId = [self createBlogCategory:PIXBlogCategoryTypeFolder];
    
    //修改部落格個人分類
    [self updateBlogCategory:categoryId categoryType:PIXBlogCategoryTypeCategory];
    [self updateBlogCategory:folderId categoryType:PIXBlogCategoryTypeFolder];
    
    //取得使用者部落格分類資訊
    NSArray *categoriesUser = [self getBlogCategories];

    //修改部落格個人分類排序
    [self sortCategories:categoriesUser];
    
    //新增部落格個人文章
    NSString *articleId = [self createBlogArticle];
    
    //修改部落格個人文章
    [self modifyBlogArticle:articleId];
    //列出所有部落格個人文章
    NSArray *articles = [self getBlogArticles];
    //讀取部落格個人單篇文章
    [self getBlogArticle:articles[0][@"id"]];
    //讀取相關文章
    [self getBlogRelatedArticleWithArticle:articles[0][@"id"]];
    //讀取部落格最新文章
    [self getBlogLatestArticles];
    //讀取部落格熱門文章
    [self getBlogHotArticles];
    //搜尋全站文章
    [self searchArticlesInAllSite:YES];
    //搜尋某部落客的文章
    [self searchArticlesInAllSite:NO];
    
    //新增部落格留言
    NSString *commentId = [self createBlogArticleComment:articles[0][@"id"]];
    //回覆部落格留言
    [self replyBlogComment:commentId];
    //將留言設為悄悄話
    [self closeOrOpenBlogComment:commentId isOpen:NO];
    //將留言設為公開
    [self closeOrOpenBlogComment:commentId isOpen:YES];
    //將留言設為廣告留言
    [self markBlogComment:commentId isSpam:YES];
    //將留言設為非廣告留言
    [self markBlogComment:commentId isSpam:NO];
    //列出部落格最新留言
    [self getBlogCommentsLatest];
    //讀取單一留言
    [self getComment:commentId];
    //列出部落格留言
    [self getBlogCommentsWithArticle:articles[0][@"id"]];
    
    //刪除部落格留言
    [self deleteComment:commentId];
    //刪除部落格個人文章
    [self deleteBlogArticle:articleId];
    //刪除部落格個人分類
    [self deleteBlogCategory:categoryId];
    [self deleteBlogFoler:folderId];
}
-(void)getComment:(NSString *)commentId{
    __block BOOL done = NO;
    [[PIXNETSDK new] getBlogSingleCommentWithUserName:_testUser.userName commmentID:commentId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            
        } else {
            XCTFail(@"get blog comment failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(NSArray *)getBlogCommentsWithArticle:(NSString *)articleId{
    __block BOOL done = NO;
    __block NSArray *array = nil;
    [[PIXNETSDK new] getBlogCommentsWithUserName:_testUser.userName articleID:articleId page:1 perPage:10 completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            array = result[@"comments"];
        } else {
            XCTFail(@"get blog comments failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return array;
}
-(NSArray *)getBlogCommentsLatest{
    __block BOOL done = NO;
    __block NSArray *array = nil;
    [[PIXNETSDK new] getBlogLatestCommentWithUserName:_testUser.userName completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            array = result[@"latest_comments"];
        } else {
            XCTFail(@"get blog latest comments failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return array;
}
-(void)markBlogComment:(NSString *)commentId isSpam:(BOOL)isSpam{
    __block BOOL done = NO;
    [[PIXNETSDK new] updateBlogCommentSpamWithCommentID:commentId isSpam:isSpam completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            
        } else {
            XCTFail(@"mark blog comment as spam or ham failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)closeOrOpenBlogComment:(NSString *)commentId isOpen:(BOOL)isOpen{
    __block BOOL done = NO;
    [[PIXNETSDK new] updateBlogCommentOpenWithCommentID:commentId isOpen:isOpen completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            
        } else {
            XCTFail(@"close or open blog comment failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)replyBlogComment:(NSString *)commentId{
    __block BOOL done = NO;
    [[PIXNETSDK new] replyBlogCommentWithCommnetID:commentId body:@"reply comment" completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            
        } else {
            XCTFail(@"replay blog comment failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)deleteComment:(NSString *)commentId{
    __block BOOL done = NO;
    [[PIXNETSDK new] deleteBlogCommentWithCommentID:commentId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            
        } else {
            XCTFail(@"delete blog comment failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(NSString *)createBlogArticleComment:(NSString *)articleId{
    __block BOOL done = NO;
    __block NSString *commentId = nil;
    [[PIXNETSDK new] createBlogCommentWithArticleID:articleId body:@"test comment" userName:_testUser.userName author:nil title:nil url:nil isOpen:YES email:nil blogPassword:nil articlePassword:nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            commentId = result[@"comment"][@"id"];
        } else {
            XCTFail(@"create blog comment failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return commentId;
}
-(void)searchArticlesInAllSite:(BOOL)allSite{
    __block BOOL done = NO;
    NSString *userName = nil;
    if (!allSite) {
        userName = _testUser.userName;
    }
    [[PIXNETSDK new] getblogSearchArticleWithKeyword:@"鞋子" userName:userName page:1 perPage:2 completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
//            NSLog(@"search result: %@", result);
        } else {
            XCTFail(@"get blog hot articles failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getBlogHotArticles{
    __block BOOL done = NO;
    [[PIXNETSDK new] getBlogHotArticleWithUserName:_testUser.userName password: nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            
        } else {
            XCTFail(@"get blog hot articles failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getBlogLatestArticles{
    __block BOOL done = NO;
    [[PIXNETSDK new] getBlogLatestArticleWithUserName:_testUser.userName blogPassword:nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            
        } else {
            XCTFail(@"get blog latest articles failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getBlogRelatedArticleWithArticle:(NSString *)articleId{
    __block BOOL done = NO;
    [[PIXNETSDK new] getBlogRelatedArticleByArticleID:articleId userName:_testUser.userName relatedLimit:10 completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            
        } else {
            XCTFail(@"get blog articles failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getBlogArticle:(NSString *)articleId{
    __block BOOL done = NO;
    [[PIXNETSDK new] getBlogSingleArticleWithUserName:_testUser.userName articleID:articleId blogPassword:nil articlePassword:nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            
        } else {
            XCTFail(@"get blog articles failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(NSArray *)getBlogArticles{
    __block BOOL done = NO;
    __block NSArray *articles = nil;
    [[PIXNETSDK new] getBlogAllArticlesWithUserName:_testUser.userName
                                           password:nil
                                               page:1
                                            perpage:30
                                         completion:^(BOOL succeed, id result, NSError *error) {
                                             if (succeed) {
                                                 articles = result[@"articles"];
                                             } else {
                                                 XCTFail(@"get blog articles failed: %@", error);
                                             }
                                             done = YES;
                                         }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return articles;
}
-(void)modifyBlogArticle:(NSString *)articleId{
    __block BOOL done = NO;
    [[PIXNETSDK new] updateBlogArticleWithArticleID:articleId
                                              title:@"title"
                                               body:@"body"
                                             status:PIXArticleStatusDraft
                                           publicAt:nil
                                     userCategoryID:nil
                                     siteCategoryID:nil
                                        commentPerm:PIXArticleCommentPermClose
                                      commentHidden:NO
                                               tags:nil
                                           thumbURL:nil
                                          trackback:nil
                                           password:nil
                                       passwordHint:nil
                                      friendGroupID:nil
                                      notifyTwitter:NO
                                     notifyFacebook:NO
                                         completion:^(BOOL succeed, id result, NSError *error) {
                                             if (succeed) {
                                                 
                                             } else {
                                                 XCTFail(@"fail");
                                             }
                                             done = YES;
                                         }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)deleteBlogArticle:(NSString *)articleId{
    __block BOOL done = NO;
    [[PIXNETSDK new] deleteBlogArticleByArticleID:articleId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"delete blog article succeed: %@", articleId);
        } else {
            XCTFail(@"delete blog article failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(NSString *)createBlogArticle{
    __block BOOL done = NO;
    __block NSString *articleId = nil;
    [[PIXNETSDK new] createBlogArticleWithTitle:@"article title for unit test" body:@"article body for unit test" completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            articleId = result[@"article"][@"id"];
            NSLog(@"create blog article succeed: %@", articleId);
        } else {
            XCTFail(@"create blog article failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return articleId;
}
-(void)getBlogSiteCategories{
    __block BOOL done = NO;
    [[PIXNETSDK new] getBlogCategoriesListIncludeGroups:YES thumbs:YES completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"get site blog categories succeed");
        } else {
            XCTFail(@"get site blog categories failed: %@", error);
        }
        done = YES;

    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)sortCategories:(NSArray *)oCategories{
    __block BOOL done = NO;
    NSMutableArray *nCategories = [NSMutableArray new];
    for (NSDictionary *category in oCategories) {
        [nCategories addObject:category[@"id"]];
    }
    NSArray *rCategories = [[nCategories reverseObjectEnumerator] allObjects];
    [[PIXNETSDK new] sortBlogCategoriesTo:rCategories completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"get blog information succeed");
        } else {
            XCTFail(@"get blog information failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)updateBlogCategory:(NSString *)categoryId categoryType:(PIXBlogCategoryType)categoryType{
    __block BOOL done = NO;
    NSString *newName = nil;
    if (categoryType == PIXBlogCategoryTypeCategory) {
        newName = @"updated category name";
    } else {
        newName = @"updated folder name";
    }
    [[PIXNETSDK new] updateBlogCategoryFromID:categoryId newName:newName type:categoryType description:nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"update blog categories succeed");
        } else {
            //總是在修改 categoryType 為 category 的時候死掉
            XCTFail(@"update blog categories failed: %@, category name: %@, categoryId: %@", error, newName, categoryId);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)deleteBlogFoler:(NSString *)folderId{
    __block BOOL done = NO;
    [[PIXNETSDK new] deleteBlogFolderByID:folderId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"delete blog categories succeed");
        } else {
            XCTFail(@"delete blog categories failed: %@", error);
        }
        done = YES;
    }];

    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)deleteBlogCategory:(NSString *)categoryId{
    __block BOOL done = NO;
    [[PIXNETSDK new] deleteBlogCategoriesByID:categoryId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"delete blog categories succeed");
        } else {
            XCTFail(@"delete blog categories failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(NSString *)createBlogCategory:(PIXBlogCategoryType)categoryType{
    __block BOOL done = NO;
    __block NSString *idString = nil;
    [[PIXNETSDK new] createBlogCategoriesWithName:@"單元測試分類" type:categoryType description:nil siteCategory:nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            idString = result[@"category"][@"id"];
            NSLog(@"create blog category succeed: %@", idString);
        } else {
            XCTFail(@"create blog category failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return idString;
}
-(NSArray *)getBlogCategories{
    __block BOOL done = NO;
    __block NSArray *array = nil;
    [[PIXNETSDK new] getBlogCategoriesWithUserName:_testUser.userName password:nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            array = result[@"categories"];
            NSLog(@"get blog categories succeed");
        } else {
            XCTFail(@"get blog categories failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return array;
}
-(void)getBlogInformation{
    __block BOOL done = NO;
    [[PIXNETSDK new] getBlogInformationWithUserName:_testUser.userName completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"get blog information succeed");
        } else {
            XCTFail(@"get blog information failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
@end
