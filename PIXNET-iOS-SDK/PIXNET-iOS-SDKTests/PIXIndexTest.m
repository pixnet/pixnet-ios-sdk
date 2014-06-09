//
//  PIXIndexTest.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/4/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIXNETSDK.h"

@interface PIXIndexTest : XCTestCase

@end

@implementation PIXIndexTest

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

- (void)testRate{
    [self asyncToSyncWithTarget:[PIXNETSDK new] Method:@selector(getIndexRateWithCompletion:) params:nil];
//    [[PIXNETSDK new] getIndexRateWithCompletion:^(BOOL succeed, id result, NSError *error) {
//        if (succeed) {
//            NSLog(@"get index rate succeed");
//        } else {
//            XCTFail(@"get index rate failed: %@", error);
//        }
//    }];
}

-(void)testNow{
    PIXNETSDK *sdk = [PIXNETSDK new];
//    PIXHandlerCompletion completion = ^(BOOL succeed, id result, NSError *error){};
    [self asyncToSyncWithTarget:sdk Method:@selector(getIndexNowWithcompletion:) params:nil];
//    [[PIXNETSDK new] getIndexNowWithcompletion:^(BOOL succeed, id result, NSError *error) {
//        if (succeed) {
//            NSLog(@"get server now");
//        } else {
//            XCTFail(@"get server now failed: %@", error);
//        }
//    }];
}
-(void)asyncToSyncWithTarget:(id)target Method:(SEL)method params:(NSArray *)params{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[PIXNETSDK instanceMethodSignatureForSelector:method]];
    [invocation setTarget:target];

    static int paramIndex = 2;
    for (id param in params) {
        [invocation setArgument:(__bridge void *)(param) atIndex:paramIndex++];
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
