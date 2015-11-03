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
    //這個 bundle 的取得法超機歪！
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"PIXNET-iOS-SDK" ofType:@"bundle"];
    NSString *message = nil;
    if (bundlePath) {
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        message = NSLocalizedStringFromTableInBundle(response[@"code"], @"Localizable", bundle, nil);
    } else {
        message = NSLocalizedStringFromTableInBundle(response[@"code"], @"Localizable", [NSBundle mainBundle], nil);
    }
    //直接用 code 字串透過 Localizable.strings 轉成中文或英文說明
    NSInteger code = [response[@"code"] integerValue];
    NSError *error = [NSError errorWithDomain:kPIXErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: message}];
    return error;
}
+(instancetype)PIXErrorWithNSUIntegerFormat:(NSString *)integerName{
    NSString *message = [NSString stringWithFormat:@"%@ 值小於1或是大於2147483647了", integerName];
    NSError *error = [NSError errorWithDomain:kPIXErrorDomain code:PIXErrorDomainStatusInputParameter userInfo:@{NSLocalizedDescriptionKey:message}];
    return error;
}
@end
