//
//  PIXAlbum.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/20/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//
static const NSString *kSetsNearbyPath = @"album/sets/nearby";

#import "PIXAlbum.h"
#import "NSObject+PIXCategory.h"
#import "NSError+PIXCategory.h"
@implementation PIXAlbum
-(void)getAlbumSiteCategoriesWithIsIncludeGroups:(BOOL)isIncludeGroups isIncludeThumbs:(BOOL)isIncludeThumbs completion:(PIXHandlerCompletion)completion{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"include_groups"] = [NSString stringWithFormat:@"%i", isIncludeGroups];
    params[@"include_thumbs"] = [NSString stringWithFormat:@"%i", isIncludeThumbs];
    [[PIXAPIHandler new] callAPI:@"album/site_categories" parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:parameters:requestCompletion:) parameters:@[@"album/site_categories", params, completion] receiver:[PIXAPIHandler new]];
}
-(void)getAlbumMainWithCompletion:(PIXHandlerCompletion)completion{
    [[PIXAPIHandler new] callAPI:@"album/main" httpMethod:@"GET" shouldAuth:YES parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
//    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:uploadData:parameters:requestCompletion:) parameters:@[@"album/main", @"GET", @YES, [NSNull null], [NSNull null], completion] receiver:[PIXAPIHandler new]];
}
-(void)getAlbumConfigWithCompletion:(PIXHandlerCompletion)completion{
    [[PIXAPIHandler new] callAPI:@"album/config" httpMethod:@"GET" shouldAuth:YES parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, error);
        }
    }];
}
-(void)getAlbumSetsWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil,[NSError PIXErrorWithParameterName:@"userName"]);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"trim_user"] = @(trimUser);
    params[@"page"] = @(page);
    params[@"per_page"] = @(perPage);
    [[PIXAPIHandler new] callAPI:@"album/setfolders" parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, error);
        }
    }];
}
-(void)sortSetFoldersWithFolderIDs:(NSArray *)ids completion:(PIXHandlerCompletion)completion{
    [self sortAlbumSetsOrFoldersWithParentID:nil IDs:ids completion:completion];
}
-(void)sortAlbumSetsWithParentID:(NSString *)parentId IDs:(NSArray *)ids completion:(PIXHandlerCompletion)completion{
    if (parentId == nil || parentId.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"parentId"]);
        return;
    }
    [self sortAlbumSetsOrFoldersWithParentID:parentId IDs:ids completion:completion];
}
/**
 *  對相簿排序的 API 的參數幾乎相同，所以用這個 method 整合
 */
