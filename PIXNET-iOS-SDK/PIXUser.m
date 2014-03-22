//
//  PIXUser.m
//  PIXNET-iOS-SDK
//
//  Created by jnlin on 2014/3/22.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import "PIXUser.h"

@implementation PIXUser

-(void)getUserWithUserName:(NSString *)userName completion:(RequestCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSString stringWithFormat:MsgFmtRequiredParameter, "User"]);
    }
    NSString *api = [NSString stringWithFormat:@"users/%@", userName];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    
}


@end
