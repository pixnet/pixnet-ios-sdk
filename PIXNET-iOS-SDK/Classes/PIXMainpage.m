//
//  PIXMainpage.m
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/4/15.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//

#import "PIXMainpage.h"

@implementation PIXMainpage
-(void)getMainpageBlogCategoriesWithCategoryID:(NSString *)categoryId articleType:(PIXMainpageType)articleType page:(NSUInteger)page perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion{
    if (!categoryId || categoryId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"categoryId 參數有誤"]);
        return;
    }
    NSString *typeString = [self maintypeStringWithType:articleType];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    if (page < 1) {
        page = 1;
    }
    params[@"page"] = [NSString stringWithFormat:@"%li", page];
    if (perPage < 1) {
        perPage = 10;
    }
    params[@"count"] = [NSString stringWithFormat:@"%li", perPage];
    NSString *path = [NSString stringWithFormat:@"mainpage/blog/categories/%@/%@", typeString, categoryId];
    
    [[PIXAPIHandler new] callAPI:path parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, error);
        }
    }];

//    [self invokeMethod:@selector(callAPI:parameters:requestCompletion:) parameters:@[path, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)getMainpageAlbumsWithCategoryIDs:(NSArray *)categoryIds albumType:(PIXMainpageType)albumType page:(NSUInteger)page perPage:(NSUInteger)perPage strictFilter:(BOOL)strictFilter completion:(PIXHandlerCompletion)completion{
    if (!categoryIds || categoryIds.count==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"categoryIds 參數有誤"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    if (page < 1) {
        page = 1;
    }
    params[@"page"] = [NSString stringWithFormat:@"%li", page];
    if (perPage < 1) {
        perPage = 10;
    }
    params[@"count"] = [NSString stringWithFormat:@"%li", perPage];
    params[@"strict_filter"] = [NSString stringWithFormat:@"%i", strictFilter];
    params[@"api_version"] = @"2";
//    params[@"category_id"] = [categoryIds componentsJoinedByString:@","];
    
    NSString *typeString = [self maintypeStringWithType:albumType];
    NSString *path = [NSString stringWithFormat:@"mainpage/album/categories/%@/%@", typeString, [categoryIds componentsJoinedByString:@","]];
    
    [[PIXAPIHandler new] callAPI:path parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, error);
        }
    }];

//    [self invokeMethod:@selector(callAPI:parameters:requestCompletion:) parameters:@[path, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)getMainpageVideosWithVideoType:(PIXMainpageType)videoType page:(NSUInteger)page perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion{
    if (page < 1) {
        page = 1;
    }
    if (perPage < 1) {
        perPage = 10;
    }

    NSString *typeString = [self maintypeStringWithType:videoType];
    NSString *path = [NSString stringWithFormat:@"mainpage/album/video/%@", typeString];
    NSDictionary *params = @{@"page": [NSString stringWithFormat:@"%li", page],
                             @"count": [NSString stringWithFormat:@"%li", perPage]};
    
    [[PIXAPIHandler new] callAPI:path parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, error);
        }
    }];
//    [self invokeMethod:@selector(callAPI:parameters:requestCompletion:) parameters:@[path, params, completion] receiver:[PIXAPIHandler new]];
}
-(void)getMainpageAlbumsBestSelectedWithCompletion:(PIXHandlerCompletion)completion{
    NSString *path = @"mainpage/album/best_selected";
    
    [[PIXAPIHandler new] callAPI:path parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, error);
        }
    }];
//    [self invokeMethod:@selector(callAPI:parameters:requestCompletion:) parameters:@[path, [NSNull null], completion] receiver:[PIXAPIHandler new]];
}

-(NSString *)maintypeStringWithType:(PIXMainpageType)type{
    NSString *typeString = nil;
    switch (type) {
        case PIXMainpageTypeHot:
            typeString = @"hot";
            break;
        case PIXMainpageTypeLatest:
            typeString = @"latest";
            break;
        default:
        case PIXMainpageTypeHotWeekly:
            typeString = @"hot_weekly";
            break;
    }
    return typeString;
}
@end
