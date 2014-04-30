//
//  NSDictionary+PIXCategory.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/16/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "NSDictionary+PIXCategory.h"
#import "NSArray+PIXCategory.h"

@implementation NSDictionary (PIXCategory)
- (NSDictionary *)PIXDictionaryByReplacingNullsWithBlanks{
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        id object = [self objectForKey:key];
        if (object == nul) {
            [replaced setObject:blank forKey:key];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
             [replaced setObject:[object PIXDictionaryByReplacingNullsWithBlanks] forKey:key];
        } else if ([object isKindOfClass:[NSArray class]]) {
            [replaced setObject:[object PIXArrayByReplacingNullsWithBlanks] forKey:key];
        } else if ([object isKindOfClass:[NSNumber class]]){
            [replaced setObject:[object stringValue] forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:[replaced copy]];
}
@end
