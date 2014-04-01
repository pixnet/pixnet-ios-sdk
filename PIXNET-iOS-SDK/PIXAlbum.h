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
/**
 *  相簿閱讀權限
 */
typedef NS_ENUM(NSInteger, PIXAlbumSetPermissionType) {
    /**
     *  完全公開
     */
    PIXAlbumSetPermissionTypeOpen = 0,
    /**
     *  好友相簿
     */
    PIXAlbumSetPermissionTypeFriend = 1,
    /**
     *  密碼相簿
     */
    PIXAlbumSetPermissionTypePassword = 3,
    /**
     *  隱藏相簿
     */
    PIXAlbumSetPermissionTypeHidden = 4,
    /**
     *  好友群組相簿
     */
    PIXAlbumSetPermissionTypeGroup = 5
};
/**
 *  相簿留言權限
 */
typedef NS_ENUM(NSInteger, PIXAlbumSetCommentRightType) {
    /**
     *  禁止留言
     */
    PIXAlbumSetCommentRightTypeNO,
    /**
     *  開放留言
     */
    PIXAlbumSetCommentRightTypeAll,
    /**
     *  限好友留言
     */
    PIXAlbumSetCommentRightTypeFriend,
    /**
     *  限會員留言
     */
    PIXAlbumSetCommentRightTypeMember
};
#import <Foundation/Foundation.h>
#import "PIXAPIHandler.h"
#import <CoreLocation/CoreLocation.h>

