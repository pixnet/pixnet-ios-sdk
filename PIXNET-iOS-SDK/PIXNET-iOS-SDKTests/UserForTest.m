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
        _userName = @"dolphinsue";
        _userPassword = @"pixnetSue319";
        _consumerKey = @"0ef5425eaa54c7d5bb6956b97471cde5";
        _consumerSecret = @"09558d31bfc9763e3f4f7f3e27f3afff";
    }
    return self;
}
@end