-(void)sortAlbumSetsOrFoldersWithParentID:(NSString *)parentId IDs:(NSArray *)ids completion:(PIXHandlerCompletion)completion{
    if (ids == nil || [ids count] == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"ids 參數有誤"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"ids"] = [ids componentsJoinedByString:@"-"];
    
    NSString *path = nil;
    if (parentId == nil) {
        path = @"album/setfolders/position";
    } else {
        path = @"album/sets/position";
        params[@"parent_id"] = parentId;
    }
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, error);
        }
    }];
}
-(void)getAlbumSetsWithUserName:(NSString *)userName
                       parentID:(NSString *)parentID
                       trimUser:(BOOL)trimUser
                           page:(NSUInteger)page
                        perPage:(NSUInteger)perPage
                     shouldAuth:(BOOL)shouldAuth
                     completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName"]);
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"trim_user"] = @(trimUser);
    params[@"page"] = @(page);
    params[@"per_page"] = @(perPage);
    if (parentID != nil && parentID.length > 0) {
        params[@"parent_id"] = parentID;
    }
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:@"album/sets" parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, error);
            }
        }];
    }
}
-(void)getAlbumSetWithUserName:(NSString *)userName setID:(NSString *)setId page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName 是必要參數"]);
        return;
    }
    if (setId==nil || setId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"setID 參數有誤"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"page"] = @(page);
    params[@"per_page"] = @(perPage);
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"album/sets/%li", (long)setId] parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, error);
            }
        }];
    }
}
-(void)createAlbumSetWithTitle:(NSString *)setTitle description:(NSString *)setDescription permission:(PIXAlbumSetPermissionType)permission categoryID:(NSString *)categoryId isLockRight:(BOOL)isLockRight isAllowCC:(BOOL)isAllowCc commentRightType:(PIXAlbumSetCommentRightType)commentRightType password:(NSString *)password passwordHint:(NSString *)passwordHint friendGroupIDs:(NSArray *)friendGroupIds allowCommercialUse:(BOOL)allowCommercialUse allowDerivation:(BOOL)allowDerivation parentID:(NSString *)parentId completion:(PIXHandlerCompletion)completion{
    [self createOrUpdateAlbumSetWithSetID:nil setTitle:setTitle setDescription:setDescription permission:permission categoryID:categoryId isLockRight:isLockRight isAllowCC:isAllowCc commentRightType:commentRightType password:password passwordHint:passwordHint friendGroupIDs:friendGroupIds allowCommercialUse:allowCommercialUse allowDerivation:allowDerivation parentID:parentId completion:completion];
}
-(void)updateAlbumSetWithSetID:(NSString *)setId setTitle:(NSString *)setTitle setDescription:(NSString *)setDescription permission:(PIXAlbumSetPermissionType)permission categoryID:(NSString *)categoryId isLockRight:(BOOL)isLockRight isAllowCC:(BOOL)isAllowCc commentRightType:(PIXAlbumSetCommentRightType)commentRightType password:(NSString *)password passwordHint:(NSString *)passwordHint friendGroupIDs:(NSArray *)friendGroupIds allowCommercialUse:(BOOL)allowCommercialUse allowDerivation:(BOOL)allowDerivation parentID:(NSString *)parentId completion:(PIXHandlerCompletion)completion{
    if (setId == nil || setId.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"setId 參數有誤"]);
        return;
    }
    [self createOrUpdateAlbumSetWithSetID:setId setTitle:setTitle setDescription:setDescription permission:permission categoryID:categoryId isLockRight:isLockRight isAllowCC:isAllowCc commentRightType:commentRightType password:password passwordHint:passwordHint friendGroupIDs:friendGroupIds allowCommercialUse:allowCommercialUse allowDerivation:allowDerivation parentID:parentId completion:completion];
}
-(void)createOrUpdateAlbumSetWithSetID:(NSString *)setId setTitle:(NSString *)setTitle setDescription:(NSString *)setDescription permission:(PIXAlbumSetPermissionType)permission categoryID:(NSString *)categoryId isLockRight:(BOOL)isLockRight isAllowCC:(BOOL)isAllowCc commentRightType:(PIXAlbumSetCommentRightType)commentRightType password:(NSString *)password passwordHint:(NSString *)passwordHint friendGroupIDs:(NSArray *)friendGroupIds allowCommercialUse:(BOOL)allowCommercialUse allowDerivation:(BOOL)allowDerivation parentID:(NSString *)parentId completion:(PIXHandlerCompletion)completion{
    if (setTitle == nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"相簿標題是必要參數"]);
        return;
    }
    if (setDescription == nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"相簿描述是必要參數"]);
        return;
    }
    if (permission == PIXAlbumSetPermissionTypePassword && password == nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"相簿閱讀權限為密碼，但您尚未設定密碼"]);
        return;
    }
    if (permission == PIXAlbumSetPermissionTypePassword && passwordHint == nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"相簿閱讀權限為密碼，但您尚未設定密碼提示"]);
        return;
    }
    if (permission == PIXAlbumSetPermissionTypeGroup && (friendGroupIds == nil || [friendGroupIds count] == 0)) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"相簿閱讀權限為好友群組，但您尚未設定好友群組"]);
        return;
    }
    for (id friendGroup in friendGroupIds) {
        if (![friendGroup isKindOfClass:[NSString class]]) {
            completion(NO, nil, [NSError PIXErrorWithParameterName:[NSString stringWithFormat:@"%@ 不是 NSString instance 哦", friendGroup]]);
            return;
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"title"] = setTitle;
    params[@"description"] = setDescription;
    params[@"permission"] = [NSString stringWithFormat:@"%ld", (long)permission];
    if (categoryId) {
        params[@"category_id"] = [NSString stringWithFormat:@"%@", categoryId];
    }
    params[@"is_lockright"] = [NSString stringWithFormat:@"%i", isLockRight];
    params[@"allow_cc"] = [NSString stringWithFormat:@"%i", isAllowCc];
    params[@"cancomment"] = [NSString stringWithFormat:@"%ld", (long)commentRightType];
    if (password) {
        params[@"password"] = password;
    }
    if (passwordHint) {
        params[@"password_hint"] = passwordHint;
    }
    if (friendGroupIds) {
        params[@"friend_group_ids"] = [friendGroupIds componentsJoinedByString:@"-"];
    }
    params[@"allow_commercial_usr"] = [NSString stringWithFormat:@"%i", allowCommercialUse];
    params[@"allow_derivation"] = [NSString stringWithFormat:@"%i", allowDerivation];
    if (parentId) {
        params[@"parent_id"] = parentId;
    }
    if (setId == nil) {
        [[PIXAPIHandler new] callAPI:@"album/sets" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, error);
            }
        }];
    } else {
        NSString *path = [NSString stringWithFormat:@"album/sets/%@", setId];
        [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, error);
            }
        }];
    }
}
-(void)markAlbumSetCommentAsSpamWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion{
    [self markCommentAsSpamOrHamWithCommentID:commentId isSpam:NO isCommentInSet:YES completion:completion];
}
-(void)markAlbumSetCommentAsHamWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion{
    [self markCommentAsSpamOrHamWithCommentID:commentId isSpam:NO isCommentInSet:YES completion:completion];
}
-(void)markCommentAsSpamWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion{
    [self markCommentAsSpamOrHamWithCommentID:commentId isSpam:YES isCommentInSet:NO completion:completion];
}
-(void)markCommentAsHamWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion{
    [self markCommentAsSpamOrHamWithCommentID:commentId isSpam:NO isCommentInSet:NO completion:completion];
}
-(void)markCommentAsSpamOrHamWithCommentID:(NSString *)commentId isSpam:(BOOL)isSpam isCommentInSet:(BOOL)isCommentInSet completion:(PIXHandlerCompletion)completion{
    if (commentId==nil || commentId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"commentId 參數有誤"]);
        return;
    }
    NSString *pathPrefix = nil;
    if (isCommentInSet) {
        pathPrefix = @"album/set_comments/";
    } else {
        pathPrefix = @"album/comments/";
    }
    NSString *path = nil;
    if (isSpam) {
        path = [NSString stringWithFormat:@"%@%@/mark_spam", pathPrefix, commentId];
    } else {
        path = [NSString stringWithFormat:@"%@%@/mark_ham", pathPrefix, commentId];
    }
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}
-(void)deleteCommentWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion{
    if (commentId==nil || commentId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"commentId 參數有誤"]);
        return;
    }
    NSString *path = [NSString stringWithFormat:@"album/comments/%@", commentId];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:@{@"_method":@"delete"} requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}
