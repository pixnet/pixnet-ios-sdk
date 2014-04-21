//
//  NSObject+PIXCategory.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/10/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//

#import "NSObject+PIXCategory.h"
#import "NSError+PIXCategory.h"
#import "NSDictionary+PIXCategory.h"

@implementation NSObject (PIXCategory)
-(void)succeedHandleWithData:(id)data completion:(PIXHandlerCompletion)completion{
    NSError *jsonError;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    if (jsonError == nil) {
        if ([dict[@"error"] intValue] == 0) {
            completion(YES, [dict PIXDictionaryByReplacingNullsWithBlanks], nil);
        } else {
            completion(NO, nil, [NSError errorWithDomain:kPIXErrorDomain code:PIXErrorDomainStatusServerResponse userInfo:dict[@"message"]]);
        }
    } else {
        completion(NO, nil, jsonError);
    }
}
+(BOOL)PIXCheckNSUIntegerValid:(NSUInteger)integer{
    if (integer<=0 || integer>INT32_MAX) {
        return NO;
    } else {
        return YES;
    }
}
@end
