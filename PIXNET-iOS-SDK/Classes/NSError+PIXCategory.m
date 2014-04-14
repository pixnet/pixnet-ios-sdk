//
//  NSError+PIXCategory.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/10/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "NSError+PIXCategory.h"

@implementation NSError (PIXCategory)
+(instancetype)PIXErrorWithParameter:(NSString *)parameterName{
//    NSString *description = [NSString stringWithFormat:@"%@ 參數有誤，請檢查一下", parameterName];
//    NSError *error = [[super alloc] initWithDomain:kPIXErrorDomain code:kPIXErrorCode userInfo:@{NSLocalizedDescriptionKey: description}];
//    return error;
    return nil;
}
+(instancetype)PIXErrorWithServerResponse:(NSDictionary *)response{
    NSInteger errorCode = [response[@"error"] integerValue];
//    if (errorCode==0) {
//        return nil;
//    }

    NSString *description = response[@"message"];
    NSError *error = [[super alloc] initWithDomain:kPIXErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey: description}];
    return error;
}
@end
