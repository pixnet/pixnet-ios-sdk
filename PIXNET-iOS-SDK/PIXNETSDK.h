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

/**
 *  取得部落格資訊
 *
 *  @param userID 痞客邦帳號
 *
 *  @return 該部落格的基本資訊
 */
- (void)getBlogInformationWithUserID:(NSString *)userID completion:(RequestCompletion)completion;

- (void)getBlogArticlesCompletion:(RequestCompletion)completion;
@end
