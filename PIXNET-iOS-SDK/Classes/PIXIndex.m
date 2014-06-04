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
    [[PIXAPIHandler new] callAPI:@"index/rate" parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, error);
        }
    }];
}
@end