@interface PIXAlbum : NSObject
#pragma mark Main
/**
 *  列出相簿主圖及相片牆資訊
 *
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumMainWithCompletion:(PIXHandlerCompletion)completion;

#pragma mark SetFolders
/**
 *  列出相本列表 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetfolders
 *
 *  @param userName   相本擁有者,必要參數
 *  @param trimUser   是否每篇文章都要回傳作者資訊, 如果設定為 YES, 則就不回傳. 預設是 NO
 *  @param page       頁數, 預設為1
 *  @param perPage    每頁幾筆, 預設為100
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumListWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion;
/**
 *  修改相簿首頁排序 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetfoldersPosition
 *
 *  @param ids        相簿id, array 裡的值為 NSString, id 的順序即為相簿的新順序
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)sortSetFoldersWithFolderIDs:(NSArray *)ids completion:(PIXHandlerCompletion)completion;

#pragma mark Sets
/**
 *  列出個人所有相本 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSets
 *
 *  @param userName   相本擁有者,必要參數
 *  @param parentID   可以藉此指定拿到特定相簿資料夾底下的相簿
 *  @param trimUser   是否每篇文章都要回傳作者資訊, 如果設定為 1, 則就不回傳. 預設是 NO
 *  @param page       頁數, 預設為1
 *  @param perPage    每頁幾筆, 預設為100
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumSetsWithUserName:(NSString *)userName parentID:(NSString *)parentID trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
/**
 *  讀取個人某一本相本 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetsShow
 *
 *  @param userName   相本擁有者, 必要參數
 *  @param setId      指定要回傳的 set 的 ID, 必要參數
 *  @param page       頁數
 *  @param perPage    每頁幾筆
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumSetWithUserName:(NSString *)userName setID:(NSString *)setId page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
/**
 *  新增相簿 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetsCreate
 *
 *  @param setTitle           相簿標題，必要參數
 *  @param setDescription     相簿描述，必要參數
 *  @param permission         相簿閱讀權限
 *  @param categoryId         相簿分類
 *  @param isLockRight        是否鎖右鍵
 *  @param isAllowCc          是否採用 CC 授權
 *  @param commentrightType   留言權限
 *  @param password           相簿密碼(當 permission==PIXAlbumSetPermissionTypePassword 時為必要參數)
 *  @param passwordHint       相簿密碼提示(當 permission==PIXAlbumSetPermissionTypePassword 時為必要參數)
 *  @param friendGroupIds     好友群組ID，array 裡的值為 NSString instance(當 permission==PIXAlbumSetPermissionTypeGroup 時為必要參數)
 *  @param allowCommercialUse 是否允許商業使用
 *  @param allowDerivation    是否允許創作衍生著作
 *  @param parentId           如果這個 parent_id 被指定, 則此相簿會放置在這個相簿資料夾底下(只能放在資料夾底下)
 *  @param completion         succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)createAlbumSetWithTitle:(NSString *)setTitle description:(NSString *)setDescription permission:(PIXAlbumSetPermissionType)permission categoryID:(NSString *)categoryId isLockRight:(BOOL)isLockRight isAllowCC:(BOOL)isAllowCc commentRightType:(PIXAlbumSetCommentRightType)commentRightType password:(NSString *)password passwordHint:(NSString *)passwordHint friendGroupIDs:(NSArray *)friendGroupIds allowCommercialUse:(BOOL)allowCommercialUse allowDerivation:(BOOL)allowDerivation parentID:(NSString *)parentId completion:(PIXHandlerCompletion)completion;
/**
 *  修改相簿 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetsUpdate
 *
 *  @param setId              欲修改的該相簿 ID
 *  @param setTitle           相簿標題，必要參數
 *  @param setDescription     相簿描述，必要參數
 *  @param permission         相簿閱讀權限
 *  @param categoryId         相簿分類
 *  @param isLockRight        是否鎖右鍵
 *  @param isAllowCc          是否採用 CC 授權
 *  @param commentRightType   留言權限
 *  @param password           相簿密碼(當 permission==PIXAlbumSetPermissionTypePassword 時為必要參數)
 *  @param passwordHint       相簿密碼提示(當 permission==PIXAlbumSetPermissionTypePassword 時為必要參數)
 *  @param friendGroupIds     好友群組ID，array 裡的值為 NSString instance(當 permission==PIXAlbumSetPermissionTypeGroup 時為必要參數)
 *  @param allowCommercialUse 是否允許商業使用
 *  @param allowDerivation    是否允許創作衍生著作
 *  @param parentId           如果這個 parent_id 被指定, 則此相簿會放置在這個相簿資料夾底下(只能放在資料夾底下)
 *  @param completion         succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)updateAlbumSetWithSetID:(NSString *)setId setTitle:(NSString *)setTitle setDescription:(NSString *)setDescription permission:(PIXAlbumSetPermissionType)permission categoryID:(NSString *)categoryId isLockRight:(BOOL)isLockRight isAllowCC:(BOOL)isAllowCc commentRightType:(PIXAlbumSetCommentRightType)commentRightType password:(NSString *)password passwordHint:(NSString *)passwordHint friendGroupIDs:(NSArray *)friendGroupIds allowCommercialUse:(BOOL)allowCommercialUse allowDerivation:(BOOL)allowDerivation parentID:(NSString *)parentId completion:(PIXHandlerCompletion)completion;
/**
 *  刪除單一相簿 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetsDelete
 *
 *  @param setId      欲刪除的相簿的 ID
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)deleteAlbumSetWithSetID:(NSString *)setId completion:(PIXHandlerCompletion)completion;
/**
 *  列出相本裡有些什麼東西 http://developer.pixnet.pro/#!/doc/pixnetApi/albumElements
 *
 *  @param userName    相本擁有者, 必要參數
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
-(void)fetchAlbumSetElementsWithUserName:(NSString *)userName setID:(NSString *)setId elementType:(PIXAlbumElementType)elementType page:(NSUInteger)page perPage:(NSUInteger)perPage password:(NSString *)password withDetail:(BOOL)withDetail trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
/**
 *  列出相本(或照片)的留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetComments
 *
 *  @param userName   相本擁有者, 必要參數
 *  @param elementId  指定要回傳的留言所在的相簿 setID 與 elementID 只要指定其中一個即可, 未用到的參數請給0
 *  @param setId      指定要回傳的留言所在的相簿 setID 與 elementID 只要指定其中一個即可, 未用到的參數請給0
 *  @param password   如果指定使用者的相簿被密碼保護，則需要指定這個參數以通過授權
 *  @param page       頁數
 *  @param perPage    每頁幾筆
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumSetCommentsWithUserName:(NSString *)userName elementID:(NSString *)elementId setID:(NSString *)setId password:(NSString *)password page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
/**
 *  取得相本單一留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetCommentsId
 *
 *  @param userName   相本擁有者, 必要參數
 *  @param commentId  該則留言的 id, 必要參數
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumSetCommentWithUserName:(NSString *)userName commentID:(NSString *)commentId shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;

/**
 *  附近的相本 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetsNearby
 *
 *  @param userName    相本擁有者, 必要參數
 *  @param location    經緯度坐標, 必要參數
 *  @param distanceMin 回傳相簿所在地和指定的經緯度距離之最小值，單位為公尺。預設為 0 公尺，上限為 50000 公尺
 *  @param distanceMax 回傳相簿所在地和指定的經緯度距離之最大值，單位為公尺。預設為 0 公尺，上限為 50000 公尺
 *  @param page        頁數
 *  @param perPage     每頁幾筆
 *  @param trimUser    是否每本相簿都要回傳使用者資訊，若設定為 YES 則不回傳
 *  @param shouldAuth  是否需要認證
 *  @param completion  succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumSetsNearbyWithUserName:(NSString *)userName location:(CLLocationCoordinate2D)location distanceMin:(NSUInteger)distanceMin distanceMax:(NSUInteger)distanceMax page:(NSUInteger)page perPage:(NSUInteger)perPage trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;

#pragma mark Folders(vip 才會有資料夾)
/**
 *  列出某個使用者所有的資料夾 http://developer.pixnet.pro/#!/doc/pixnetApi/albumFolders
 *
 *  @param userName   相本擁有者, 必要參數
 *  @param trimUser   是否每本相簿都要回傳使用者資訊，若設定為 YES 則不回傳
 *  @param page       頁數
 *  @param perPage    每頁幾筆
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumFoldersWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
/**
 *  列出某個使用者單一資料夾裡有些什麼東西 http://developer.pixnet.pro/#!/doc/pixnetApi/albumFoldersShow
 *
 *  @param userName   相本擁有者, 必要參數
 *  @param folderId   指定要回傳的 folder 資訊, 必要參數
 *  @param page       頁數
 *  @param perPage    每頁幾筆
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumFolderWithUserName:(NSString *)userName folderID:(NSString *)folderId page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
/**
 *  修改相簿排序 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetsPosition
 *
 *  @param parentId   屬於哪一個相簿資料夾
 *  @param ids        相簿id, array 裡的值為 NSString, id 的順序即為相簿的新順序
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)sortAlbumSetsWithParentID:(NSString *)parentId IDs:(NSArray *)ids completion:(PIXHandlerCompletion)completion;

/**
 *  列出相本(或照片)的留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumComments
 *
 *  @param userName   相本擁有者, 必要參數
 *  @param elementId  指定要回傳的留言所在的相簿 setID 與 elementID 只要指定其中一個即可, 未用到的參數請給0
 *  @param setId      指定要回傳的留言所在的相簿 setID 與 elementID 只要指定其中一個即可, 未用到的參數請給0
 *  @param password   如果指定使用者的相簿被密碼保護，則需要指定這個參數以通過授權
 *  @param page       頁數
 *  @param perPage    每頁幾筆
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumCommentsWithUserName:(NSString *)userName elementID:(NSString *)elementId setID:(NSString *)setId password:(NSString *)password page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
/**
 *  取得相簿單一留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumCommentsId
 *
 *  @param userName   相本擁有者, 必要參數
 *  @param commentId  該則留言的 id, 必要參數
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(而 errorMessage 就會是 nil)，succeed=NO 時 result 會是 nil，而錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumCommentWithUserName:(NSString *)userName commentId:(NSString *)commentId shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;

/**
 *  附近的相片 http://developer.pixnet.pro/#!/doc/pixnetApi/albumElementsNearby
 *
 *  @param userName    相本擁有者, 必要參數
 *  @param location    經緯度坐標, 必要參數
 *  @param distanceMin 回傳相簿所在地和指定的經緯度距離之最小值，單位為公尺。預設為 0 公尺，上限為 50000 公尺
 *  @param distanceMax 回傳相簿所在地和指定的經緯度距離之最大值，單位為公尺。預設為 0 公尺，上限為 50000 公尺
 *  @param page        頁數
 *  @param perPage     每頁幾筆
 *  @param withDetail  是否傳回詳細資訊，指定為 YES 時將傳回相片／影音完整資訊及所屬相簿資訊。
 *  @param type        指定要回傳的類別。
 *  @param trimUser    是否每個相片／影音都要回傳使用者資訊，若設定為 YES 則不回傳。
 *  @param shouldAuth  是否需要認證
 *  @param completion  succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumElementsNearbyWithUserName:(NSString *)userName location:(CLLocationCoordinate2D)location distanceMin:(NSUInteger)distanceMin distanceMax:(NSUInteger)distanceMax page:(NSUInteger)page perPage:(NSUInteger)perPage withDetail:(BOOL)withDetail type:(PIXAlbumElementType)type trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
/**
 *  取得單一照片 http://developer.pixnet.pro/#!/doc/pixnetApi/albumElementsId
 *
 *  @param userName   相本擁有者，必要參數
 *  @param elementId  照片 ID，必要參數
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)fetchAlbumElementWithUserName:(NSString *)userName elementID:(NSString *)elementId completion:(PIXHandlerCompletion)completion;
#pragma mark Element
@end
