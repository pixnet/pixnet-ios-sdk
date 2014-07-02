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

-(void)getAccountWithNotification:(BOOL)withNotification notificationType:(PIXUserNotificationType)notificationType withBlogInfo:(BOOL)withBlogInfo withMib:(BOOL)withMib withAnalytics:(BOOL)withAnalytics completion:(PIXHandlerCompletion)completion{
    NSString *typeString = nil;
    switch (notificationType) {
        case PIXUserNotificationTypeAppMarket:
            typeString = @"appmarket";
            break;
        case PIXUserNotificationTypeComment:
            typeString = @"comment";
            break;
        case PIXUserNotificationTypeFriend:
            typeString = @"friend";
            break;
        case PIXUserNotificationTypeSystem:
            typeString = @"system";
            break;
        case PIXUserNotificationTypeAll:
        default:
            break;
    }
    NSMutableDictionary *params = nil;
    if (typeString) {
        params = [NSMutableDictionary dictionaryWithCapacity:5];
        params[@"notification_type"] = typeString;
    } else {
        params = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    params[@"with_notification"] = [NSString stringWithFormat:@"%i", withNotification];
    params[@"with_blog_info"] = [NSString stringWithFormat:@"%i", withBlogInfo];
    params[@"with_mib"] = [NSString stringWithFormat:@"%i", withMib];
    params[@"with_analytics"] = [NSString stringWithFormat:@"%i", withAnalytics];
    
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:uploadData:parameters:requestCompletion:) parameters:@[@"account", @"GET", @YES, [NSNull null], params, completion] receiver:[PIXAPIHandler new]];
}



@end
