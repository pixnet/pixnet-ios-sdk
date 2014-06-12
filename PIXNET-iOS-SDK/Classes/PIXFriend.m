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
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friend/groups", @"GET", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
- (void)createFriendGroupsWithGroupName:(NSString *)groupName completion:(PIXHandlerCompletion)completion{
    if (groupName==nil || groupName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupName 參數有誤"]);
        return;
    }
    NSDictionary *params = @{@"name":groupName};
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friend/groups", @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
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
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
- (void)deleteFriendGroupWithGroupID:(NSString *)groupId completion:(PIXHandlerCompletion)completion{
    if (groupId==nil || groupId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupId 參數有誤"]);
        return;
    }
    NSString *path = [NSString stringWithFormat:@"friend/groups/%@", groupId];
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, @{@"_method":@"delete"}, completion] receiver:[PIXAPIHandler new]];
}

-(void)createFriendshipWithFriendName:(NSString *)friendName completion:(PIXHandlerCompletion)completion{
    if (friendName==nil || friendName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"friendName 參數有誤"]);
        return;
    }
    NSDictionary *params = @{@"user_name":friendName};
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friendships", @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)appendFriendGroupWithFriendName:(NSString *)friendName groupID:(NSString *)groupId completion:(PIXHandlerCompletion)completion{
    if (groupId==nil || groupId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"groupId 參數有誤"]);
        return;
    }
    if (friendName==nil || friendName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"friendName 參數有誤"]);
        return;
    }
    NSDictionary *params = @{@"user_name":friendName, @"group_id":groupId};
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[@"friendships/append_group", @"POST", @YES, params, completion] receiver:[PIXAPIHandler new]];
}
@end
