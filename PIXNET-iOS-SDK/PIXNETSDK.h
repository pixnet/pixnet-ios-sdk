//
//  PIXNETSDK.h
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/3/13.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//


#import <Foundation/Foundation.h>
@class PIXBlog;
//#import "PIXBlogCategories.h"
//#import "PIXBlogComments.h"
//#import "PIXBlogMainpage.h"
#import "PIXAPIHandler.h"


@interface PIXNETSDK : NSObject

+(void)setConsumerKey:(NSString *)aKey consumerSecrect:(NSString *)aSecrect;
+(instancetype)sharedInstance;
//Blog Method

/**
 *  取得部落格資訊
 *
 *  @param userID 痞客邦帳號
 *
 *  @return 該部落格的基本資訊
 */
- (void)getBlogInformationWithUserID:(NSString *)userID completion:(RequestCompletion)completion;
/**
 *  讀取使用者部落格分類資訊
 *
 *  @param userID 痞客邦帳號
 *  @param passwd 如果指定使用者的 Blog 被密碼保護，則需要指定這個參數以通過授權
 *
 *  @return 部落格分類資訊, 密碼錯誤會回傳 status : password Error
 */
//- (NSDictionary *)PIXgetBlogCategories:(NSString *)userID withPassword:(NSString *)passwd;



//- (NSDictionary *)PIXpostBlogCategories:(NSString *)cateName withType:(PIXCategoriesType *)type;


@end
