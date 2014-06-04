//
//  PIXIndex.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/4/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIXAPIHandler.h"
/**
 *  這個 class 用來處理您的 app 在痞客邦後台的狀態
 */
@interface PIXIndex : NSObject
/**
 *  讀取 API 使用次數資訊 http://developer.pixnet.pro/#!/doc/pixnetApi/indexRate
 *
 *  @param completion PIXHandlerCompletion
 */
-(void)getIndexRateWithCompletion:(PIXHandlerCompletion)completion;
/**
 *  讀取 API Server 時間資訊 http://developer.pixnet.pro/#!/doc/pixnetApi/indexNow
 *
 *  @param completion PIXHandlerCompletion
 */
-(void)getIndexNowWithCompletion:(PIXHandlerCompletion)completion;
@end
