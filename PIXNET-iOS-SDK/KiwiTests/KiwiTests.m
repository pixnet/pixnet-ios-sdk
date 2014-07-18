//
//  KiwiTests.m
//  KiwiTests
//
//  Created by Dolphin Su on 7/17/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
#import <Kiwi.h>
//#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "PIXNETSDK.h"

SPEC_BEGIN(FirstTest)
    describe(@"test login", ^{
        it(@"simple test", ^{
            NSUInteger a = 6;
            [[theValue(a) should] equal:@(6)];
        });
    });
    describe(@"mock test", ^{
       describe(@"simple mock test", ^{
           id resultMock = [OCMockObject mockForClass:[NSDictionary class]];
           [[resultMock should] beMemberOfClass:[NSDictionary class]];
           
       });
    });
SPEC_END