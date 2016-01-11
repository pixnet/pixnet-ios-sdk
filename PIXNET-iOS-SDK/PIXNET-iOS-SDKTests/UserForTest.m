//
//  UserForTest.m
//  PIXNET-iOS-SDK
//
//  Created by dennis on 2015/10/1.
//  Copyright © 2015年 Dolphin Su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserForTest.h"

@implementation UserForTest
-(instancetype)init{
    if (self=[super init]) {
        _userName = @"test28";
        _userPassword = @"youcannotpass";
    }
    return self;
}
@end