-(void)deleteAlbumSetWithSetID:(NSString *)setId completion:(PIXHandlerCompletion)completion{
    if (setId==nil || setId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"setId 參數有誤"]);
        return;
    }
    NSString *path = [NSString stringWithFormat:@"album/sets/%@", setId];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:@{@"_method":@"delete"} requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}
-(void)getAlbumSetElementsWithUserName:(NSString *)userName setID:(NSString *)setId elementType:(PIXAlbumElementType)elementType page:(NSUInteger)page perPage:(NSUInteger)perPage password:(NSString *)password withDetail:(BOOL)withDetail trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    if (setId==nil || setId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"setID 參數有誤"]);
        return;
    }
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName 是必要參數"]);
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    switch (elementType) {
        case PIXAlbumElementTypePic:
            params[@"type"] = @"pic";
            break;
        case PIXAlbumElementTypeAudio:
            params[@"type"] = @"audio";
            break;
        case PIXAlbumElementTypeVideo:
            params[@"type"] = @"video";
            break;
        default:
            completion(NO, nil, [NSError PIXErrorWithParameterName:@"elementType 參數有誤"]);
            return;
            break;
    }
    if (password != nil) {
        params[@"password"] = password;
    }
    params[@"set_id"] = setId;
    params[@"page"] = [NSString stringWithFormat:@"%lu", (unsigned long)page];
    params[@"per_page"] = [NSString stringWithFormat:@"%lu", (unsigned long)perPage];
    params[@"with_detail"] = [NSString stringWithFormat:@"%i", withDetail];
    params[@"trim_user"] = [NSString stringWithFormat:@"%i", trimUser];
    
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:@"album/elements" parameters:params requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}
-(void)getAlbumSetCommentsWithUserName:(NSString *)userName setID:(NSString *)setId password:(NSString *)password page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    [self getAlbumCommentsWithUserName:userName elementID:nil setID:setId password:password page:page perPage:perPage shouldAuth:shouldAuth completion:completion];
}
-(void)getAlbumCommentsWithUserName:(NSString *)userName elementID:(NSString *)elementId setID:(NSString *)setId password:(NSString *)password page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    BOOL isElement = YES;
    if (elementId==nil || elementId.length == 0) {
        isElement = NO;
    }
    BOOL isSetId = YES;
    if (setId==nil || setId.length == 0) {
        isSetId = NO;
    }
    if (isSetId == NO && isElement == NO) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"elementID 或 setID 有誤"]);
        return;
    }
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName 參數有誤"]);
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"page"] = @(page);
    params[@"per_page"] = @(perPage);
    if (isElement) {
        params[@"element_id"] = elementId;
    }
    if (isSetId) {
        params[@"set_id"] = setId;
    }
    if (password != nil) {
        params[@"password"] = password;
    }
    NSString *path = nil;
    if (isSetId) {
        path = @"album/set_comments";
    } else {
        path = @"album/comments";
    }
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:path parameters:params requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}
-(void)getAlbumSetsNearbyWithUserName:(NSString *)userName location:(CLLocationCoordinate2D)location distanceMin:(NSUInteger)distanceMin distanceMax:(NSUInteger)distanceMax page:(NSUInteger)page perPage:(NSUInteger)perPage trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    [self getAlbumElementsOrSetsNearbyWithPath:[kSetsNearbyPath copy] userName:userName location:location distanceMin:distanceMin distanceMax:distanceMax page:page perPage:perPage withDetail:NO type:999 trimUser:trimUser shouldAuth:shouldAuth completion:completion];
}
-(void)getElementsNearbyWithUserName:(NSString *)userName location:(CLLocationCoordinate2D)location distanceMin:(NSUInteger)distanceMin distanceMax:(NSUInteger)distanceMax page:(NSUInteger)page perPage:(NSUInteger)perPage withDetail:(BOOL)withDetail type:(PIXAlbumElementType)type trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    [self getAlbumElementsOrSetsNearbyWithPath:@"album/elements/nearby" userName:userName location:location distanceMin:distanceMin distanceMax:distanceMax page:page perPage:perPage withDetail:withDetail type:type trimUser:trimUser shouldAuth:shouldAuth completion:completion];
}
-(void)getAlbumElementsOrSetsNearbyWithPath:(NSString *)path userName:(NSString *)userName location:(CLLocationCoordinate2D)location distanceMin:(NSUInteger)distanceMin distanceMax:(NSUInteger)distanceMax page:(NSUInteger)page perPage:(NSUInteger)perPage withDetail:(BOOL)withDetail type:(PIXAlbumElementType)type trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"UserName 參數有誤"]);
        return;
    }
    if (!CLLocationCoordinate2DIsValid(location)) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"location 參數是空值"]);
        return;
    }
    if (distanceMin > 50000) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"distanceMin 必須介於 0-50000之間"]);
        return;
    }
    if (distanceMax <= 0 || distanceMax > 50000) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"distanceMax 必須介於 0-50000之間"]);
        return;
    }
    if (distanceMin > distanceMax) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"distanceMin 必需小於 distanceMax"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"lat"] = [NSString stringWithFormat:@"%f", location.latitude];
    params[@"lon"] = [NSString stringWithFormat:@"%f", location.longitude];
    params[@"distance_min"] = [NSString stringWithFormat:@"%lu", (unsigned long)distanceMin];
    params[@"distance_max"] = [NSString stringWithFormat:@"%lu", (unsigned long)distanceMax];
    params[@"page"] = [NSString stringWithFormat:@"%lu", (unsigned long)page];
    params[@"perPage"] = [NSString stringWithFormat:@"%lu", (unsigned long)perPage];
    params[@"trim_user"] = [NSString stringWithFormat:@"%i", trimUser];
    switch (type) {
        case PIXAlbumElementTypePic:
            params[@"type"] = @"pic";
            break;
        case PIXAlbumElementTypeVideo:
            params[@"type"] = @"video";
            break;
        case PIXAlbumElementTypeAudio:
            params[@"type"] = @"audio";
            break;
        default:
            break;
    }
    //相簿留言沒有 with_detail 這個參數, 相片留言才有
    if (![path isEqualToString:[kSetsNearbyPath copy]]) {
        params[@"with_detail"] = [NSString stringWithFormat:@"%i", withDetail];
    }
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:path parameters:params requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}
-(void)getElementWithUserName:(NSString *)userName
                    elementID:(NSString *)elementId
                  withSetInfo:(BOOL)withSetInfo
                   completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"UserName 參數有誤"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"with_set"] = [NSString stringWithFormat:@"%i", withSetInfo];
    NSString *path = [NSString stringWithFormat:@"album/elements/%@", elementId];
    [[PIXAPIHandler new] callAPI:path
                      httpMethod:@"GET"
                      shouldAuth:YES
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}
-(void)getElementCommentsWithUserName:(NSString *)userName elementID:(NSString *)elementId password:(NSString *)password page:(NSUInteger)page perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion{
    [self getAlbumCommentsWithUserName:userName elementID:elementId setID:nil password:password page:page perPage:perPage shouldAuth:NO completion:completion];
    return;
}
-(void)getAlbumFoldersWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"UserName 參數有誤"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"page"] = [NSString stringWithFormat:@"%lu", (unsigned long)page];
    params[@"perPage"] = [NSString stringWithFormat:@"%lu", (unsigned long)perPage];
    params[@"trim_user"] = [NSString stringWithFormat:@"%i", trimUser];
    
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:@"album/folders" parameters:params requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}
-(void)getAlbumFolderWithUserName:(NSString *)userName folderID:(NSString *)folderId page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"UserName 參數有誤"]);
        return;
    }
    if (folderId == nil || folderId.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"folderID 參數有誤"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"page"] = [NSString stringWithFormat:@"%lu", (unsigned long)page];
    params[@"perPage"] = [NSString stringWithFormat:@"%lu", (unsigned long)perPage];
    
    NSString *pathString = [NSString stringWithFormat:@"album/folders/%@", folderId];
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:pathString parameters:params requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}
-(void)createAlbumFolderWithTitle:(NSString *)folderTitle description:(NSString *)folderDescription completion:(PIXHandlerCompletion)completion{
    [self createOrUpdateAlbumFolderWithFolderID:nil title:folderTitle description:folderDescription completion:completion];
}
-(void)updateAlbumFolderWithFolderID:(NSString *)folderId title:(NSString *)folderTitle description:(NSString *)folderDescription completion:(PIXHandlerCompletion)completion{
    if (folderId==nil || folderId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"folderId 參數有誤"]);
        return;
    }
    [self createOrUpdateAlbumFolderWithFolderID:folderId title:folderTitle description:folderDescription completion:completion];
}
-(void)createOrUpdateAlbumFolderWithFolderID:(NSString *)folderId title:(NSString *)folderTitle description:(NSString *)folderDescription completion:(PIXHandlerCompletion)completion{
    if (folderTitle==nil || folderTitle.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"一定要有資料夾標題"]);
        return;
    }
    if (folderDescription==nil || folderDescription.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"一定要有資料夾描述"]);
        return;
    }
    NSDictionary *params = @{@"title":folderTitle, @"description":folderDescription};
    NSString *path = nil;
    if (folderId==nil) {
        path = @"album/folders";
    } else {
        path = [NSString stringWithFormat:@"album/folders/%@", folderId];
    }
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}
-(void)deleteAlbumFolderWithFolderID:(NSString *)folderId completion:(PIXHandlerCompletion)completion{
    if (folderId==nil || folderId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"folderId 參數有誤"]);
        return;
    }
    NSString *path = [NSString stringWithFormat:@"album/folders/%@", folderId];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:@{@"_method":@"delete"} requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}
