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
