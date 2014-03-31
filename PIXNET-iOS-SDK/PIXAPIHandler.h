//
//  PIXAPIHandler.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//
//  這個 class 主要用來與後台 API 溝通, 跟後台要資料時一概都使用 json 格式

typedef void (^PIXHandlerCompletion)(BOOL succeed, id result,  NSString *errorMessage);

#import <Foundation/Foundation.h>

@interface PIXAPIHandler : NSObject
#pragma mark class methods
/**
 *  設定 consumer key 及 consumer secret
 *
 *  @param aKey     consumer key
 *  @param aSecret consumer secret
 */
+(void)setConsumerKey:(NSString *)aKey consumerSecret:(NSString *)aSecret;
/**
 *  用來判斷 consumer key 及 secrect 是否已被設定
 *
 *  @return consumer key 及 secrect 都已被設定即回傳 YES
 */
+(BOOL)isConsumerKeyAndSecrectAssigned;
/**
 *  利用 XAuth 向 PIXNET 後台取得授權
 *
 *  @param userName   使用者名稱(帳號)
 *  @param password   使用者密碼
 *  @param completion succeed == YES 時，回傳 token; succeed == NO 時，則會回傳 errorMessage
 */
+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password requestCompletion:(PIXHandlerCompletion)completion;
//+(instancetype)sharedInstance;
/**
 *  用來呼叫 PIXNET 後台的 method, httpMethod為 GET, 不需 oAuth 認證
 *
 *  @param apiPath    emma.pixnet.cc/ 開始到 問號 前那一串
 *  @param parameters value 的部份請給 NSString instance
 *  @param requestCompletion succeed = YES 時，表示網路傳輸沒問題，但回傳的資料可能不是你要的
 */
#pragma mark instance method
-(void)callAPI:(NSString *)apiPath parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion;
/**
 *  用來呼叫 PIXNET 後台的 method, 不需 oAuth 認證
 *
 *  @param apiPath    emma.pixnet.cc/ 開始到 問號 前那一串
 *  @param httpMethod GET, POST, DELETE, etc...
 *  @param parameters value 的部份請給 NSString instance
 *  @param requestCompletion succeed = YES 時，表示網路傳輸沒問題，但回傳的資料可能不是你要的
 */
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion;
/**
 *  用來呼叫 PIXNET 後台的 method，當 app 不在前景時會中斷執行
 *
 *  @param apiPath           emma.pixnet.cc/ 開始到 問號 前那一串
 *  @param httpMethod        GET, POST, DELETE, etc...
 *  @param shouldAuth        該 API 是否需要 OAuth 認證
 *  @param parameters        value 的部份請給 NSString instance
 *  @param requestCompletion succeed = YES 時，表示網路傳輸沒問題，但回傳的資料可能不是你要的
 */
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion;
/**
 *  用來呼叫 PIXNET 後台的 method
 *
 *  @param apiPath        emma.pixnet.cc/ 開始到 問號 前那一串
 *  @param httpMethod     GET, POST, DELETE, etc...(這裡使用 DELETE 會失敗...，所以要 DELETE 東西請用POST，然後在 parameters裡加 _method=delete)
 *  @param shouldAuth     該 API 是否需要 OAuth 認證
 *  @param backgroundExec 是否支援背景執行(iOS 7.0 以上才有的功能，尚未完成 XD)
 *  @param parameters     value 的部份請給 NSString instance
 *  @param completion     succeed = YES 時，表示網路傳輸沒問題，但回傳的資料可能不是你要的
 */
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth shouldExecuteInBackground:(BOOL)backgroundExec parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion;
@end
