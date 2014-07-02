//
//  PIXGuestbookTests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/9/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
static NSString *kMessageTitle = @"message title 5566";

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

- (void)testMain
{
    [PIXNETSDK setConsumerKey:_testUser.consumerKey consumerSecret:_testUser.consumerSecret callbackURL:_testUser.callbaclURL];
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
    [self getMessage:messageId];
    [self setMessageState:@"close" messageId:messageId];
    [self setMessageState:@"open" messageId:messageId];
    [self setMessageState:@"spam" messageId:messageId];
    [self setMessageState:@"ham" messageId:messageId];
    
    [self replyMessage:messageId];
    [self deleteMessage:messageId];
    
    NSArray *messages = [self getAllMessages];
    [self deleteAllTestMessagesInAllMessage:messages];
}
//這個 method 同時可測 open, close, as_mark, as_ham
-(void)setMessageState:(NSString *)state messageId:(NSString *)messageId{
    NSDictionary *selectors = @{@"open": NSStringFromSelector(@selector(markGuestbookMessageAsOpenWithMessageID:completion:)),
                                @"close": NSStringFromSelector(@selector(markGuestbookMessageAsCloseWithMessageID:completion:)),
                                @"spam": NSStringFromSelector(@selector(markGuestbookMessageAsSpamWithMessageID:completion:)),
                                @"ham": NSStringFromSelector(@selector(markGuestbookMessageAsHamWithMessageID:completion:))};
    SEL targetSelector = NSSelectorFromString(selectors[state]);
    
    PIXNETSDK *sdk = [PIXNETSDK new];
    NSMethodSignature *sign = [sdk methodSignatureForSelector:targetSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sign];
    [invocation setTarget:sdk];
    [invocation setSelector:targetSelector];
    [invocation setArgument:&messageId atIndex:2];
    PIXHandlerCompletion completion = ^(BOOL succeed, id result, NSError *error){
        NSString *methodName = NSStringFromSelector(targetSelector);
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
    };
    [invocation setArgument:&completion atIndex:3];
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
    return;
}
-(void)replyMessage:(NSString *)messageId{
    __block BOOL done = NO;
    [[PIXNETSDK new] replyGuestbookMessageWithMessageID:messageId body:@"reply 5566 and 7788" completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"replyGuestbookMessageWithMessageID";
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
-(void)getMessage:(NSString *)messageId{
    __block BOOL done = NO;
    [[PIXNETSDK new] getGuestbookMessageWithMessageID:messageId userName:_testUser.userName completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"getGuestbookMessageWithMessageID";
        if (succeed) {
            if ([result[@"article"][@"title"] isEqualToString:kMessageTitle]) {
                NSLog(@"%@ succeed", methodName);
            } else {
                XCTFail(@"%@ failed: %@", methodName, error);
            }
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
-(void)deleteAllTestMessagesInAllMessage:(NSArray *)messages{
    for (NSDictionary *message in messages) {
        if ([message[@"title"] isEqualToString:kMessageTitle]) {
            [self deleteMessage:message[@"id"]];
        }
    }
}
-(NSArray *)getAllMessages{
    __block BOOL done = NO;
    __block NSArray *array;
    [[PIXNETSDK new] getGuestbookMessagesWithUserName:_testUser.userName cursor:nil completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"getGuestbookMessagesWithUserName";
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
            array = result[@"articles"];
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
-(void)deleteMessage:(NSString *)messageId{
    __block BOOL done = NO;
    [[PIXNETSDK new] deleteGuestbookMessageWithMessageID:messageId completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"deleteGuestbookMessageWithMessageID";
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
-(NSString *)createMessage{
    __block NSString *messageId = nil;
    __block BOOL done = NO;
    [[PIXNETSDK new] createGuestbookMessageWithUserName:_testUser.userName body:@"message body 7788" author:_testUser.userName title:kMessageTitle email:nil isOpen:YES completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"createGuestbookMessageWithUserName";
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
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
