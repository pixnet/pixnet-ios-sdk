//
//  PIXFriend.h
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/4/15.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//

/**
 *  取得好友名單時要使用何種排序方式
 */
typedef NS_ENUM(NSInteger, PIXFriendshipsSortType) {
    /**
     *  依照朋友的 user_name 排序
     */
    PIXFriendshipsSortTypeUserName,
    /**
     *  依照朋友的 ID 排序
     */
    PIXFriendshipsSortTypeUserId
};
/**
 *  取得哪種族群的動態
 */
typedef NS_ENUM(NSInteger, PIXFriendNewsType) {
    /**
     *  取得訂閱者的動態
     */
    PIXFriendNewsTypeSubscription,
    /**
     *  取得朋友的動態
     */
    PIXFriendNewsTypeFriend
};
#import <Foundation/Foundation.h>
#import "NSObject+PIXCategory.h"
#import "NSError+PIXCategory.h"
#import "PIXAPIHandler.h"
/**
 *  這個 class 主要用來處理 Friend API Method ， 並檢查輸入參數正規性
 *  這個 class 裡的 method 幾乎都要先經過認證，如不需要認證，會在 method 的說明裡註明
 */
@interface PIXFriend : NSObject

#pragma mark - Friend Groups
/**
 *  取得好友群組列表 http://developer.pixnet.pro/#!/doc/pixnetApi/friendGroups
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
 *  修改好友群組名稱 http://developer.pixnet.pro/#!/doc/pixnetApi/friendGroupsUpdate
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
 *  取得好友名單，一次100筆 http://developer.pixnet.pro/#!/doc/pixnetApi/friendships
 *
 *  @param sortType      取回來的名單要以何種方式排序
 *  @param cursor        當好友超過100個時，server 會回傳 next_cursor 或 previous_cursor，就是用它來取得上一頁或下一頁的資料！
 *  @param bidirectional 設為YES時，只顯示互為好友名單。
 *  @param completion    PIXHandlerCompletion
 */
-(void)getFriendshipsWithSortType:(PIXFriendshipsSortType)sortType cursor:(NSString *)cursor bidirectional:(BOOL)bidirectional completion:(PIXHandlerCompletion)completion;
/**
 *  新增好友 http://developer.pixnet.pro/#!/doc/pixnetApi/friendshipsCreate
 *
 *  @param friendName 好友名稱，必要參數
 *  @param completion PIXHandlerCompletion
 */
-(void)createFriendshipWithFriendName:(NSString *)friendName completion:(PIXHandlerCompletion)completion;
/**
 *  將好友加入指定的群組 http://developer.pixnet.pro/#!/doc/pixnetApi/friendshipsAppendGroup
 *
 *  @param friendName 好友名稱，必要參數
 *  @param groupId    群組ID，必要參數
 *  @param completion PIXHandlerCompletion
 */
-(void)appendFriendGroupWithFriendName:(NSString *)friendName groupID:(NSString *)groupId completion:(PIXHandlerCompletion)completion;
/**
 *  將好友從指定的群組移出 http://developer.pixnet.pro/#!/doc/pixnetApi/friendshipsRemoveGroup
 *
 *  @param friendName 好友名稱，必要參數
 *  @param groupId    群組ID，必要參數
 *  @param completion PIXHandlerCompletion
 */
-(void)removeFriendGroupWithFriendName:(NSString *)friendName groupID:(NSString *)groupId completion:(PIXHandlerCompletion)completion;
/**
 *  移除好友 http://developer.pixnet.pro/#!/doc/pixnetApi/friendshipsDelete
 *
 *  @param friendName 要被移除的好友名稱
 *  @param completion PIXHandlerCompletion
 */
-(void)deleteFriendshipWithFriendName:(NSString *)friendName completion:(PIXHandlerCompletion)completion;
#pragma mark Friend Subscription
/**
 *  取得訂閱名單 http://developer.pixnet.pro/#!/doc/pixnetApi/friendSubscriptions
 *
 *  @param page       第幾頁
 *  @param perPage    每頁幾筆
 *  @param completion PIXHandlerCompletion
 */
-(void)getFriendSubscriptionsWithPage:(NSUInteger)page perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion;
/**
 *  訂閱某個使用者的動態 http://developer.pixnet.pro/#!/doc/pixnetApi/friendSubscriptionsCreate
 *
 *  @param userName   被追蹤者的名稱，必要參數
 *  @param groupIds   可同時將該名好友加入某幾個訂閱群組裡，這個 array 裡的每個值都要是 NSString instance
 *  @param completion PIXHandlerCompletion
 */
