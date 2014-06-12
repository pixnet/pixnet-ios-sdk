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
            completion(NO, nil, [NSError PIXErrorWithServerResponse:dict]);
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
-(void)invokeMethod:(SEL)method parameters:(NSArray *)parameters receiver:(id)receiver{
    NSMethodSignature *signature = [receiver methodSignatureForSelector:method];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:receiver];
    [invocation setSelector:method];
    
    //這個 completion 物件用來處理 handler 丟回來的 data。它將 data 判斷並轉成 dictionary 後再丟回去給原來的 completion
    PIXHandlerCompletion preCompletion;
    
    for (__unsafe_unretained id parameter in parameters) {
        NSUInteger paramIndex = [parameters indexOfObject:parameter]+2;
        if ([parameter isKindOfClass:NSClassFromString(@"NSBlock")]) {
            PIXHandlerCompletion oComp = parameter;
            preCompletion = ^(BOOL succeed, id result, NSError *error) {
                if (succeed) {
                    [self succeedHandleWithData:result completion:oComp];
                } else {
                    oComp(NO, nil, error);
                }
            };
            [invocation setArgument:&preCompletion atIndex:paramIndex];
        } else if ([parameter isKindOfClass:[NSNumber class]]) {
            //將 NSNumber 物件轉成 int 後再丟給 method 用
            NSNumber *number = (NSNumber *)parameter;
            NSInteger numberValue = [number integerValue];
            [invocation setArgument:&numberValue atIndex:paramIndex];
        } else {
            [invocation setArgument:&parameter atIndex:paramIndex];
        }
    }
    [invocation performSelector:@selector(invoke) withObject:nil];
}
@end
