//
//  PIXUser.h
//  PIXNET-iOS-SDK
//
//  Created by jnlin on 2014/3/22.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIXAPIHandler.h"

/**
 *  要接收何種類型的通知
 */
typedef NS_ENUM(NSInteger, PIXUserNotificationType) {
    /**
     *  所有通知
     */
    PIXUserNotificationTypeAll,
    /**
     *  好友互動通知
     */
    PIXUserNotificationTypeFriend,
    /**
     *  系統通知
     */
    PIXUserNotificationTypeSystem,
    /**
     *  留言通知
     */
    PIXUserNotificationTypeComment,
    /**
     *  應用市集通知
     */
    PIXUserNotificationTypeAppMarket
};

@interface PIXUser : NSObject {
//    PIXAPIHandler *apihandler;
}

#pragma mark -
/**
 *  讀取 User 公開資訊 http://developer.pixnet.pro/#!/doc/pixnetApi/users
 *
 *  @param userName   指定要回傳的使用者資訊,必要參數
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)getUserWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion;

/**
 *  讀取 User 私人資訊 http://developer.pixnet.pro/#!/doc/pixnetApi/account
 *
 *  @needAuth
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
/**
 *  讀取 User 私人資訊 http://developer.pixnet.pro/#!/doc/pixnetApi/account
 *
 *  @param withNotification 是否傳回最新的五則通知
 *  @param notificationType 要傳回何種類型的通知
 *  @param withBlogInfo     是否回傳部落格資訊
 *  @param withMib          是否回傳 MIB 相關資訊
 *  @param withAnalytics    是否回傳人氣統計相關資訊、近期熱門文章、相片資訊
 *  @param completion       PIXHandlerCompletion
 */
-(void)getAccountWithNotification:(BOOL)withNotification notificationType:(PIXUserNotificationType)notificationType withBlogInfo:(BOOL)withBlogInfo withMib:(BOOL)withMib withAnalytics:(BOOL)withAnalytics completion:(PIXHandlerCompletion)completion;

@property (nonatomic, retain) PIXAPIHandler *apihandler;

@end
