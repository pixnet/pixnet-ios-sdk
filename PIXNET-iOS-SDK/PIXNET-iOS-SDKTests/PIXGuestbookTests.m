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
    [self asyncToSyncWithTarget:[PIXNETSDK new] Method:@selector(getGuestbookMessagesWithUserName:cursor:completion:) params:@[_testUser.userName, [NSNull null], [NSNull null]]];
}
-(void)asyncToSyncWithTarget:(id)target Method:(SEL)method params:(NSArray *)params{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[PIXNETSDK instanceMethodSignatureForSelector:method]];
    [invocation setTarget:target];
    
    static int paramIndex = 2;
    for (__unsafe_unretained id param in params) {
        if (param != [params lastObject]) {
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
    [invocation setArgument:&completion atIndex:++paramIndex];
    [invocation setSelector:method];
    
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
    [invocation getArgument:&completion atIndex:paramIndex];
}

@end