-(void)getCommentWithUserName:(NSString *)userName commentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"UserName 參數有誤"]);
        return;
    }
    if (commentId == nil || commentId.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"commentID 參數有誤"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    
    [[PIXAPIHandler new] callAPI:@"album/comments/" parameters:params requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}
-(void)updateElementWithElementID:(NSString *)elementId elementTitle:(NSString *)elementTitle elementDescription:(NSString *)elementDescription setID:(NSString *)setId videoThumbType:(PIXVideoThumbType)videoThumbType tags:(NSArray *)tags location:(CLLocationCoordinate2D)location completion:(PIXHandlerCompletion)completion{
    if (elementId==nil || elementId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"elementId 參數有誤"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (elementTitle && elementTitle.length > 0) {
        params[@"title"] = elementTitle;
    }
    if (elementDescription && elementDescription.length > 0) {
        params[@"description"] = elementDescription;
    }
    if (setId && setId.length>0) {
        params[@"set_id"] = setId;
    }
    switch (videoThumbType) {
        case PIXVideoThumbTypeBeginning:
            params[@"video_thumb_type"] = @"beginning";
            break;
        case PIXVideoThumbTypeMiddle:
            params[@"video_thumb_type"] = @"middle";
            break;
        case PIXVideoThumbTypeEnd:
            params[@"video_thumb_type"] = @"end";
            break;
        default:
            break;
    }
    if (tags && tags.count>0) {
        params[@"tags"] = [tags componentsJoinedByString:@"-"];
    }
    if (CLLocationCoordinate2DIsValid(location)) {
        params[@"latitude"] = [NSString stringWithFormat:@"%g", location.latitude];
        params[@"longitude"] = [NSString stringWithFormat:@"%g", location.longitude];
    }
    NSString *path = [NSString stringWithFormat:@"album/elements/%@", elementId];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}
-(void)deleteElementWithElementID:(NSString *)elementId completion:(PIXHandlerCompletion)completion{
    if (elementId==nil || elementId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"elementId 參數有誤"]);
        return;
    }
    NSString *path = [NSString stringWithFormat:@"album/elements/%@", elementId];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:@{@"_method":@"delete"} requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}
