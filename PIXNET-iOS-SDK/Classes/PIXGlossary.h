//
//  PIXGlossary.h
//  PIXNET-iOS-SDK
//
//  Created by dennis on 2015/10/30.
//  Copyright © 2015年 Dolphin Su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIXAPIHandler.h"

@interface PIXGlossary : NSObject
/**
 *  讀取台灣郵遞區號資訊
 *
 *  @param version    目前local端區碼版本號
 *  @param isFetch    是否回傳區碼資料,填NO則單純確認版號
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
-(void)getTWZipCodeWithVersioin:(NSString *)version isFetch:(BOOL)isFetch completion:(PIXHandlerCompletion)completion;
@end
