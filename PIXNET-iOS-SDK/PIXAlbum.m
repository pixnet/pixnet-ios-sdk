//
//  PIXAlbum.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/20/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "PIXAlbum.h"

@implementation PIXAlbum
-(void)fetchAlbumListWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSInteger)page perPage:(NSInteger)perPage completion:(RequestCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"userName 是必要參數");
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"trim_user"] = @(trimUser);
    params[@"page"] = @(page);
    params[@"per_page"] = @(perPage);
    [[PIXAPIHandler new] callAPI:@"album/setfolders" parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}

-(void)fetchAlbumSetsWithUserName:(NSString *)userName parentID:(NSString *)parentID trimUser:(BOOL)trimUser page:(NSInteger)page perPage:(NSInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(RequestCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"userName 是必要參數");
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"trim_user"] = @(trimUser);
    params[@"page"] = @(page);
    params[@"per_page"] = @(perPage);
    if (parentID != nil && parentID.length > 0) {
        params[@"parent_id"] = parentID;
    }
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:@"album/sets" parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}
-(void)succeedHandleWithData:(id)data completion:(RequestCompletion)completion{
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
@end
