//
//  PIXAlbum.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/20/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIXAPIHandler.h"

@interface PIXAlbum : NSObject
#pragma Main
// coming soon

#pragma SetFolders
/**
 *  列出相簿列表 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetfolders
 *
 *  @param userName   指定要回傳的使用者資訊,必要參數
 *  @param trimUser   是否每篇文章都要回傳作者資訊, 如果設定為 YES, 則就不回傳. 預設是 NO
 *  @param page       頁數, 預設為1
 *  @param perPage    每頁幾筆, 預設為100
 *  @param completion RequestCompletion
 */
-(void)fetchAlbumListWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage completion:(RequestCompletion)completion;

#pragma Sets
/**
 *  列出個人相簿個人 Sets http://developer.pixnet.pro/#!/doc/pixnetApi/albumSets
 *
 *  @param userName   指定要回傳的使用者資訊,必要參數
 *  @param parentID   可以藉此指定拿到特定相簿資料夾底下的相簿
 *  @param trimUser   是否每篇文章都要回傳作者資訊, 如果設定為 1, 則就不回傳. 預設是 NO
 *  @param page       頁數, 預設為1
 *  @param perPage    每頁幾筆, 預設為100
 *  @param shouldAuth 否, 除非請求對象是被保護的
 *  @param completion RequestCompletion
 */
-(void)fetchAlbumSetsWithUserName:(NSString *)userName parentID:(NSString *)parentID trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(RequestCompletion)completion;
/**
 *  讀取個人相簿單一Set http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetsShow
 *
 *  @param userName   指定要回傳的使用者資訊, 必要參數
 *  @param setId      指定要回傳的 set 的 ID, 必要參數
 *  @param page       頁數
 *  @param perPage    每頁幾筆
 *  @param shouldAuth 否, 除非請求對象是被保護的
 *  @param completion RequestCompletion
 */
-(void)fetchAlbumSetWithUserName:(NSString *)userName setID:(NSInteger)setId page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(RequestCompletion)completion;
#pragma Folders

#pragma Element
@end
