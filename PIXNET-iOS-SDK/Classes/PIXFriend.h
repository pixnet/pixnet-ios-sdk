//
//  PIXFriend.h
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/4/15.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+PIXCategory.h"
#import "NSError+PIXCategory.h"
#import "PIXAPIHandler.h"
/**
 *  這個 class 主要用來處理 Friend API Method ， 並檢查輸入參數正規性
 *  除了標註 ＊ 為 require 參數外，其餘參數為 optional
 */
@interface PIXFriend : NSObject

#pragma mark - Friend Groups
#pragma mark Method Need Auth
/**
 *  列出好友群組（需認證）http://emma.pixnet.cc/friend/groups
 *
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中

 */
- (void)getFriendGroupCompletion:(PIXHandlerCompletion)completion;

@end
