//
//  PIXAPIHandler.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//
//  這個 class 主要用來與後台 API 溝通, 跟後台要資料時一概都使用 json 格式
typedef void (^RequestCompletion)(BOOL succeed, id result,  NSString *errorMessage);

#import <Foundation/Foundation.h>

@interface PIXAPIHandler : NSObject
//+(instancetype)sharedInstance;

/**
 *  設定 consumer key 及 consumer secrect
 *
 *  @param aKey     consumer key
 *  @param aSecrect consumer secrect
 */
+(void)setConsumerKey:(NSString *)aKey consumerSecrect:(NSString *)aSecrect;
/**
 *  用來判斷 consumer key 及 secrect 是否已被設定
 *
 *  @return consumer key 及 secrect 都已被設定即回傳 YES
 */
+(BOOL)isConsumerKeyAndSecrectAssigned;

+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password requestCompletion:(RequestCompletion)completion;
//+(instancetype)sharedInstance;
/**
 *  用來呼叫 PIXNET 後台的 method, httpMethod為 GET, 不需 oAuth 認證
 *
 *  @param apiPath    emma.pixnet.cc/ 開始到 問號 前那一串
 *  @param parameters value 的部份請給 NSString instance
 *  @param requestCompletion succeed = YES 時，表示網路傳輸沒問題，但回傳的資料可能不是你要的
 */
-(void)callAPI:(NSString *)apiPath parameters:(NSDictionary *)parameters requestCompletion:(RequestCompletion)completion;
/**
 *  用來呼叫 PIXNET 後台的 method, 不需 oAuth 認證
 *
 *  @param apiPath    emma.pixnet.cc/ 開始到 問號 前那一串
 *  @param httpMethod GET, POST, DELETE, etc...
 *  @param parameters value 的部份請給 NSString instance
 *  @param requestCompletion succeed = YES 時，表示網路傳輸沒問題，但回傳的資料可能不是你要的
 */
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod parameters:(NSDictionary *)parameters requestCompletion:(RequestCompletion)completion;
/**
 *  用來呼叫 PIXNET 後台的 method
 *
 *  @param apiPath    emma.pixnet.cc/ 開始到 問號 前那一串
 *  @param httpMethod GET, POST, DELETE, etc...
 *  @param shouldAuth 該 API 是否需要 OAuth 認證
 *  @param parameters value 的部份請給 NSString instance
 *  @param requestCompletion succeed = YES 時，表示網路傳輸沒問題，但回傳的資料可能不是你要的
 */
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth parameters:(NSDictionary *)parameters requestCompletion:(RequestCompletion)completion;

-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth shouldExecuteInBackground:(BOOL)backgroundExec parameters:(NSDictionary *)parameters requestCompletion:(RequestCompletion)completion;
@end