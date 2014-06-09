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
        return;
    }
    
    [self invokeMethod:@selector(callAPI:parameters:requestCompletion:) parameters:@[[NSString stringWithFormat:@"users/%@", userName], [NSNull null], completion] receiver:handler];
}

-(void)getAccountWithCompletion:(PIXHandlerCompletion)completion{
    PIXAPIHandler *handler = [self getPIXAPIHandler];

    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuthObj:uploadData:parameters:requestCompletion:) parameters:@[@"account", @"GET", @YES, [NSNull null], [NSNull null], completion] receiver:handler];
}



@end
