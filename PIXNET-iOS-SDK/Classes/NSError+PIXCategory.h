//
//  NSError+PIXCategory.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/10/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSError (PIXCategory)
/**
 *  用來產生跟參數有關的 error 物件
 *
 *  @param parameterName 出問題的參數名稱
 *
 *  @return localizedDescription 會是 [xxx]參數有誤，請檢查一下
 */
+(instancetype)PIXErrorWithParameter:(NSString *)parameterName;
/**
 *  用來將後台回傳的錯誤訊息轉成 NSError instance
 *
 *  @param response 將整個 server 回傳的 NSDictionary 丟進來就好
 *
 *  @return 
 */
+(instancetype)PIXErrorWithServerResponse:(NSDictionary *)response;
@end
