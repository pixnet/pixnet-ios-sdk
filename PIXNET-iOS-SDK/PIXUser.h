//
//  PIXUser.h
//  PIXNET-iOS-SDK
//
//  Created by jnlin on 2014/3/22.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIXAPIHandler.h"
#import "PIXConstant.h"

@interface PIXUser : NSObject

/**
 *  讀取 User 公開資訊 http://developer.pixnet.pro/#!/doc/pixnetApi/users
 *
 *  @param userName   指定要回傳的使用者資訊,必要參數
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)getUserWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion;

@end
