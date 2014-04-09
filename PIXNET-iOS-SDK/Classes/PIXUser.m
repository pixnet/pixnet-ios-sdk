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

-(id)getPIXAPIHandler{
    PIXAPIHandler *handler;
    if (self.apihandler == nil) {
        handler = [PIXAPIHandler new];
    } else {
        handler = self.apihandler;
    }
    return handler;
}

-(void)getUserWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion{
    PIXAPIHandler *handler = [self getPIXAPIHandler];
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

-(void)getAccountWithCompletion:(PIXHandlerCompletion)completion{
    PIXAPIHandler *handler = [self getPIXAPIHandler];

    [handler callAPI:@"account" httpMethod:@"GET" shouldAuth:YES parameters:nil  requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
        //檢查出去的參數
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
        
    }];
}



@end
