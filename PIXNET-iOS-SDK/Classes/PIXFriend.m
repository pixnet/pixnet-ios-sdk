//
//  PIXFriend.m
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/4/15.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//

#import "PIXFriend.h"


@implementation PIXFriend

- (void)getFriendGroupsWithPage:(NSInteger)page perPage:(NSInteger)perPage Completion:(PIXHandlerCompletion)completion{
    if (page < 1) {
        page = 1;
    }
    if (perPage < 1) {
        perPage = 20;
    }
    NSDictionary *params = @{@"page": [NSString stringWithFormat:@"%li", page], @"per_page":[NSString stringWithFormat:@"%li", perPage]};
    [[PIXAPIHandler new] callAPI:@"friend/groups" httpMethod:@"GET" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friend/groups", @"GET", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
- (void)createFriendGroupsWithGroupName:(NSString *)groupName completion:(PIXHandlerCompletion)completion{
    if (groupName==nil || groupName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupName 參數有誤"]);
        return;
    }
    NSDictionary *params = @{@"name":groupName};
    [[PIXAPIHandler new] callAPI:@"friend/groups" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friend/groups", @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
- (void)updateFriendGroupWithGroupID:(NSString *)groupId newGroupName:(NSString *)newGroupName completion:(PIXHandlerCompletion)completion{
    if (groupId==nil || groupId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupId 參數有誤"]);
        return;
    }
    if (newGroupName==nil || newGroupName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"newGroupName 參數有誤"]);
        return;
    }
    NSDictionary *params = @{@"name":newGroupName};
    NSString *path = [NSString stringWithFormat:@"friend/groups/%@", groupId];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
- (void)deleteFriendGroupWithGroupID:(NSString *)groupId completion:(PIXHandlerCompletion)completion{
    if (groupId==nil || groupId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupId 參數有誤"]);
        return;
    }
    NSString *path = [NSString stringWithFormat:@"friend/groups/%@", groupId];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:@{@"_method":@"delete"} requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, @{@"_method":@"delete"}, completion] receiver:[PIXAPIHandler new]];
}
-(void)getFriendshipsWithSortType:(PIXFriendshipsSortType)sortType cursor:(NSString *)cursor bidirectional:(BOOL)bidirectional completion:(PIXHandlerCompletion)completion{
    NSString *sortTypeString = nil;
    switch (sortType) {
        case PIXFriendshipsSortTypeUserId:
            sortTypeString = @"id";
            break;
            
        case PIXFriendshipsSortTypeUserName:
        default:
            sortTypeString = @"user_name";
            break;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:sortTypeString forKey:@"cursor_name"];
    if (cursor) {
        [params setObject:cursor forKey:@"cursor"];
    }
    [params setObject:[NSString stringWithFormat:@"%i", bidirectional] forKey:@"bidirectonal"];

    [[PIXAPIHandler new] callAPI:@"friendships" httpMethod:@"GET" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friendships", @"GET", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)createFriendshipWithFriendName:(NSString *)friendName completion:(PIXHandlerCompletion)completion{
    if (friendName==nil || friendName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"friendName 參數有誤"]);
        return;
    }
    NSDictionary *params = @{@"user_name":friendName};
    [[PIXAPIHandler new] callAPI:@"friendships" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friendships", @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)appendFriendGroupWithFriendName:(NSString *)friendName groupID:(NSString *)groupId completion:(PIXHandlerCompletion)completion{
    [self operateFriendGroupWithAction:@"append_group" friendName:friendName groupID:groupId completion:completion];
}
-(void)removeFriendGroupWithFriendName:(NSString *)friendName groupID:(NSString *)groupId completion:(PIXHandlerCompletion)completion{
    [self operateFriendGroupWithAction:@"remove_group" friendName:friendName groupID:groupId completion:completion];
}
/**
 *  將某個朋友加入或移出 group 用這個 method 整合
 */
-(void)operateFriendGroupWithAction:(NSString *)action friendName:(NSString *)friendName groupID:(NSString *)groupId completion:(PIXHandlerCompletion)completion{
    if (groupId==nil || groupId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupId 參數有誤"]);
        return;
    }
    if (friendName==nil || friendName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"friendName 參數有誤"]);
        return;
    }
    NSDictionary *params = @{@"user_name":friendName, @"group_id":groupId};
    NSString *path = [NSString stringWithFormat:@"friendships/%@", action];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)deleteFriendshipWithFriendName:(NSString *)friendName completion:(PIXHandlerCompletion)completion{
    if (friendName==nil || friendName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"friendName 參數有誤"]);
        return;
    }
    NSDictionary *param = @{@"user_name":friendName};
    [[PIXAPIHandler new] callAPI:@"friendships/delete" httpMethod:@"POST" shouldAuth:YES parameters:param requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friendships/delete", @"POST", @YES, param, completion] receiver:[PIXAPIHandler new]];
}

