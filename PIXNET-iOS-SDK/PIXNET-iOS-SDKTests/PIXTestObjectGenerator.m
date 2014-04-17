//
//  PIXTestObjectGenerator.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/16/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "PIXTestObjectGenerator.h"

@implementation PIXTestObjectGenerator
+(NSDictionary *)PIXTestDictionary{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[self PIXNumbersArray] forKey:@"NSNumbersArray"];
    [dict setObject:[self PIXStringsArray] forKey:@"NSStringsArray"];
    return dict;
}
+(NSString *)PIXTestStringByRandomWithLength:(NSUInteger)length{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&*()_+=[]\{}|`<>?,./";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}
+(NSArray *)PIXNumbersArray{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@(0)];
    [array addObject:@(1)];
    [array addObject:@(-1)];
    [array addObject:@(INT8_MAX)];
    [array addObject:@(INT16_MAX)];
    [array addObject:@(INT32_MAX)];
    [array addObject:@(INT64_MAX)];
    [array addObject:@(INT8_MIN)];
    [array addObject:@(INT16_MIN)];
    [array addObject:@(INT32_MIN)];
    [array addObject:@(INT64_MIN)];
    [array addObject:[NSNull null]];
    return array;
}
+(NSArray *)PIXStringsArray{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@""];
    [array addObject:[NSNull null]];
    [array addObject:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&*()_+=[]\{}|`<>?,./\""];
    return array;
}
@end
