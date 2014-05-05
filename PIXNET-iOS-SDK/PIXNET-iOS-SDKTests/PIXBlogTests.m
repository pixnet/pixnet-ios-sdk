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
    //取得使用者部落格資訊
    [self getBlogInformation];
    //取得使用者部落格分類資訊
    [self getBlogCategories];
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