-(void)getFriendSubscriptionsWithPage:(NSUInteger)page perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion{
    if (page<1) {
        page = 1;
    }
    if (perPage<1) {
        perPage = 20;
    }
    NSDictionary *params = @{@"page": [NSString stringWithFormat:@"%li", page], @"per_page":[NSString stringWithFormat:@"%li", perPage]};
    [[PIXAPIHandler new] callAPI:@"friend/subscriptions" httpMethod:@"GET" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friend/subscriptions", @"GET", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)createFriendSubscriptionWithUserName:(NSString *)userName groupIDs:(NSArray *)groupIds completion:(PIXHandlerCompletion)completion{
    if (userName==nil || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"friendName 參數有誤"]);
        return;
    }
    if (groupIds) {
        for (id groupId in groupIds) {
            if (![groupId isKindOfClass:[NSString class]]) {
                completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupIds 裡每個值都要是 NSString 才行"]);
                return;
            }
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:userName forKey:@"user"];
    if (groupIds) {
        [params setObject:[groupIds componentsJoinedByString:@","] forKey:@"group_ids"];
    }
    [[PIXAPIHandler new] callAPI:@"friend/subscriptions" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friend/subscriptions", @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)joinFriendSubscriptionGroupsWithUserName:(NSString *)userName groupIDs:(NSArray *)groupIds completion:(PIXHandlerCompletion)completion{
    [self joinOrLeaveFriendSubscriptionGroupsWithAction:@"join_subscription_group" UserName:userName groupIDs:groupIds completion:completion];
}
-(void)leaveFriendSubscriptionGroupsWithUserName:(NSString *)userName groupIDs:(NSArray *)groupIds completion:(PIXHandlerCompletion)completion{
    [self joinOrLeaveFriendSubscriptionGroupsWithAction:@"leave_subscription_group" UserName:userName groupIDs:groupIds completion:completion];
}
/**
 *  用這個 method 來整合將使用者加入群組或自群組移除
 */
-(void)joinOrLeaveFriendSubscriptionGroupsWithAction:(NSString *)action UserName:(NSString *)userName groupIDs:(NSArray *)groupIds completion:(PIXHandlerCompletion)completion{
    if (userName==nil || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"friendName 參數有誤"]);
        return;
    }
    if (groupIds) {
        for (id groupId in groupIds) {
            if (![groupId isKindOfClass:[NSString class]]) {
                completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupIds 裡每個值都要是 NSString 才行"]);
                return;
            }
        }
    } else {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupIds 參數有誤"]);
        return;
    }
    
    NSDictionary *params = @{@"user": userName, @"group_ids":[groupIds componentsJoinedByString:@","]};
    NSString *path = [NSString stringWithFormat:@"friend/subscriptions/%@/%@", userName, action];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)deleteFriendSubscriptionWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion{
    if (userName==nil || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"friendName 參數有誤"]);
        return;
    }
    NSDictionary *params = @{@"_method":@"delete"};
    NSString *path = [NSString stringWithFormat:@"friend/subscriptions/%@", userName];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
\
}
-(void)getFriendSubscriptionGroupsWithCompletion:(PIXHandlerCompletion)completion{
    [[PIXAPIHandler new] callAPI:@"friend/subscription_groups" httpMethod:@"GET" shouldAuth:YES parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friend/subscription_groups", @"GET", @YES, [NSNull null], completion] receiver:[PIXAPIHandler new]];
}
-(void)createFriendSubscriptionGroupWithGroupName:(NSString *)groupName completion:(PIXHandlerCompletion)completion{
    if (groupName==nil || groupName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupName 參數有誤"]);
        return;
    }
    NSDictionary *params = @{@"name": groupName};
    [[PIXAPIHandler new] callAPI:@"friend/subscription_groups" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friend/subscription_groups", @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)updateFriendSubscriptionGroupWithGroupID:(NSString *)groupId newGroupName:(NSString *)newGroupName completion:(PIXHandlerCompletion)completion{
    if (groupId==nil || groupId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupId 參數有誤"]);
        return;
    }
    if (newGroupName==nil || newGroupName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"newGroupName 參數有誤"]);
        return;
    }
    NSDictionary *params = @{@"name": newGroupName};
    NSString *path = [NSString stringWithFormat:@"friend/subscription_groups/%@", groupId];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)positionFriendSubscriptionGroupsWithSortedGroups:(NSArray *)sortedGroups completion:(PIXHandlerCompletion)completion{
    if (!sortedGroups || sortedGroups.count==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"sortedGroups 參數有誤"]);
        return;
    }
    for (id group in sortedGroups) {
        if (![group isKindOfClass:[NSString class]]) {
            completion(NO, nil, [NSError PIXErrorWithParameterName:@"sortedGroups 裡每個值都要是 NSString"]);
            return;
        }
    }
    NSDictionary *params = @{@"ids": [sortedGroups componentsJoinedByString:@","]};
    NSString *path = @"friend/subscription_groups/position";
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)deleteFriendSubscriptionGroupWithGroupID:(NSString *)groupId completion:(PIXHandlerCompletion)completion{
    if (groupId==nil || groupId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupId 參數有誤"]);
        return;
    }
    NSDictionary *params = @{@"_method":@"delete"};
    NSString *path = [NSString stringWithFormat:@"friend/subscription_groups/%@", groupId];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)getFriendNewsWithNewsType:(PIXFriendNewsType)newsType groupID:(NSString *)groupId beforeTime:(NSDate *)beforeTime completion:(PIXHandlerCompletion)completion{
    NSString *typeString = nil;
    switch (newsType) {
        case PIXFriendNewsTypeFriend:
            typeString = @"friend";
            break;
            
        default:
        case PIXFriendNewsTypeSubscription:
            typeString = @"subscription";
            break;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"group_type"] = typeString;
    if (groupId && groupId.length>0) {
        params[@"group_id"] = groupId;
    }
    if (beforeTime) {
        params[@"before_time"] = [NSString stringWithFormat:@"%f", [beforeTime timeIntervalSince1970]];
    }
    NSString *path = [NSString stringWithFormat:@"friend/news"];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"GET" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"GET", @YES, params, completion] receiver:[PIXAPIHandler new]];

}
@end
