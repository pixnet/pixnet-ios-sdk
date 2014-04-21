//
//  NSError+PIXCategory.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/10/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//
static NSString *kPIXErrorDomain = @"kPIXErrorDomain";
static NSString *kPIXHTTPErrorDomain = @"kPIXHTTPErrorDomain";
/**
 *  這裡定義了幾種在呼叫痞客邦 API 時常見的錯誤型態
 */
typedef NS_ENUM(NSInteger, PIXErrorDomainStatus) {
    /**
     *  您呼叫 method 時代入的參數有誤
     */
    PIXErrorDomainStatusInputParameter,
    /**
     *  痞客邦後台回應的錯誤
     */
    PIXErrorDomainStatusServerResponse
};

#import <Foundation/Foundation.h>
/**
 *  這個 class 用來產生一致的 NSError instance, domain 為 kPIXErrorDomain時, 我們將易讀的錯誤訊息放在 localizedDescription 裡, 如果您有需要客製化您的錯誤訊息，可使用 code 做判斷, 各個 code 代表的意義請見 PIXErrorDomainStatus。而如果錯誤的發生是因為 http 連線錯誤，這時 domain 為 kPIXHTTPErrorDomain, http error code 則放入 error.code
 */
@interface NSError (PIXCategory)
/**
 *  這個 method 主要在產生 http 連線錯誤時的 error 物件，正常情形下應該只有 PIXAPIHandler 會用到這個 method。error.code 即為 http 連線錯誤代碼
 *
 *  @param code http status code
 *
 *  @return NSError instance
 */
+(instancetype)PIXErrorWithHTTPStatusCode:(NSInteger)code;
/**
 *  當外部開發者呼叫 method 時所帶的參數有誤時，用這個 method 來產生 error 物件
 *
 *  @param parameterName 發生錯誤的參數名稱
 *
 *  @return localizedDescription 為 "parameterName 參數有誤"
 */
+(instancetype)PIXErrorWithParameterName:(NSString *)parameterName;
/**
 *  當 server 回傳的 dictionary 裡的 error 不為 0 時，用這個 method 來產生 error 物件。error.code 為後台丟出來的 code, localizedDescription 是後台丟出來的 message
 *
 *  @param response 將整個 server 回傳的 NSDictionary 丟進來就好
 *
 *  @return NSError instance
 */
+(instancetype)PIXErrorWithServerResponse:(NSDictionary *)response;
/**
 *  當輸入參數為 NSUInteger 時，會在 SDK 裡檢查有效性，當變數無效時，就用這個 method 產生 error 物件
 *
 *  @param integerName 變數名稱
 *
 *  @return NSError instance
 */
+(instancetype)PIXErrorWithNSUIntegerFormat:(NSString *)integerName;
@end
