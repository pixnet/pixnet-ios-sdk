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
/**
 *  取得好友群組列表 http://emma.pixnet.cc/friend/groups
 *
 *  @param page       頁數, 必要參數
 *  @param perPage    每頁幾筆，必要參數
 *  @param completion PIXHandlerCompletion
 */
- (void)getFriendGroupsWithPage:(NSInteger)page perPage:(NSInteger)perPage Completion:(PIXHandlerCompletion)completion;
/**
 *  新增好友群組 http://developer.pixnet.pro/#!/doc/pixnetApi/friendGroupsCreate
 *
 *  @param groupName  新增的群組名稱，必要參數
 *  @param completion PIXHandlerCompletion
 */
- (void)createFriendGroupsWithGroupName:(NSString *)groupName completion:(PIXHandlerCompletion)completion;
/**
 *  修改好友群組名稱
 *
 *  @param groupId      要被修改的群組的 ID，必要參數
 *  @param newGroupName 新的群組名稱，必要參數
 *  @param completion   PIXHandlerCompletion
 */
- (void)updateFriendGroupWithGroupID:(NSString *)groupId newGroupName:(NSString *)newGroupName completion:(PIXHandlerCompletion)completion;
/**
 *  刪除好友群組 http://developer.pixnet.pro/#!/doc/pixnetApi/friendGroupsDelete
 *
 *  @param groupId    要被刪除的群組的 ID，必要參數
 *  @param completion PIXHandlerCompletion
 */
- (void)deleteFriendGroupWithGroupID:(NSString *)groupId completion:(PIXHandlerCompletion)completion;

#pragma mark - Friendships
/**
 *  新增好友 http://developer.pixnet.pro/#!/doc/pixnetApi/friendshipsCreate
 *
 *  @param friendName 好友名稱，必要參數
 *  @param completion PIXHandlerCompletion
 */
-(void)createFriendshipWithFriendName:(NSString *)friendName completion:(PIXHandlerCompletion)completion;
/**
 *  將好友入指定的群組 http://developer.pixnet.pro/#!/doc/pixnetApi/friendshipsAppendGroup
 *
 *  @param friendName 好友名稱，必要參數
 *  @param groupId    群組ID，必要參數
 *  @param completion PIXHandlerCompletion
 */
-(void)appendFriendGroupWithFriendName:(NSString *)friendName groupID:(NSString *)groupId completion:(PIXHandlerCompletion)completion;
@end
