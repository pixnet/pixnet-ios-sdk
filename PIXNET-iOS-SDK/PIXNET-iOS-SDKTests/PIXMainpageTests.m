//
//  PIXMainpageTests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin on 2014/6/17.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIXNETSDK.h"
#import "UserForTest.h"
#import "PIXBlog.h"
#import "PIXAlbum.h"

@interface PIXMainpageTests : XCTestCase

@end

@implementation PIXMainpageTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMain
{
    [self getArticles];
    [self getAlbums];
    [self getVideos];
}
-(void)getVideos{
    for (PIXMainpageType type=0; type<=2 ; type++) {
        [self getVideosWithType:type];
    }
}
-(void)getVideosWithType:(PIXMainpageType)type{
    __block BOOL done = NO;
    [[PIXNETSDK new] getMainpageVideosWithVideoType:type page:1 perPage:3 completion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        NSString *methodName = @"getMainpageVideosWithVideoType";
        if (succeed) {
            NSLog(@"%@, succeed, type: %li, lastObject: %@", methodName, type, [result[@"elements"] lastObject][@"id"]);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getAlbums{
    __block BOOL done = NO;
    __block NSArray *categories = nil;
    [[PIXAlbum new] getAlbumSiteCategoriesWithIsIncludeGroups:NO isIncludeThumbs:NO completion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        NSString *methodName = @"getAlbumSiteCategoriesWithIsIncludeGroups";
        if (succeed) {
            NSLog(@"%@, succeed", methodName);
            categories = result[@"categories"];
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:categories.count];
    for (NSDictionary *category in categories) {
        [array addObject:category[@"id"]];
    }
    //隨機產生 categories 的 array
    for (int times=0; times<6; times++) {
        NSMutableArray *nArray = [NSMutableArray arrayWithArray:array];
        int arrayCount = arc4random()%categories.count + 1;
        for (int i=0; i<arrayCount; i++) {
            [nArray removeObjectAtIndex:arc4random()%nArray.count];
        }
        for (PIXMainpageType type=0; type<=2 ; type++) {
            [self getAlbumWithCategories:nArray type:type];
        }
    }
    return;
}
-(void)getAlbumWithCategories:(NSArray *)categories type:(PIXMainpageType)type{
    __block BOOL done = NO;
    [[PIXNETSDK new] getMainpageAlbumsWithCategoryIDs:categories albumType:type page:1 perPage:3 strictFilter:YES completion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        NSString *methodName = @"getMainpageAlbumsWithCategoryIDs";
        if (succeed) {
            NSLog(@"categoryes: %@", [categories componentsJoinedByString:@","]);
            NSLog(@"%@, succeed, categoryIds count: %li, albumType: %li, lastObject: %@", methodName, categories.count, type, [result[@"sets"] lastObject][@"id"]);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getArticles{
    __block BOOL done = NO;
    __block NSArray *categories = nil;
    [[PIXBlog new] getBlogCategoriesListIncludeGroups:NO thumbs:NO completion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        NSString *methodName = @"getBlocksWithCompletion";
        if (succeed) {
            NSLog(@"%@, succeed", methodName);
            categories = result[@"categories"];
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    for (NSDictionary *category in categories) {
        for (PIXMainpageType type=0; type<=2 ; type++) {
            [self getArticlesWithCategoryId:category[@"id"] articleType:type];
        }
    }
    return;
}
-(void)getArticlesWithCategoryId:(NSString *)categoryId articleType:(PIXMainpageType)articleType{
    __block BOOL done = NO;
    [[PIXNETSDK new] getMainpageBlogCategoriesWithCategoryID:categoryId articleType:articleType page:1 perPage:10 completion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        NSString *methodName = @"getMainpageBlogCategoriesWithCategoryID";
        if (succeed) {
            NSLog(@"%@, succeed, categoryId: %@, articleType: %li", methodName, categoryId, articleType);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
@end
