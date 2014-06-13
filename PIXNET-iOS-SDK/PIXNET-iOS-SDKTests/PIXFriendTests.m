//
//  PIXFriendTests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/11/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
static NSString *kGroupName = @"test group";
static NSString *kNewGroupName = @"updated group";
static NSString *kSubscriptionGroupName = @"test subscription group";

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
    NSArray *friendships = [self getFriendship];
    //用不同的參數組合取得好友名單
    [self getFriendshipUsingPIXFriend];
    [self appendFriendInGroup:groupId];
    [self removeFriendInGroup:groupId];

    
    NSArray *subscriptions = [self getFriendSubscriptions];
    
    [self createSubscriptionGroup];
    NSArray *subscriptionGroups = [self getSubscriptionGroups];
    
    [self deleteAllTestSubscriptionsGroup:subscriptionGroups];
    [self deleteFriends];
    [self deleteGroup:groupId];
    [self deleteAllTestGroups:[self getGroups]];
}
-(NSArray *)getSubscriptionGroups{
    __block BOOL done = NO;
    __block NSArray *array;
    [[PIXNETSDK new] getFriendSubscriptionsGroupsWithCompletion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"getFriendSubscriptionsGroupsWithCompletion";
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
            array = result[@"subscription_groups"];
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
-(void)deleteAllTestSubscriptionsGroup:(NSArray *)groups{
    for (NSDictionary *subscription in groups) {
        if ([subscription[@"name"] isEqualToString:kSubscriptionGroupName]) {
            [self deleteSubscriptionGroup:subscription[@"id"]];
        }
    }
}
-(void)deleteSubscriptionGroup:(NSString *)groupId{
    __block BOOL done = NO;
    [[PIXFriend new] deleteFriendSubscriptionGroupWithGroupID:groupId completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"deleteFriendSubscriptionGroupWithGroupID";
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
-(NSString *)createSubscriptionGroup{
    __block BOOL done = NO;
    __block NSString *subId = nil;
    [[PIXNETSDK new] createFriendSubscriptionGroupWithGroupName:kSubscriptionGroupName completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"createFriendSubscriptionGroupWithGroupName";
        if (succeed) {
            subId = result[@"subscription_group"][@"id"];
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return subId;
}
-(NSArray *)getFriendSubscriptions{
    __block BOOL done = NO;
    __block NSArray *array;
    [[PIXNETSDK new] getFriendSubscriptionsWithPage:1 completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"getFriendSubscriptionsWithPage";
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
            array = result[@"subscriptions"];
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
-(void)getFriendshipUsingPIXFriend{
    __block BOOL done = NO;
    [[PIXFriend new] getFriendshipsWithSortType:PIXFriendshipsSortTypeUserId cursor:nil bidirectional:YES completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"getFriendshipsWithSortType";
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
-(NSArray *)getFriendship{
    __block BOOL done = NO;
    __block NSArray *array;
    [[PIXNETSDK new] getFriendshipsWithCursor:nil completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"getFriendshipsWithCursor";
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
            array = result[@"friend_pairs"];
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
-(void)deleteFriends{
    __block BOOL done = NO;
    for (NSString *friend in _testUser.friendNames) {
        [[PIXNETSDK new] deleteFriendshipWithFriendName:friend completion:^(BOOL succeed, id result, NSError *error) {
            NSString *methodName = @"deleteFriendshipWithFriendName";
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
    }
    return;
}
-(void)removeFriendInGroup:(NSString *)groupId{
    __block BOOL done = NO;
    for (NSString *friend in _testUser.friendNames) {
        [[PIXNETSDK new] removeFriendGroupWithFriendName:friend groupID:groupId completion:^(BOOL succeed, id result, NSError *error) {
            NSString *methodName = @"removeFriendGroupWithFriendName";
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
    }
    return;
}
-(void)appendFriendInGroup:(NSString *)groupId{
    __block BOOL done = NO;
    for (NSString *friend in _testUser.friendNames) {
        [[PIXNETSDK new] appendFriendGroupWithFriendName:friend groupID:groupId completion:^(BOOL succeed, id result, NSError *error) {
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
    }
    return;
}
-(void)createFriendship{
    __block BOOL done = NO;
    for (NSString *friend in _testUser.friendNames) {
        [[PIXNETSDK new] createFriendshipWithFriendName:friend completion:^(BOOL succeed, id result, NSError *error) {
            NSString *methodName = @"createFriendshipWithFriendName";
            if (succeed) {
                NSLog(@"%@ succeed", methodName);
            } else {
                if ([[error localizedDescription] isEqualToString:@"Add friend failed. Due to already friends or other reasons."]) {
                    NSLog(@"this friend is already exist, not a bug.");
                } else {
                    XCTFail(@"%@ failed: %@", methodName, error);
                }
            }
            done = YES;
        }];
        
        while (!done) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
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