-(void)sortElementsWithSetID:(NSString *)setId elementIDs:(NSArray *)ids completion:(PIXHandlerCompletion)completion{
    if (setId==nil || setId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"setId 參數有誤"]);
        return;
    }
    if (ids==nil || ids.count==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"ids 參數有誤"]);
        return;
    } else {
        for (id elementId in ids) {
            if (![elementId isKindOfClass:[NSString class]]) {
                completion(NO, nil, [NSError PIXErrorWithParameterName:@"ids 裡每一個 value 都要是 NSString 才行"]);
                return;
            }
        }
    }
    NSDictionary *params = @{@"set_id": setId, @"ids":[ids componentsJoinedByString:@"-"]};
    [[PIXAPIHandler new] callAPI:@"album/elements/position" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}

-(void)createElementWithElementData:(NSData *)elementData setID:(NSString *)setId elementTitle:(NSString *)elementTitle elementDescription:(NSString *)elementDescription tags:(NSArray *)tags location:(CLLocationCoordinate2D)location videoThumbType:(PIXVideoThumbType)videoThumbType picShouldRotateByExif:(BOOL)picShouldRotateByExif videoShouldRotateByMeta:(BOOL)videoShouldRotateByMeta shouldUseQuadrate:(BOOL)shouldUseQuadrate shouldAddWatermark:(BOOL)shouldAddWatermark isElementFirst:(BOOL)isElementFirst wouldUploadInBackground:(BOOL)uploadInBackground completion:(PIXHandlerCompletion)completion{
    if (elementData==nil || elementData.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"elementData 參數有誤"]);
        return;
    }
    if (setId==nil || setId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"setId 參數有誤"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"set_id"] = setId;
    params[@"upload_method"] = @"base64";
    params[@"upload_file"] = [elementData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    params[@"upload_file"] = [elementData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (elementTitle) {
        params[@"title"] = elementTitle;
    }
    if (elementDescription) {
        params[@"description"] = elementDescription;
    }
    if (tags && [tags count]>0) {
        params[@"tags"] = [tags componentsJoinedByString:@"-"];
    }
    if (CLLocationCoordinate2DIsValid(location)) {
        params[@"latitude"] = [NSString stringWithFormat:@"%g", location.latitude];
        params[@"longitude"] = [NSString stringWithFormat:@"%g", location.longitude];
    }

    switch (videoThumbType) {
        case PIXVideoThumbTypeBeginning:
            params[@"video_thumb_type"] = @"beginning";
            break;
        case PIXVideoThumbTypeMiddle:
            params[@"video_thumb_type"] = @"middle";
            break;
        case PIXVideoThumbTypeEnd:
            params[@"video_thumb_type"] = @"end";
            break;
        default:
            break;
    }
    params[@"rotate_by_exif"] = [NSString stringWithFormat:@"%i", picShouldRotateByExif];
    params[@"rotate_by_meta"] = [NSString stringWithFormat:@"%i", videoShouldRotateByMeta];
    params[@"quadrate"] = [NSString stringWithFormat:@"%i", shouldUseQuadrate];
    params[@"add_watermark"] = [NSString stringWithFormat:@"%i", shouldAddWatermark];
    params[@"element_first"] = [NSString stringWithFormat:@"%i", isElementFirst];

    [[PIXAPIHandler new] callAPI:@"album/elements" httpMethod:@"POST" shouldAuth:YES shouldExecuteInBackground:uploadInBackground uploadData:nil parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, error);
        }
    }];
}
-(void)createElementWithElementData:(NSData *)elementData setID:(NSString *)setId elementTitle:(NSString *)elementTitle elementDescription:(NSString *)elementDescription tags:(NSArray *)tags location:(CLLocationCoordinate2D)location videoThumbType:(PIXVideoThumbType)videoThumbType picShouldRotateByExif:(BOOL)picShouldRotateByExif videoShouldRotateByMeta:(BOOL)videoShouldRotateByMeta shouldUseQuadrate:(BOOL)shouldUseQuadrate shouldAddWatermark:(BOOL)shouldAddWatermark isElementFirst:(BOOL)isElementFirst completion:(PIXHandlerCompletion)completion{
    [self createElementWithElementData:elementData setID:setId elementTitle:elementTitle elementDescription:elementDescription tags:tags location:location videoThumbType:videoThumbType picShouldRotateByExif:picShouldRotateByExif videoShouldRotateByMeta:videoShouldRotateByMeta shouldUseQuadrate:shouldUseQuadrate shouldAddWatermark:shouldAddWatermark isElementFirst:isElementFirst wouldUploadInBackground:YES completion:completion];
}
-(void)createAlbumSetCommentWithSetID:(NSString *)setId body:(NSString *)body password:(NSString *)password completion:(PIXHandlerCompletion)completion{
    [self createCommentWithBody:body isForAlbumSet:YES parentID:setId password:password completion:completion];
}
-(void)createElementCommentWithElementID:(NSString *)elementID body:(NSString *)body password:(NSString *)password completion:(PIXHandlerCompletion)completion{
    [self createCommentWithBody:body isForAlbumSet:NO parentID:elementID password:password completion:completion];
}
-(void)createCommentWithBody:(NSString *)body isForAlbumSet:(BOOL)isForAlbumSet parentID:(NSString *)parentId password:(NSString *)password completion:(PIXHandlerCompletion)completion{
    if (body==nil || body.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"一定要有留言內容"]);
        return;
    }
    if (parentId==nil || parentId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"一定要有elementId 或是 setId"]);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"body"] = body;
    if (password!=nil && password.length>0) {
        params[@"password"] = password;
    }
    NSString *path = nil;
    if (isForAlbumSet) {
        params[@"set_id"] = parentId;
        path = [NSString stringWithFormat:@"album/set_comments"];
    } else {
        params[@"element_id"] = parentId;
        path = [NSString stringWithFormat:@"album/comments"];
    }

    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}

