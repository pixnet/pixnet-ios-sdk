//
//  PIXUser.m
//  PIXNET-iOS-SDK
//
//  Created by jnlin on 2014/3/22.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//

#import "PIXUser.h"
#import "NSError+PIXCategory.h"
#import "NSObject+PIXCategory.h"

@implementation PIXUser

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
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing userName"]);
    }
    
    [handler callAPI:[NSString stringWithFormat:@"users/%@", userName] parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
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

    [handler callAPI:@"account" httpMethod:@"GET" shouldAuth:YES parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        //檢查出去的參數
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
        
    }];
}



@end
