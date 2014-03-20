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
 *  @param userName 指定要回傳的使用者資訊,必填欄位
 *  @param trimUser 是否每篇文章都要回傳作者資訊, 如果設定為 1, 則就不回傳. 預設是 0
 *  @param page     頁數, 預設為1
 *  @param perPage  每頁幾筆, 預設為100
 *  @param completion RequestCompletion
 */
-(void)fetchAlbumListWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSInteger)page perPage:(NSInteger)perPage completion:(RequestCompletion)completion;

#pragma Sets

#pragma Folders

#pragma Element
@end
