//
//  PIXBlockTests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin on 2014/6/17.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIXNETSDK.h"
#import "UserForTest.h"

@interface PIXBlockTests : XCTestCase
@property (nonatomic, strong) UserForTest *testUser;

@end

@implementation PIXBlockTests

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

- (void)testMain
{
    [PIXNETSDK setConsumerKey:_testUser.consumerKey consumerSecret:_testUser.consumerSecret callbackURL:_testUser.callbaclURL];
    
    //登出
    [PIXNETSDK logout];
    //登入
    BOOL authed = [self login];
    if (!authed) {
        return;
    }
    [self getBlocks];
    [self addBlock];
    [self deleteBlock];
}
-(void)deleteBlock{
    __block BOOL done = NO;
    [[PIXNETSDK new] deleteBlockWithUserName:_testUser.blockUsers[0] completion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        NSString *methodName = @"deleteBlockWithUserName";
        if (succeed) {
            NSLog(@"%@, succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)addBlock{
    __block BOOL done = NO;
    [[PIXNETSDK new] createBlockWithUserName:_testUser.blockUsers[0] completion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        NSString *methodName = @"createBlockWithUserName";
        if (succeed) {
            NSLog(@"%@, succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getBlocks{
    __block BOOL done = NO;
    [[PIXNETSDK new] getBlocksWithCompletion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        NSString *methodName = @"getBlocksWithCompletion";
        if (succeed) {
            NSLog(@"%@, succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(BOOL)login{
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
    return authed;
}
@end
