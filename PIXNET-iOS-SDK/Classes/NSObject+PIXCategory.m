//
//  NSObject+PIXCategory.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/10/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "NSObject+PIXCategory.h"

@implementation NSObject (PIXCategory)
-(void)succeedHandleWithData:(id)data completion:(PIXHandlerCompletion)completion{
    NSError *jsonError;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    if (jsonError == nil) {
        if ([dict[@"error"] intValue] == 0) {
            completion(YES, dict, nil);
        } else {
            completion(NO, nil, dict[@"message"]);
        }
    } else {
        completion(NO, nil, jsonError.localizedDescription);
    }
}

@end
