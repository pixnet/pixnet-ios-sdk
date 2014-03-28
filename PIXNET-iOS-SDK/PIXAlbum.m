//
//  PIXAlbum.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/20/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
static const NSString *kSetsNearbyPath = @"album/sets/nearby";

#import "PIXAlbum.h"

@implementation PIXAlbum
-(void)fetchAlbumListWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"userName 是必要參數");
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"trim_user"] = @(trimUser);
    params[@"page"] = @(page);
    params[@"per_page"] = @(perPage);
    [[PIXAPIHandler new] callAPI:@"album/setfolders" parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}

-(void)fetchAlbumSetsWithUserName:(NSString *)userName parentID:(NSString *)parentID trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"userName 是必要參數");
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
        [[PIXAPIHandler new] callAPI:@"album/sets" parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}
-(void)fetchAlbumSetWithUserName:(NSString *)userName setID:(NSString *)setId page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"userName 是必要參數");
        return;
    }
    if (setId==nil || setId.length==0) {
        completion(NO, nil, @"setID 參數有誤");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"page"] = @(page);
    params[@"per_page"] = @(perPage);
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"album/sets/%li", (long)setId] parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}

-(void)fetchAlbumSetElementsWithUserName:(NSString *)userName setID:(NSString *)setId elementType:(PIXAlbumElementType)elementType page:(NSUInteger)page perPage:(NSUInteger)perPage password:(NSString *)password withDetail:(BOOL)withDetail trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    if (setId==nil || setId.length==0) {
        completion(NO, nil, @"setID 參數有誤");
        return;
    }
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"userName 是必要參數");
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
            completion(NO, nil, @"elementType 參數有誤");
            return;
            break;
    }
    if (password != nil) {
        params[@"password"] = password;
    }
    params[@"set_id"] = setId;
    params[@"page"] = [NSString stringWithFormat:@"%lu", page];
    params[@"per_page"] = [NSString stringWithFormat:@"%lu", perPage];
    params[@"with_detail"] = [NSString stringWithFormat:@"%i", withDetail];
    params[@"trim_user"] = [NSString stringWithFormat:@"%i", trimUser];
    
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:@"album/elements" parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}
-(void)fetchAlbumSetCommentsWithUserName:(NSString *)userName elementID:(NSString *)elementId setID:(NSString *)setId password:(NSString *)password page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    [self fetchAlbumCommentsWithUserName:userName elementID:elementId setID:setId password:password page:page perPage:perPage shouldAuth:shouldAuth apiPath:@"album/set_comments" completion:completion];
}
-(void)fetchAlbumCommentsWithUserName:(NSString *)userName elementID:(NSString *)elementId setID:(NSString *)setId password:(NSString *)password page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    [self fetchAlbumCommentsWithUserName:userName elementID:elementId setID:setId password:password page:page perPage:perPage shouldAuth:shouldAuth apiPath:@"album/comments" completion:completion];
}
/**
 *  取得 comments 有兩個 api，參數都一樣，只有 api 路徑不同，所以有這個 private method 的產生
 */
-(void)fetchAlbumCommentsWithUserName:(NSString *)userName elementID:(NSString *)elementId setID:(NSString *)setId password:(NSString *)password page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth apiPath:(NSString *)apiPath completion:(PIXHandlerCompletion)completion{
    BOOL isElement = YES;
    if (elementId==nil || elementId.length == 0) {
        isElement = NO;
    }
    BOOL isSetId = YES;
    if (setId==nil || setId.length == 0) {
        isSetId = NO;
    }
    if (isSetId == NO && isElement == NO) {
        completion(NO, nil, @"elementID 或 setID 有誤");
        return;
    }
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"UserName 參數有誤");
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
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:apiPath parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}
-(void)fetchAlbumSetsNearbyWithUserName:(NSString *)userName location:(CLLocationCoordinate2D)location distanceMin:(NSUInteger)distanceMin distanceMax:(NSUInteger)distanceMax page:(NSUInteger)page perPage:(NSUInteger)perPage trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    [self fetchAlbumElementsOrSetsNearbyWithPath:[kSetsNearbyPath copy] userName:userName location:location distanceMin:distanceMin distanceMax:distanceMax page:page perPage:perPage withDetail:NO type:999 trimUser:trimUser shouldAuth:shouldAuth completion:completion];
}
-(void)fetchAlbumElementsNearbyWithUserName:(NSString *)userName location:(CLLocationCoordinate2D)location distanceMin:(NSUInteger)distanceMin distanceMax:(NSUInteger)distanceMax page:(NSUInteger)page perPage:(NSUInteger)perPage withDetail:(BOOL)withDetail type:(PIXAlbumElementType)type trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    [self fetchAlbumElementsOrSetsNearbyWithPath:@"album/elements/nearby" userName:userName location:location distanceMin:distanceMin distanceMax:distanceMax page:page perPage:perPage withDetail:withDetail type:type trimUser:trimUser shouldAuth:shouldAuth completion:completion];
}
/**
 *  取得附近的相簿及照片的 API 參數幾乎都一樣，所以利用這個 method 來簡化 code
 */
