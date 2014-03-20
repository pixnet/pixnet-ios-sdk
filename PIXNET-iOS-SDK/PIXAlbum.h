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
-(void)fetchAlbumListWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSInteger)page perPage:(NSInteger)perPage completion:(RequestCompletion)completion;

#pragma Sets
/**
 *  列出個人相簿個人 Sets http://developer.pixnet.pro/#!/doc/pixnetApi/albumSets
 *
 *  @param userName   指定要回傳的使用者資訊,必要參數
 *  @param parentID   可以藉此指定拿到特定相簿資料夾底下的相簿
 *  @param trimUser   是否每篇文章都要回傳作者資訊, 如果設定為 1, 則就不回傳. 預設是 NO
 *  @param page       頁數, 預設為1
 *  @param perPage    每頁幾筆, 預設為100
 *  @param shouldAuth 請求對象是被保護時，這裡請給 YES
 *  @param completion RequestCompletion
 */
-(void)fetchAlbumSetsWithUserName:(NSString *)userName parentID:(NSString *)parentID trimUser:(BOOL)trimUser page:(NSInteger)page perPage:(NSInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(RequestCompletion)completion;
#pragma Folders

#pragma Element
@end
