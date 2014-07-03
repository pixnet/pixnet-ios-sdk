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
-(void)updateAccountWithPassword:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email gender:(PIXUserGender)gender address:(NSString *)address phone:(NSString *)phone birth:(NSDate *)birth education:(PIXUserEducation)education avatar:(UIImage *)avatar completion:(PIXHandlerCompletion)completion;
/**
 *  讀取 MIB 資訊 http://developer.pixnet.pro/#!/doc/pixnetApi/accountMib
 *
 *  @param historyDays 列出指定天數的歷史收益資訊，最少 1 天，最多 45 天，必要參數。(在 SDK 裡不做最大天數的檢查，因為這個後台改天數限制很快，但 SDK 若是跟著改，外部開發者 app 就要重上架)
 *  @param completion  PIXHandlerCompletion
 */
-(void)getAccountMIBWithHistoryDays:(NSUInteger)historyDays completion:(PIXHandlerCompletion)completion;
/**
 *  建立使用者的 MIB 資訊，若已上傳過帳戶資料，除非需要補件，否則不開放再次上傳帳戶資料。 http://developer.pixnet.pro/#!/doc/pixnetApi/accountMibCreate
 *
 *  @param realName      真實姓名，必要欄位。
 *  @param idNumber      身份證字號，必要欄位。
 *  @param idImageFront  身份證正面，必要欄位。
 *  @param idImageBack   身份證反面，必要欄位。
 *  @param email         email address，必要欄位。
 *  @param cellPhone     手機號碼，必要欄位。
 *  @param mailAddress   支票寄送地址，必要欄位。
 *  @param domicile      戶籍地址，必要欄位。
 *  @param enableVideoAd 是否開啟影音廣告。
 *  @param completion    PIXHandlerCompletion
 */
-(void)createAccountMIBWithRealName:(NSString *)realName idNumber:(NSString *)idNumber idImageFront:(UIImage *)idImageFront idImageBack:(UIImage *)idImageBack email:(NSString *)email cellPhone:(NSString *)cellPhone mailAddress:(NSString *)mailAddress domicile:(NSString *)domicile enableVideoAd:(BOOL)enableVideoAd completion:(PIXHandlerCompletion)completion;
/**
 *  取得 MIB 某個版位的資料 http://developer.pixnet.pro/#!/doc/pixnetApi/accountMibPositions
 *
 *  @param positionId 該版位的 ID
 *  @param completion PIXHandlerCompletion
 */
-(void)getAccountMIBPositionWithPositionID:(NSString *)positionId completion:(PIXHandlerCompletion)completion;
/**
 *  修改 MIB 某個版位的資料 http://developer.pixnet.pro/#!/doc/pixnetApi/accountMibPositionsUpdate
 *
 *  @param positionId 版位 ID，必要欄位
 *  @param enabled    是否要啟用，請利用 NSNumber +numberWithBool: 的方法給值。
 *  @param fixedAdBox 此廣告框是否為固定型式，請利用 NSNumber +numberWithBool: 的方法給值。
 *  @param completion PIXHandlerCompletion
 */
-(void)updateAccountMIBPositionWithPositionID:(NSString *)positionId enabled:(NSNumber *)enabled fixedAdBox:(NSNumber *)fixedAdBox completion:(PIXHandlerCompletion)completion;
/**
 *  MIB 請款 http://developer.pixnet.pro/#!/doc/pixnetApi/accountMibPay
 *
 *  @param completion PIXHandlerCompletion
 */
-(void)askAccountMIBPayWithCompletion:(PIXHandlerCompletion)completion;
/**
 *  取得使用者被拜訪紀錄分析資料 http://developer.pixnet.pro/#!/doc/pixnetApi/accountAnalytics
 *
 *  @param staticDays 指定天數的歷史拜訪資訊，最少 0 天，最多 45 天
 *  @param referDays  指定天數的誰連結我資訊，最少 0 天，最多 7 天
 *  @param completion PIXHandlerCompletion
 */
-(void)getAccountAnalyticsWithStaticDays:(NSUInteger)staticDays referDays:(NSUInteger)referDays completion:(PIXHandlerCompletion)completion;
/**
 *  修改密碼 http://developer.pixnet.pro/#!/doc/pixnetApi/accountPassword
 *
 *  @param originalPassword 原本的使用者密碼，需要檢查與系統內儲存資訊相符後才能執行修改。必要參數
 *  @param newPassword      新密碼，密碼需至少4個字元，區分大小寫。必要參數
 *  @param completion       PIXHandlerCompletion
 */
-(void)updateAccountPasswordWithOriginalPassword:(NSString *)originalPassword newPassword:(NSString *)newPassword completion:(PIXHandlerCompletion)completion;
@end