-(void)createFriendSubscriptionWithUserName:(NSString *)userName groupIDs:(NSArray *)groupIds completion:(PIXHandlerCompletion)completion;
/**
 *  將某個使用者加入訂閱群組(們) http://developer.pixnet.pro/#!/doc/pixnetApi/friendSubscriptionsJoinSubscriptionGroup
 *
 *  @param userName   被追蹤者的名稱，必要參數
 *  @param groupIds   哪幾個訂閱群組，這個 array 裡的每個值都要是 NSString instance，必要參數
 *  @param completion PIXHandlerCompletion
 */
-(void)joinFriendSubscriptionGroupsWithUserName:(NSString *)userName groupIDs:(NSArray *)groupIds completion:(PIXHandlerCompletion)completion;
/**
 *  將某個使用者從訂閱群組(們)移出 http://developer.pixnet.pro/#!/doc/pixnetApi/friendSubscriptionsLeaveSubscriptionGroup
 *
 *  @param userName   被追蹤者的名稱，必要參數
 *  @param groupIds   哪幾個訂閱群組，這個 array 裡的每個值都要是 NSString instance，必要參數
 *  @param completion PIXHandlerCompletion
 */
-(void)leaveFriendSubscriptionGroupsWithUserName:(NSString *)userName groupIDs:(NSArray *)groupIds completion:(PIXHandlerCompletion)completion;
/**
 *  取消對某個使用者的訂閱 http://developer.pixnet.pro/#!/doc/pixnetApi/friendSubscriptionsDelete
 *
 *  @param userName   要取消訂閱的 user name
 *  @param completion PIXHandlerCompletion
 */
-(void)deleteFriendSubscriptionWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion;
#pragma mark Friend Subscription Group
/**
 *  取得所有訂閱群組 http://developer.pixnet.pro/#!/doc/pixnetApi/friendSubscriptionGroups
 *
 *  @param completion PIXHandlerCompletion
 */
-(void)getFriendSubscriptionGroupsWithCompletion:(PIXHandlerCompletion)completion;
/**
 *  新增訂閱群組 http://developer.pixnet.pro/#!/doc/pixnetApi/friendSubscriptionGroupsCreate
 *
 *  @param groupName  新增的群組名稱，必要參數
 *  @param completion PIXHandlerCompletion
 */
-(void)createFriendSubscriptionGroupWithGroupName:(NSString *)groupName completion:(PIXHandlerCompletion)completion;
/**
 *  修改訂閱群組 http://developer.pixnet.pro/#!/doc/pixnetApi/friendSubscriptionGroupsUpdate
 *
 *  @param groupId      要被修改的群組 ID，必要參數
 *  @param newGroupName 新的群組名稱，必要參數
 *  @param completion   PIXHandlerCompletion
 */
-(void)updateFriendSubscriptionGroupWithGroupID:(NSString *)groupId newGroupName:(NSString *)newGroupName completion:(PIXHandlerCompletion)completion;
/**
 *  修改訂閱群組排序 http://developer.pixnet.pro/#!/doc/pixnetApi/friendSubscriptionGroupsPosition
 *
 *  @param sortedGroups 用 group Id 組成的 array
 *  @param completion   PIXHandlerCompletion
 */
-(void)positionFriendSubscriptionGroupsWithSortedGroups:(NSArray *)sortedGroups completion:(PIXHandlerCompletion)completion;
/**
 *  刪除訂閱群組 http://developer.pixnet.pro/#!/doc/pixnetApi/friendSubscriptionsDelete
 *
 *  @param groupId    要被刪除的群組 ID，必要參數
 *  @param completion PIXHandlerCompletion
 */
-(void)deleteFriendSubscriptionGroupWithGroupID:(NSString *)groupId completion:(PIXHandlerCompletion)completion;
#pragma mark Friend News
/**
 *  取得最新動態 http://developer.pixnet.pro/#!/doc/pixnetApi/friendNews
 *
 *  @param newsType   要取得何種族群的動態(朋友 or 訂閱的對象)
 *  @param groupId    指定訂閱的群組ID
 *  @param beforeTime 取出早於指定時間的動態
 *  @param completion PIXHandlerCompletion
 */
-(void)getFriendNewsWithNewsType:(PIXFriendNewsType)newsType groupID:(NSString *)groupId beforeTime:(NSDate *)beforeTime completion:(PIXHandlerCompletion)completion;
@end
