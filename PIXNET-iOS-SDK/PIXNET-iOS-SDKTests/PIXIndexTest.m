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
    [[PIXNETSDK new] getIndexRateWithCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"get index rate succeed");
        } else {
            XCTFail(@"get index rate failed: %@", error);
        }
    }];
}

@end
