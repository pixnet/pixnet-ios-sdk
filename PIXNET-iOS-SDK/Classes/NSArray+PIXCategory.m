//
//  NSArray+PIXCategory.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/16/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "NSArray+PIXCategory.h"
#import "NSDictionary+PIXCategory.h"
@implementation NSArray (PIXCategory)
- (NSArray *)PIXArrayByReplacingNullsWithBlanks{
    NSMutableArray *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    for (int idx = 0; idx < [replaced count]; idx++) {
        id object = [replaced objectAtIndex:idx];
        if (object == nul) {
            [replaced replaceObjectAtIndex:idx withObject:blank];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            [replaced replaceObjectAtIndex:idx withObject:[object PIXDictionaryByReplacingNullsWithBlanks]];
        } else if ([object isKindOfClass:[NSArray class]]) {
            [replaced replaceObjectAtIndex:idx withObject:[object PIXArrayByReplacingNullsWithBlanks]];
        } else if ([object isKindOfClass:[NSNumber class]]){
            [replaced replaceObjectAtIndex:idx withObject:[object stringValue]];
        }
    }
    return [replaced copy];
}
@end
