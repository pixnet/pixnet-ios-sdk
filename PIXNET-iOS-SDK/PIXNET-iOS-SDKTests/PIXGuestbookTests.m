//
//  PIXGuestbookTests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/9/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIXNETSDK.h"
#import "UserForTest.h"

@interface PIXGuestbookTests : XCTestCase
@property (nonatomic, strong) UserForTest *testUser;

@end

@implementation PIXGuestbookTests

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

- (void)testGetGuestbookMessages
{
    [self asyncToSyncWithTarget:[PIXNETSDK new] Method:@selector(getGuestbookMessagesWithUserName:cursor:completion:) params:@[_testUser.userName, [NSNull null]]];
}
- (void)testAuthNeededMethods
{
    [PIXNETSDK setConsumerKey:_testUser.consumerKey consumerSecret:_testUser.consumerSecret];
    __block BOOL done = NO;
    
    [PIXNETSDK logout];
    
    __block BOOL authed = NO;
    //登入
    [PIXNETSDK authByXauthWithUserName:_testUser.userName userPassword:_testUser.userPassword requestCompletion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        if (succeed) {
            NSLog(@"auth succeed!");
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
    NSString *messageId = [self createMessage];
    
}
-(NSString *)createMessage{
    __block NSString *messageId = nil;
    __block BOOL done = NO;
    [[PIXNETSDK new] createGuestbookMessageWithUserName:_testUser.userName body:@"message body 7788" author:_testUser.userName title:@"message title 5566" email:nil isOpen:YES completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"createGuestbookMessageWithUserName";
        if (succeed) {
            messageId = result[@"article"][@"id"];
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return messageId;
}
-(void)asyncToSyncWithTarget:(id)target Method:(SEL)method params:(NSArray *)params{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:method]];
    [invocation setTarget:target];
    
    static int paramIndex = 2;
    for (__unsafe_unretained id param in params) {
        if ([param isKindOfClass:[NSNumber class]]) {
            NSNumber *number = (NSNumber *)param;
            NSInteger numberInt = [number boolValue];
            [invocation setArgument:&numberInt atIndex:paramIndex++];
        } else {
            [invocation setArgument:&param atIndex:paramIndex++];
        }
    }
    PIXHandlerCompletion completion = ^(BOOL succeed, id result, NSError *error){
        NSString *methodName = NSStringFromSelector(method);
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
    };
    [invocation setArgument:&completion atIndex:paramIndex];
    [invocation setSelector:method];
    
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
    [invocation getArgument:&completion atIndex:paramIndex];
}

@end