-(void)tagFriendWithElementID:(NSString *)elementId beTaggedUser:(NSString *)beTaggedUser tagFrame:(CGRect)tagFrame recommendID:(NSString *)recommendId completion:(PIXHandlerCompletion)completion{
    if (elementId==nil || elementId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"elementId 參數有誤"]);
        return;
    }
    if (beTaggedUser==nil || beTaggedUser.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"beTaggedUser 參數有誤"]);
        return;
    }
    if (CGRectIsNull(tagFrame) && recommendId==nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"tagFrame 參數有誤"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = beTaggedUser;
    params[@"element_id"] = elementId;
    if (!CGRectIsNull(tagFrame)) {
        params[@"x"] = [NSString stringWithFormat:@"%g", tagFrame.origin.x];
        params[@"y"] = [NSString stringWithFormat:@"%g", tagFrame.origin.y];
        params[@"w"] = [NSString stringWithFormat:@"%g", tagFrame.size.width];
        params[@"h"] = [NSString stringWithFormat:@"%g", tagFrame.size.height];
    }
    if (recommendId) {
        params[@"recommend_id"] = recommendId;
    }
    [[PIXAPIHandler new] callAPI:@"album/faces" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
    
}
-(void)updateTagedFaceWithFaceId:(NSString *)faceId elementId:(NSString *)elementId beTaggedUser:(NSString *)beTaggedUser newTagFrame:(CGRect)newTagFrame completion:(PIXHandlerCompletion)completion{
    if (faceId==nil ||faceId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"faceId 參數有誤"]);
        return;
    }
    if (elementId==nil || elementId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"elementId 參數有誤"]);
        return;
    }
    if (beTaggedUser==nil || beTaggedUser.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"beTaggedUser 參數有誤"]);
        return;
    }
    if (CGRectIsNull(newTagFrame)) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"newTagFrame 參數有誤"]);
        return;
    }
    NSString *path = [NSString stringWithFormat:@"album/faces/%@", faceId];

    NSDictionary *params = @{@"user":beTaggedUser,
                             @"element_id":elementId,
                             @"x":[NSString stringWithFormat:@"%g", newTagFrame.origin.x],
                             @"y":[NSString stringWithFormat:@"%g", newTagFrame.origin.y],
                             @"w":[NSString stringWithFormat:@"%g", newTagFrame.size.width],
                             @"h":[NSString stringWithFormat:@"%g", newTagFrame.size.height]};
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES uploadData:nil parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, error);
        }
    }];
}
-(void)deleteTagWithFaceId:(NSString *)faceId completion:(PIXHandlerCompletion)completion{
    if (faceId==nil || faceId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"faceId 參數有誤"]);
        return;
    }
    NSString *path = [NSString stringWithFormat:@"album/faces/%@", faceId];
    
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:@{@"_method":@"delete"} requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, error);
        }
    }];
}
@end