-(void)fetchAlbumElementsOrSetsNearbyWithPath:(NSString *)path userName:(NSString *)userName location:(CLLocationCoordinate2D)location distanceMin:(NSUInteger)distanceMin distanceMax:(NSUInteger)distanceMax page:(NSUInteger)page perPage:(NSUInteger)perPage withDetail:(BOOL)withDetail type:(PIXAlbumElementType)type trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"UserName 參數有誤");
        return;
    }
    if (!CLLocationCoordinate2DIsValid(location)) {
        completion(NO, nil, @"location 參數是空值");
        return;
    }
    if (distanceMin > 50000) {
        completion(NO, nil, @"distanceMin 必須介於 0-50000之間");
        return;
    }
    if (distanceMax <= 0 || distanceMax > 50000) {
        completion(NO, nil, @"distanceMax 必須介於 0-50000之間");
        return;
    }
    if (distanceMin > distanceMax) {
        completion(NO, nil, @"distanceMin 必需小於 distanceMax");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"lat"] = [NSString stringWithFormat:@"%f", location.latitude];
    params[@"lon"] = [NSString stringWithFormat:@"%f", location.longitude];
    params[@"distance_min"] = [NSString stringWithFormat:@"%lu", (unsigned long)distanceMin];
    params[@"distance_max"] = [NSString stringWithFormat:@"%lu", (unsigned long)distanceMax];
    params[@"page"] = [NSString stringWithFormat:@"%li", page];
    params[@"perPage"] = [NSString stringWithFormat:@"%li", perPage];
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
        [[PIXAPIHandler new] callAPI:path parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}
-(void)fetchAlbumFoldersWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"UserName 參數有誤");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"page"] = [NSString stringWithFormat:@"%li", page];
    params[@"perPage"] = [NSString stringWithFormat:@"%li", perPage];
    params[@"trim_user"] = [NSString stringWithFormat:@"%i", trimUser];
    
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:@"album/folders" parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}
-(void)fetchAlbumFolderWithUserName:(NSString *)userName folderID:(NSString *)folderId page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"UserName 參數有誤");
        return;
    }
    if (folderId == nil || folderId.length == 0) {
        completion(NO, nil, @"folderID 參數有誤");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    params[@"page"] = [NSString stringWithFormat:@"%li", page];
    params[@"perPage"] = [NSString stringWithFormat:@"%li", perPage];
    
    NSString *pathString = [NSString stringWithFormat:@"album/folders/%@", folderId];
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:pathString parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}

-(void)fetchAlbumSetCommentWithUserName:(NSString *)userName commentID:(NSString *)commentId shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    [self fetchAlbumOrSetCommentWithPath:@"album/set_comments/" userName:userName commentId:commentId shouldAuth:shouldAuth completion:completion];
}
-(void)fetchAlbumCommentWithUserName:(NSString *)userName commentId:(NSString *)commentId shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    [self fetchAlbumOrSetCommentWithPath:@"album/comments/" userName:userName commentId:commentId shouldAuth:shouldAuth completion:completion];
}
/**
 *  將 Album comment 及 Album set comment 兩支 api 利用 path 這參數，在這裡結合起來
 */
-(void)fetchAlbumOrSetCommentWithPath:(NSString *)path userName:(NSString *)userName commentId:(NSString *)commentId shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"UserName 參數有誤");
        return;
    }
    if (commentId == nil || commentId.length == 0) {
        completion(NO, nil, @"commentID 參數有誤");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    
    NSString *pathString = [NSString stringWithFormat:@"%@%@", path, commentId];
    if (shouldAuth) {
        
    } else {
        [[PIXAPIHandler new] callAPI:pathString parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
            if (succeed) {
                [self succeedHandleWithData:result completion:completion];
            } else {
                completion(NO, nil, errorMessage);
            }
        }];
    }
}
-(void)succeedHandleWithData:(id)data completion:(PIXHandlerCompletion)completion{
    NSError *jsonError;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    if (jsonError == nil) {
        if ([dict[@"error"] intValue] == 0) {
            completion(YES, dict, nil);
        } else {
            completion(NO, nil, dict[@"message"]);
        }
    } else {
        completion(NO, nil, jsonError.localizedDescription);
    }
}

@end
