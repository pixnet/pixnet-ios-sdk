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
    
    NSString *subscriptionId = [self createSubscriptionGroup];
    [self updateSubscriptionGroup:subscriptionId];
    NSArray *subscriptionGroups = [self getSubscriptionGroups];
    [self createSubscriptionsWithUser:_testUser.subscriptionUser inGroups:subscriptionGroups];
    [self addOrRemoveUserWithGroup:subscriptionGroups isAdd:NO];
    [self addOrRemoveUserWithGroup:subscriptionGroups isAdd:YES];
    [self getNewsWithSubscriptionGroups:subscriptionGroups];

    //取得訂閱名單
    NSArray *subscriptions = [self getFriendSubscriptions];
    [self sortSbscriptionGroups:subscriptionGroups];
    
    [self deleteAllTestSubscriptionsGroup:subscriptionGroups];
    [self deleteSubscription];
    [self deleteFriends];
    [self deleteAllTestGroups:[self getGroups]];
}
//終於有時間寫所有參數的測試了！
-(void)getNewsWithSubscriptionGroups:(NSArray *)subscriptionGroups{
    for (PIXFriendNewsType newsType=0; newsType<=1; newsType++) {
        for (NSDictionary *group in subscriptionGroups) {
            NSString *groupId = group[@"id"];
            for (BOOL haveTime=0; haveTime<=1; haveTime++) {
                NSDate *date = nil;
                if (haveTime) {
                     date = [NSDate dateWithTimeIntervalSince1970:933120000];
                }
                [self getNewsWithNewsType:newsType subscriptionGroup:groupId beforeTime:date];
            }
        }
    }
    return;
}
-(void)getNewsWithNewsType:(PIXFriendNewsType)newsType subscriptionGroup:(NSString *)groupId beforeTime:(NSDate *)beforeTime{
    __block BOOL done = NO;
    [[PIXNETSDK new] getFriendNewsWithNewsType:newsType groupID:groupId beforeTime:beforeTime completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"getFriendNewsWithNewsType";
        NSLog(@"newsType: %i, groupId: %@, beforeTime: %@", newsType, groupId, beforeTime);
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: error:%@", methodName, error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)sortSbscriptionGroups:(NSArray *)groups{
    __block BOOL done = NO;
    NSMutableArray *oArray = [NSMutableArray arrayWithCapacity:groups.count];
    for (NSDictionary *group in groups) {
        [oArray addObject:group[@"id"]];
    }
    NSArray *sorted = [[oArray reverseObjectEnumerator] allObjects];
    [[PIXNETSDK new] positionFriendSubscriptionGroupsWithSortedGroups:sorted completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"positionFriendSubscriptionGroupsWithSortedGroups";
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: error:%@", methodName, error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;

//    PIXNETSDK *sdk = [PIXNETSDK new];
//    SEL selector = @selector(positionFriendSubscriptionGroupsWithSortedGroups:completion:);
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[sdk methodSignatureForSelector:selector]];
//    NSArray *sorted = [[groups reverseObjectEnumerator] allObjects];
//    [invocation setArgument:&sorted atIndex:2];
//    PIXHandlerCompletion completion = [self completionWithSelector:selector];
//    [invocation setArgument:&completion atIndex:3];
//    
//    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
}
-(void)updateSubscriptionGroup:(NSString *)groupId{
    PIXNETSDK *sdk = [PIXNETSDK new];
    SEL selector = @selector(updateFriendSubscriptionGroupWithGroupID:newGroupName:completion:);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[sdk methodSignatureForSelector:selector]];
    [invocation setArgument:&groupId atIndex:2];
    [invocation setArgument:&kNewGroupName atIndex:3];
    PIXHandlerCompletion completion = [self completionWithSelector:selector];
    [invocation setArgument:&completion atIndex:4];
    
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
}
-(void)addOrRemoveUserWithGroup:(NSArray *)groups isAdd:(BOOL)isAdd{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:groups.count];
    for (NSDictionary *group in groups) {
        [array addObject:group[@"id"]];
    }
    SEL selector;
    if (isAdd) {
        selector = @selector(joinFriendSubscriptionGroupsWithUserName:groupIDs:completion:);
    } else {
        selector = @selector(leaveFriendSubscriptionGroupsWithUserName:groupIDs:completion:);
    }
    PIXNETSDK *sdk = [PIXNETSDK new];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[sdk methodSignatureForSelector:selector]];
    NSString *user = _testUser.subscriptionUser;
    [invocation setArgument:&user atIndex:2];
    [invocation setArgument:&array atIndex:3];
    PIXHandlerCompletion completion = [self completionWithSelector:selector];
    [invocation setArgument:&completion atIndex:4];
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
}
-(void)deleteSubscription{
    __block BOOL done = NO;
    [[PIXFriend new] deleteFriendSubscriptionWithUserName:_testUser.subscriptionUser completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"deleteFriendSubscriptionWithUserName";
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
-(void)createSubscriptionsWithUser:(NSString *)user inGroups:(NSArray *)groups{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:groups.count];
    for (NSDictionary *group in groups) {
        [array addObject:group[@"id"]];
    }
    __block BOOL done = NO;
    [[PIXFriend new] createFriendSubscriptionWithUserName:user groupIDs:array completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"createFriendSubscriptionWithFriendName";
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
-(NSArray *)getSubscriptionGroups{
    __block BOOL done = NO;
    __block NSArray *array;
    [[PIXNETSDK new] getFriendSubscriptionGroupsWithCompletion:^(BOOL succeed, id result, NSError *error) {
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
-(PIXHandlerCompletion)completionWithSelector:(SEL)selector{
    return ^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"%@ succeed", NSStringFromSelector(selector));
        } else {
            XCTFail(@"%@ failed: %@", NSStringFromSelector(selector), error);
        }
    };
}
@end
