//
//  PIXAPIHandler.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//
//  這個 class 主要用來與後台 API 溝通, 跟後台要資料時一概都使用 json 格式
/**
 *  用來回傳 API 呼叫後的結果
 *
 *  @param succeed      用來判斷成功與否
 *  @param result       呼叫成功的話，這個 instance 可以直接使用
 *  @param errorMessage 呼叫失敗的話，這裡會有錯誤的發生原因
 */
typedef void (^PIXHandlerCompletion)(BOOL succeed, id result,  NSError *error);
/**
 *  用何種方式取得後台的 access token
 */
typedef NS_ENUM(NSInteger, PIXAuthType) {
    /**
     *  未登入
     */
    PIXAuthTypeUndefined,
    /**
     *  XAuth
     */
    PIXAuthTypeXAuth,
    /**
     *  OAuth2
     */
    PIXAuthTypeOAuth2
};
#import <Foundation/Foundation.h>
/**
 *  這個 class 主要用來處理跟後台連線上的事情
 */
@interface PIXAPIHandler : NSObject
#pragma mark class methods
/**
 *  設定 consumer key 及 consumer secret；這個 method 未來會被捨棄，請盡量不要用這個 method。
 *
 *  @param aKey     consumer key
 *  @param aSecret  consumer secret
 */
+(void)setConsumerKey:(NSString *)aKey consumerSecret:(NSString *)aSecret __attribute__((deprecated("use '+setConsumerKey:consumerSecret:callbackURL:'.")));
/**
 *  設定 consumer key、consumer secret 及 callbackURL，當您要利用 OAuth2 做使用者登入時，請務必先呼叫這個 method。
 *
 *  @param aKey        consumer key
 *  @param aSecret     consumer secret
 *  @param callbackURL registered callback URL
 */
+(void)setConsumerKey:(NSString *)aKey consumerSecret:(NSString *)aSecret callbackURL:(NSString *)callbackURL;
/**
 *  用來判斷 consumer key 及 secrect 是否已被設定
 *
 *  @return consumer key 及 secrect 都已被設定即回傳 YES
 */
+(BOOL)isConsumerKeyAndSecrectAssigned;
/**
 *  用來判斷 oauth/xauth 是否已成功
 *
 *  @return 授權成功就回傳 YES
 */
+(BOOL)isAuthed;
/**
 *  此方法即將被棄用！
 *  利用 oauth2 的方式讓使用者登入 PIXNET。跟 XAuth 的登入方式比起來，這個方法只要一個 UIWebView 即可，方便許多，請多多利用。
 *
 *  @param loginView  一個空白的 UIWebView, PIXNET SDK 會利用這個 webView 開啟使用者登入畫面
 *  @param completion 使用者登入成功或失敗後的事情，就交給你處理了！
 */
//+(void)authByOAuth2WithLoginView:(UIWebView *)loginView completion:(PIXHandlerCompletion)completion __attribute__((deprecated("use '+loginByOAuth2WithLoginView:completion:'.")));
/**
 *  利用 oauth2 的方式讓使用者登入 PIXNET。跟 XAuth 的登入方式比起來，這個方法只要一個 UIWebView 即可，方便許多，請多多利用。
 *
 *  @param loginView  一個空白的 UIWebView, PIXNET SDK 會利用這個 webView 開啟使用者登入畫面
 *  @param completion 使用者登入成功或失敗後的事情，就交給你處理了！
 */
+(void)loginByOAuth2WithLoginView:(UIWebView *)loginView completion:(PIXHandlerCompletion)completion;
/**
 *  此方法即將被棄用！
 *  利用 XAuth 向 PIXNET 後台取得授權
 *
 *  @param userName   使用者名稱(帳號)
 *  @param password   使用者密碼
 *  @param completion succeed == YES 時，回傳 token; succeed == NO 時，則會回傳 errorMessage
 */
+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password requestCompletion:(PIXHandlerCompletion)completion  __attribute__((deprecated("請改用 '+loginByOauthLoginView:completion:'")));
/**
 *  為目前的使用者做登出的動作
 */
+(void)logout;
#pragma mark instance method
/**
 *  用來呼叫 PIXNET 後台的 method, httpMethod為 GET, 不需 oAuth 認證
 *
 *  @param apiPath              emma.pixnet.cc/ 開始到 問號 前那一串
 *  @param parameters           value 的部份請給 NSString instance
 *  @param requestCompletion    succeed = YES 時，表示網路傳輸沒問題，但回傳的資料可能不是你要的
 */
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
 *  @param uploadData     要上傳給後台的檔案(only for 圖片)
 *  @param parameters     value 的部份請給 NSString instance
 *  @param completion     succeed = YES 時，表示網路傳輸沒問題，但回傳的資料可能不是你要的
 */
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth uploadData:(NSData *)uploadData parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion;
/**
 *  用來呼叫 PIXNET 後台的 method
 *
 *  @param apiPath        emma.pixnet.cc/ 開始到 問號 前那一串
 *  @param httpMethod     GET, POST, DELETE, etc...(這裡使用 DELETE 會失敗...，所以要 DELETE 東西請用POST，然後在 parameters裡加 _method=delete)
 *  @param shouldAuth     該 API 是否需要 OAuth 認證
 *  @param backgroundExec 當 app 被推入背景時，是否要繼續上傳檔案？如果要背景上傳檔案，僅限於 iOS7.0 以後的執行環境。
 *  @param uploadData     要上傳給後台的檔案(only for 圖片)
 *  @param parameters     value 的部份請給 NSString instance
 *  @param completion     succeed = YES 時，表示網路傳輸沒問題，但回傳的資料可能不是你要的
 */
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth shouldExecuteInBackground:(BOOL)backgroundExec uploadData:(NSData *)uploadData parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion;
@end
