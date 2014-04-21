//
//  NSError+PIXCategory.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/10/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//

#import "NSError+PIXCategory.h"

@implementation NSError (PIXCategory)
+(instancetype)PIXErrorWithHTTPStatusCode:(NSInteger)code{
    NSError *error = [NSError errorWithDomain:kPIXHTTPErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: [NSHTTPURLResponse localizedStringForStatusCode:code]}];
    return error;
}
+(instancetype)PIXErrorWithParameterName:(NSString *)parameterName{
    NSString *message = [NSString stringWithFormat:@"%@", parameterName];
    NSError *error = [NSError errorWithDomain:kPIXErrorDomain code:PIXErrorDomainStatusInputParameter userInfo:@{NSLocalizedDescriptionKey: message}];
    return error;
}
+(instancetype)PIXErrorWithServerResponse:(NSDictionary *)response{
    NSString *message = response[@"message"];
    NSInteger code = [response[@"error"] integerValue];
    NSError *error = [NSError errorWithDomain:kPIXErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: message}];
    return error;
}
+(instancetype)PIXErrorWithNSUIntegerFormat:(NSString *)integerName{
    NSString *message = [NSString stringWithFormat:@"%@ 值小於1或是大於2147483647了", integerName];
    NSError *error = [NSError errorWithDomain:kPIXErrorDomain code:PIXErrorDomainStatusInputParameter userInfo:@{NSLocalizedDescriptionKey:message}];
    return error;
}
@end
