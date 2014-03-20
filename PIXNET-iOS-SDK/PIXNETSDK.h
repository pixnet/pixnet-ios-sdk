//
//  PIXNETSDK.h
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/3/13.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//


#import <Foundation/Foundation.h>
@class PIXBlog;
#import "PIXAPIHandler.h"
#import "PIXAlbum.h"

@interface PIXNETSDK : NSObject

+(void)setConsumerKey:(NSString *)aKey consumerSecrect:(NSString *)aSecrect;
/**
 *  要使用任何需要認證的 API 前，務必要 call 一次這個 method
 *
 *  @param userName 使用者在 PIXNET 上的名稱
 *  @param password 使用者在 PIXNET 上的密碼
 *  @param completion 將 request access 的結果回傳給你，再來就交給你了
 */
+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password completion:(RequestCompletion)completion;

+(instancetype)sharedInstance;
//Blog Method

//blog get info
/**
 *  取得部落格資訊
 *
 *  @param userID 痞客邦帳號
 *
 *  @return 該部落格的基本資訊
 */
- (void)getBlogInformationWithUserID:(NSString *)userID completion:(RequestCompletion)completion;

//blog categories
/**
 *  讀取使用者部落格分類資訊
 *
 *  @param userID     指定要回傳的使用者資訊（痞客邦帳號）
 *  @param passwd     如果指定使用者的 Blog 被密碼保護，則需要指定這個參數以通過授權，沒有密碼就輸入 nil 
 *  @param completion
 */
- (void)getBlogCategoriesWithUserID:(NSString *)userID andPassword:(NSString *)passwd completion:(RequestCompletion)completion;

@end
