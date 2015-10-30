//
//  PIXGlossary.m
//  PIXNET-iOS-SDK
//
//  Created by dennis on 2015/10/30.
//  Copyright © 2015年 Dolphin Su. All rights reserved.
//

#import "PIXGlossary.h"
#import "NSError+PIXCategory.h"
#import "NSObject+PIXCategory.h"

@implementation PIXGlossary

-(void)getTWZipCodeWithVersioin:(NSString *)version isFetch:(BOOL)isFetch completion:(PIXHandlerCompletion)completion{
    if (!version || version.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing version"]);
        return;
    }
    [[PIXAPIHandler new] callAPI:@"glossary/twzipcode" httpMethod:@"GET" parameters:@{@"version":version, @"fetch":[NSString stringWithFormat:@"%i",isFetch]} requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}
@end
