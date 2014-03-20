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
    NSDictionary *params = @{@"user": userName,
                             @"trim_user": @(trimUser),
                             @"page": @(page),
                             @"per_page": @(perPage)};
    [[PIXAPIHandler new] callAPI:@"album/setfolders" parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
        if (succeed) {
            NSError *jsonError;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&jsonError];
            if (jsonError == nil) {
                if ([dict[@"error"] intValue] == 0) {
                    completion(YES, dict, nil);
                } else {
                    completion(NO, nil, dict[@"message"]);
                }
            } else {
                completion(NO, nil, jsonError.localizedDescription);
            }
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}
@end
