//
//  PIXFriendTests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/11/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
static NSString *kGroupName = @"test group";
static NSString *kNewGroupName = @"updated group";

#import <XCTest/XCTest.h>
#import "PIXNETSDK.h"
#import "UserForTest.h"

@interface PIXFriendTests : XCTestCase
@property (nonatomic, strong) UserForTest *testUser;

@end

@implementation PIXFriendTests

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
    [PIXNETSDK setConsumerKey:_testUser.consumerKey consumerSecret:_testUser.consumerSecret];
    
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
    NSString *groupId = [self createGroup];
    [self updateGroup:groupId];
    
    [self createFriendship];
    [self appendFriendInGroup:groupId];

    [self deleteGroup:groupId];
    [self deleteAllTestGroups:[self getGroups]];
}
-(void)appendFriendInGroup:(NSString *)groupId{
    __block BOOL done = NO;
    [[PIXNETSDK new] appendFriendGroupWithFriendName:_testUser.friendName groupID:groupId completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"appendFriendGroupWithFriendName";
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)createFriendship{
    __block BOOL done = NO;
    [[PIXNETSDK new] createFriendshipWithFriendName:_testUser.friendName completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"createFriendshipWithFriendName";
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)updateGroup:(NSString *)groupId{
    __block BOOL done = NO;
    [[PIXNETSDK new] updateFriendGroupWithGroupID:groupId newGroupName:kNewGroupName completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"deleteFriendGroupWithGroupID";
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)deleteAllTestGroups:(NSArray *)groups{
    for (NSDictionary *group in groups) {
        if ([group[@"name"] isEqualToString:kNewGroupName]) {
            [self deleteGroup:group[@"id"]];
        }
    }
    return;
}
-(void)deleteGroup:(NSString *)groupId{
    __block BOOL done = NO;
    [[PIXNETSDK new] deleteFriendGroupWithGroupID:groupId completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"deleteFriendGroupWithGroupID";
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(NSString *)createGroup{
    __block BOOL done = NO;
    __block NSString *groupId = nil;
    [[PIXNETSDK new] createFriendGroupsWithGroupName:kGroupName completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"createFriendGroupsWithGroupName";
        if (succeed) {
            groupId = result[@"friend_group"][@"id"];
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return groupId;
}
-(NSArray *)getGroups{
    __block BOOL done = NO;
    __block NSArray *array = nil;
    [[PIXNETSDK new] getFriendGroupsWithPage:1 Completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"getFriendGroupsWithPage";
        if (succeed) {
            array = result[@"friend_groups"];
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return array;
}
@end
