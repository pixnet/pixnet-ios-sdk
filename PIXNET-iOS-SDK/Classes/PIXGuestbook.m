//
//  PIXGuestbook.m
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/4/15.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//

#import "PIXGuestbook.h"


@implementation PIXGuestbook
-(void)getGuestbookMessagesWithUserName:(NSString *)userName filter:(PIXGuestbookFilter)filter cursor:(NSString *)cursor perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion{
    if (userName==nil || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName 參數格式有誤"]);
        return;
    }
    NSString *filterString = nil;
    switch (filter) {
        case PIXGuestbookFilterNoReply:
            filterString = @"noreply";
            break;
        case PIXGuestbookFilterWhisper:
            filterString = @"whisper";
            break;
        default:
            break;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:userName forKey:@"user"];
    if (filterString) {
        [params setObject:filterString forKey:@"filter"];
    }
    if (cursor) {
        [params setObject:cursor forKey:@"cursor"];
    }
    if (perPage<1) {
        perPage=20;
    }
    [params setObject:@(perPage) forKey:@"per_page"];
    [self invokeMethod:@selector(callAPI:parameters:requestCompletion:) parameters:@[@"guestbook", params, completion] receiver:[PIXAPIHandler new]];
}
@end
