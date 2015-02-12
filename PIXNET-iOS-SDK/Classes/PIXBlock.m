//
//  PIXBlock.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin on 2014/6/17.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import "PIXBlock.h"
#import "NSObject+PIXCategory.h"
#import "NSError+PIXCategory.h"

@implementation PIXBlock
-(void)getBlocksWithCompletion:(PIXHandlerCompletion)completion{
    [[PIXAPIHandler new] callAPI:@"blocks" httpMethod:@"GET" shouldAuth:YES parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}
-(void)createBlockWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion{
    if (!userName || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName 參數有誤"]);
        return;
    }
    [[PIXAPIHandler new] callAPI:@"blocks/create" httpMethod:@"POST" shouldAuth:YES parameters:@{@"user":userName} requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}


-(void)deleteBlockWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion{
    if (!userName || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName 參數有誤"]);
        return;
    }
    [[PIXAPIHandler new] callAPI:@"blocks/delete" httpMethod:@"POST" shouldAuth:YES parameters:@{@"user":userName, @"_method":@"delete"} requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}

- (void)updateBlockWithUsers:(NSArray *)users isAddToBlock:(BOOL)isAddToBlock completion:(PIXHandlerCompletion)completion {
    if (!users || users.count == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"users 是必要參數"]);
        return;
    }
    for (id o in users) {
        if (![o isKindOfClass:[NSString class]]) {
            completion(NO, nil, [NSError PIXErrorWithParameterName:@"users 每一個值都要是 string"]);
            return;
        }
    }
    NSString *path = @"create";
    if (!isAddToBlock) {
        path = @"delete";
    }
    NSDictionary *params = @{@"user":[users componentsJoinedByString:@","]};
    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blocks/%@", path] httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}

@end
