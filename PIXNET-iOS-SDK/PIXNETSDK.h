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

/**
 *  呼叫任何 API 前，務必設定 consumer key 及 consumer secret
 *
 *  @param aKey     consum key
 *  @param aSecret consumer secret
 */
+(void)setConsumerKey:(NSString *)aKey consumerSecret:(NSString *)aSecret;
/**
 *  利用 XAuth 向 PIXNET 後台取得授權
 *
 *  @param userName   使用者名稱(帳號)
 *  @param password   使用者密碼
 *  @param completion succeed == YES 時，回傳 token; succeed == NO 時，則會回傳 errorMessage
 */
+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password requestCompletion:(PIXHandlerCompletion)completion;
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
- (void)getBlogInformationWithUserID:(NSString *)userID completion:(PIXHandlerCompletion)completion;

//blog categories
/**
 *  讀取使用者部落格分類資訊
 *
 *  @param userID     指定要回傳的使用者資訊（痞客邦帳號）
 *  @param passwd     如果指定使用者的 Blog 被密碼保護，則需要指定這個參數以通過授權，沒有密碼就輸入 nil 
 *  @param completion
 */
- (void)getBlogCategoriesWithUserID:(NSString *)userID andPassword:(NSString *)passwd completion:(PIXHandlerCompletion)completion;

@end
