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
    
    //取得使用者部落格資訊
    [self getBlogInformation];
    //取得使用者部落格分類資訊
    [self getBlogCategories];
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
    
    //刪除部落格個人分類
    [self deleteBlogCategory:categoryId categoryType:PIXBlogCategoryTypeCategory];
    [self deleteBlogCategory:folderId categoryType:PIXBlogCategoryTypeFolder];
}
-(void)updateBlogCategory:(NSString *)categoryId categoryType:(PIXBlogCategoryType)categoryType{
    __block BOOL done = NO;
    [[PIXNETSDK new] getBlogCategoriesWithUserName:_testUser.userName password:nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"get blog categories succeed");
        } else {
            XCTFail(@"get blog categories failed: %@", error);
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
    [[PIXNETSDK new] createBlogCategoriesWithName:@"單元測試分類" type:PIXBlogCategoryTypeFolder description:nil siteCategory:PIXSiteBlogCategoryWorldTravel completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            idString = result[@"category"][@"id"];
            NSLog(@"create blog category succeed: %@", result);
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
-(void)getBlogCategories{
    __block BOOL done = NO;
    [[PIXNETSDK new] getBlogCategoriesWithUserName:_testUser.userName password:nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"get blog categories succeed");
        } else {
            XCTFail(@"get blog categories failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
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
