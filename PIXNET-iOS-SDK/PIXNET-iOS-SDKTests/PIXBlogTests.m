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
    
    [PIXNETSDK authByXauthWithUserName:_testUser.userName userPassword:_testUser.userPassword requestCompletion:^(BOOL succeed, id result, NSError *error) {
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
    
    //刪除部落格個人分類
    [self deleteBlogCategory:categoryId categoryType:PIXBlogCategoryTypeCategory];
    [self deleteBlogCategory:folderId categoryType:PIXBlogCategoryTypeFolder];
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
            XCTFail(@"update blog categories failed: %@, category name: %@", error, newName);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)deleteBlogCategory:(NSString *)categoryId categoryType:(PIXBlogCategoryType)categoryType{
    __block BOOL done = NO;
    if (categoryId == PIXBlogCategoryTypeCategory) {
        [[PIXNETSDK new] deleteBlogCategoriesByID:categoryId completion:^(BOOL succeed, id result, NSError *error) {
            if (succeed) {
                NSLog(@"delete blog categories succeed");
            } else {
                XCTFail(@"delete blog categories failed: %@", error);
            }
            done = YES;
        }];
    } else {
        [[PIXNETSDK new] deleteBlogFolderByID:categoryId completion:^(BOOL succeed, id result, NSError *error) {
            if (succeed) {
                NSLog(@"delete blog categories succeed");
            } else {
                XCTFail(@"delete blog categories failed: %@", error);
            }
            done = YES;
        }];
    }
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(NSString *)createBlogCategory:(PIXBlogCategoryType)categoryType{
    __block BOOL done = NO;
    __block NSString *idString = nil;
    [[PIXNETSDK new] createBlogCategoriesWithName:@"單元測試分類" type:PIXBlogCategoryTypeFolder description:nil siteCategory:nil completion:^(BOOL succeed, id result, NSError *error) {
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
