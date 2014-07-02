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
/**
 *  使用者性別
 */
typedef NS_ENUM(NSInteger, PIXUserGender) {
    /**
     *  不設定性別
     */
    PIXUserGenderNone,
    /**
     *  女性
     */
    PIXUserGenderFemale,
    /**
     *  男性
     */
    PIXUserGenderMale
};
/**
 *  教育程度
 */
typedef NS_ENUM(NSInteger, PIXUserEducation) {
    /**
     *  不設定教育程度
     */
    PIXUserEducationNone,
    /**
     *  中學及以下
     */
    PIXUserEducationJuniorHigh,
    /**
     *  高中/高職
     */
    PIXUserEducationSeniorHigh,
    /**
     *  專科
     */
    PIXUserEducationJuniorCollege,
    /**
     *  大學
     */
    PIXUserEducationCollege,
    /**
     *  研究所
     */
    PIXUserEducationGradurate
};
@interface PIXUser : NSObject

/**
 *  讀取 User 公開資訊 http://developer.pixnet.pro/#!/doc/pixnetApi/users
 *
 *  @param userName   指定要回傳的使用者資訊,必要參數
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)getUserWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion;

/**
 *  讀取使用者私人資訊,需認證 http://developer.pixnet.pro/#!/doc/pixnetApi/account
 *
 *  @param withNotification 是否傳回最新的五則通知
 *  @param notificationType 要傳回何種類型的通知
 *  @param withBlogInfo     是否回傳部落格資訊
 *  @param withMib          是否回傳 MIB 相關資訊
 *  @param withAnalytics    是否回傳人氣統計相關資訊、近期熱門文章、相片資訊
 *  @param completion       PIXHandlerCompletion
 */
-(void)getAccountWithNotification:(BOOL)withNotification notificationType:(PIXUserNotificationType)notificationType withBlogInfo:(BOOL)withBlogInfo withMib:(BOOL)withMib withAnalytics:(BOOL)withAnalytics completion:(PIXHandlerCompletion)completion;
/**
 *  修改使用者資訊,需認證 http://developer.pixnet.pro/#!/doc/pixnetApi/accountInfo
 *
 *  @param password    使用者密碼，必要欄位
 *  @param displayName 使用者䁥稱
 *  @param email       email 信箱
 *  @param gender      姓別
 *  @param address     地址
 *  @param phone       電話
 *  @param birth       生日
 *  @param education   教育程度
 *  @param avatar      大頭照
 *  @param completion  PIXHandlerCompletion
 */
-(void)editAccountWithPassword:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email gender:(PIXUserGender)gender address:(NSString *)address phone:(NSString *)phone birth:(NSDate *)birth education:(PIXUserEducation)education avatar:(UIImage *)avatar completion:(PIXHandlerCompletion)completion;

@end
