//
//  PIXUserTests.m
//  PIXNET-iOS-SDK
//
//  Created by jnlin on 2014/4/9.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIXUser.h"
#import "PIXAPIHandler.h"

@interface PIXUserTests : XCTestCase

@end

@implementation PIXUserTests

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

- (void)testUser
{
    __block BOOL waitingForBlock = YES;
    
    PIXUser *user = [PIXUser new];
    
    [user getUserWithUserName:@"admin" completion:^(BOOL succeed, id result, NSError *error){
        waitingForBlock = NO;
        NSLog(@"%s", __PRETTY_FUNCTION__);
        NSLog(@"%@", error);
        XCTAssertTrue(succeed);
    }];
}

- (void)testAccount
{
    __block BOOL waitingForBlock = YES;
    
    PIXUser *user = [PIXUser new];
    
    // 故意不認證，應該會回傳 False
    [user getAccountWithCompletion:^(BOOL succeed, id result, NSError *error){
        waitingForBlock = NO;
        NSLog(@"%s", __PRETTY_FUNCTION__);
        NSLog(@"%@", error);
        XCTAssertFalse(succeed);
    }];

}

@end
