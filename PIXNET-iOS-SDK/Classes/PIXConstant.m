//
//  PIXConstant.m
//  PIXNET-iOS-SDK
//
//  Created by jnlin on 2014/3/22.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import "PIXConstant.h"

@implementation PIXConstant

@synthesize msgFmtRequiredParameter;
@synthesize msgMissingUserName;

+ (id)sharedConstant{
    static PIXConstant *sharedConstant = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConstant = [[self alloc] init];
    });
    return sharedConstant;
}

- (id)init {
    if (self = [super init]) {
        msgFmtRequiredParameter = @"Missing required parameter %s";
        msgMissingUserName = @"Missing userName";
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
