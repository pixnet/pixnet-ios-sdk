//
//  PIXUser.m
//  PIXNET-iOS-SDK
//
//  Created by jnlin on 2014/3/22.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import "PIXUser.h"

@implementation PIXUser

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

// 傳 PIXAPIHandler 給測試用
-(void)getAccountWithCompletion:(PIXHandlerCompletion)completion handler:(PIXAPIHandler *)handler{
    [handler callAPI:@"account" httpMethod:@"GET" shouldAuth:YES parameters:nil  requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
        //檢查出去的參數
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
        
    }];
}

-(void)getUserWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion handler:(PIXAPIHandler *)handler{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"Missing userName");
    }
    
    [handler callAPI:[NSString stringWithFormat:@"users/%@", userName] parameters:nil requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
        //檢查出去的參數
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
        
    }];
}

-(void)getUserWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion{
    PIXAPIHandler *handler = [PIXAPIHandler new];
    [self getUserWithUserName:userName completion:completion handler:handler];
}

-(void)getAccountWithCompletion:(PIXHandlerCompletion)completion{
    PIXAPIHandler *handler = [PIXAPIHandler new];
    [self getAccountWithCompletion:completion handler:handler];
}



@end
