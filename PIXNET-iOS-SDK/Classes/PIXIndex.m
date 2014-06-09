//
//  PIXIndex.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/4/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "PIXIndex.h"
#import "NSObject+PIXCategory.h"
#import "NSError+PIXCategory.h"

@implementation PIXIndex
-(void)getIndexRateWithCompletion:(PIXHandlerCompletion)completion{
    NSArray *params = @[@"index/rate", [NSNull null], completion];
    [self invokeMethod:@selector(callAPI:parameters:requestCompletion:) parameters:params receiver:[PIXAPIHandler new]];
//    [[PIXAPIHandler new] callAPI:@"index/rate" parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
//        if (succeed) {
//            [self succeedHandleWithData:result completion:completion];
//        } else {
//            completion(NO, nil, error);
//        }
//    }];
}
-(void)getIndexNowWithCompletion:(PIXHandlerCompletion)completion{
    NSArray *params = @[@"index/now", [NSNull null], completion];
    [self invokeMethod:@selector(callAPI:parameters:requestCompletion:) parameters:params receiver:[PIXAPIHandler new]];
//    [[PIXAPIHandler new] callAPI:@"index/now" parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
//        if (succeed) {
//            [self succeedHandleWithData:result completion:completion];
//        } else {
//            completion(NO, nil, error);
//        }
//    }];
}
@end
