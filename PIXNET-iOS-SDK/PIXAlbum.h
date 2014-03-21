//
//  PIXAlbum.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/20/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
/**
 *  Album 裡的影音資料格式
 */
typedef NS_ENUM(NSInteger, PIXAlbumElementType){
    /**
     *  圖片
     */
    PIXAlbumElementTypePic,
    /**
     *  影片
     */
    PIXAlbumElementTypeVideo,
    /**
     *  音樂
     */
    PIXAlbumElementTypeAudio
};

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
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
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
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumSetsWithUserName:(NSString *)userName parentID:(NSString *)parentID trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(RequestCompletion)completion;
/**
 *  讀取個人相簿單一Set http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetsShow
 *
 *  @param userName   指定要回傳的使用者資訊, 必要參數
 *  @param setId      指定要回傳的 set 的 ID, 必要參數
 *  @param page       頁數
 *  @param perPage    每頁幾筆
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumSetWithUserName:(NSString *)userName setID:(NSInteger)setId page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(RequestCompletion)completion;
/**
 *  列出相簿裡有些什麼東西 http://developer.pixnet.pro/#!/doc/pixnetApi/albumElements
 *
 *  @param userName    指定要回傳的使用者資訊, 必要參數
 *  @param setId       指定要回傳的 set 的資訊, 必要參數
 *  @param elementType 指定要回傳的類別
 *  @param page        頁數
 *  @param perPage     每頁幾筆
 *  @param password    相簿密碼，當使用者相簿設定為密碼相簿時使用
 *  @param withDetail  傳回詳細資訊，指定為 YES 時將會回傳完整圖片資訊
 *  @param trimUser    不傳回相片擁有者資訊，指定為 YES 時將不會回傳相片擁有者資訊
 *  @param shouldAuth  是否需要認證
 *  @param completion  succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumSetElementsWithUserName:(NSString *)userName setID:(NSInteger)setId elementType:(PIXAlbumElementType)elementType page:(NSUInteger)page perPage:(NSUInteger)perPage password:(NSString *)password withDetail:(BOOL)withDetail trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(RequestCompletion)completion;
/**
 *  列出相簿(或照片)的留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetComments
 *
 *  @param userName   指定要回傳的使用者資訊, 必要參數
 *  @param elementId  指定要回傳的留言所在的相簿 setID 與 elementID 只要指定其中一個即可, 未用到的參數請給0
 *  @param setId      指定要回傳的留言所在的相簿 setID 與 elementID 只要指定其中一個即可, 未用到的參數請給0
 *  @param password   如果指定使用者的相簿被密碼保護，則需要指定這個參數以通過授權
 *  @param page       頁數
 *  @param perPage    每頁幾筆
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumSetCommentsWithUserName:(NSString *)userName elementID:(NSUInteger)elementId setID:(NSUInteger)setId password:(NSString *)password page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(RequestCompletion)completion;
#pragma Folders

#pragma Element
@end
