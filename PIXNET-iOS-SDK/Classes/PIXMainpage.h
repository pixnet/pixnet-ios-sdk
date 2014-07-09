//
//  PIXMainpage.h
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
 *  取得何種類型的物件
 */
typedef NS_ENUM(NSInteger, PIXMainpageType) {
    /**
     *  熱門
     */
    PIXMainpageTypeHot,
    /**
     *  最新
     */
    PIXMainpageTypeLatest,
    /**
     *  近期熱門
     */
    PIXMainpageTypeHotWeekly
};

@interface PIXMainpage : NSObject
/**
 *  取得某個類別底下的文章 http://developer.pixnet.pro/#!/doc/pixnetApi/mainpageBlogCategories
 *
 *  @param categoryId  這個參數可在上述網址找到，或利用 PIXBlog 的 -getBlogCategoriesListIncludeGroups:thumbs:completion: 取得，必要參數。
 *  @param articleType 有 熱門/最新/近期熱門 三種選項。
 *  @param page        頁數
 *  @param perPage     每頁幾筆
 *  @param completion  PIXHandlerCompletion
 */
-(void)getMainpageBlogCategoriesWithCategoryID:(NSString *)categoryId articleType:(PIXMainpageType)articleType page:(NSUInteger)page perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion;
/**
 *  取得某些類別底下的相簿 http://developer.pixnet.pro/#!/doc/pixnetApi/mainpageAlbumCategories
 *
 *  @param categoryIds  哪幾個相簿類別的類別id，這個參數可在上述網址找到，或利用 PIXAlbum 的 -getAlbumSiteCategoriesWithIsIncludeGroups:isIncludeThumbs:completion: 取得。這是必要參數
 *  @param albumType    有 熱門/最新/近期熱門 三種選項。
 *  @param page         頁數
 *  @param perPage      每頁幾筆
 *  @param strictFilter 是否過濾腥羶色內容
 *  @param completion   PIXHandlerCompletion
 */
-(void)getMainpageAlbumsWithCategoryIDs:(NSArray *)categoryIds albumType:(PIXMainpageType)albumType page:(NSUInteger)page perPage:(NSUInteger)perPage strictFilter:(BOOL)strictFilter completion:(PIXHandlerCompletion)completion;
/**
 *  取得精選相簿 http://developer.pixnet.pro/#!/doc/pixnetApi/mainpageAlbumBestSelected
 *
 *  @param completion PIXHandlerCompletion
 */
-(void)getMainpageAlbumsBestSelectedWithCompletion:(PIXHandlerCompletion)completion;
/**
 *  取得某種類型的影音 http://developer.pixnet.pro/#!/doc/pixnetApi/mainpageAlbumVideo
 *
 *  @param videoType  有 熱門/最新/近期熱門 三種選項。
 *  @param page       頁數
 *  @param perPage    每頁幾筆
 *  @param completion PIXHandlerCompletion
 */
-(void)getMainpageVideosWithVideoType:(PIXMainpageType)videoType page:(NSUInteger)page perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion;
@end
