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
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:)
//            parameters:@[@"blocks", @"GET", @YES, [NSNull null], completion] receiver:[PIXAPIHandler new]];
}
-(void)createBlockWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion{
    if (!userName || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName 參數有誤"]);
        return;
    }
    [[PIXAPIHandler new] callAPI:@"blocks/create" httpMethod:@"POST" shouldAuth:YES parameters:@{@"user":userName} requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:)
//            parameters:@[@"blocks/create", @"POST", @YES, @{@"user":userName}, completion]
//              receiver:[PIXAPIHandler new]];
}
-(void)deleteBlockWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion{
    if (!userName || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName 參數有誤"]);
        return;
    }
    [[PIXAPIHandler new] callAPI:@"blocks/delete" httpMethod:@"POST" shouldAuth:YES parameters:@{@"user":userName, @"_method":@"delete"} requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:)
//            parameters:@[@"blocks/delete", @"POST", @YES, @{@"user":userName, @"_method":@"delete"}, completion]
//              receiver:[PIXAPIHandler new]];
}
@end
