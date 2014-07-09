//
//  PIXAlbum.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/20/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
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
/**
 *  影片檔縮圖類型
 */
typedef NS_ENUM(NSInteger, PIXVideoThumbType) {
    /**
     *  影片開頭
     */
    PIXVideoThumbTypeBeginning,
    /**
     *  影片中段
     */
    PIXVideoThumbTypeMiddle,
    /**
     *  影片結尾
     */
    PIXVideoThumbTypeEnd,
    /**
     *  不做任何設定
     */
    PIXVideoThumbTypeNone
};
#import <Foundation/Foundation.h>
#import "PIXAPIHandler.h"
#import <CoreLocation/CoreLocation.h>

@interface PIXAlbum : NSObject
#pragma mark site categories
/**
 *  列出相簿全站分類 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSiteCategories
 *
 *  @param isIncludeGroups 當被設為 YES 時, 回傳資訊會以全站分類群組為分類
 *  @param isIncludeThumbs 當被設為 YES 時, 回傳分類資訊會包含縮圖
 *  @param completion      succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)getAlbumSiteCategoriesWithIsIncludeGroups:(BOOL)isIncludeGroups isIncludeThumbs:(BOOL)isIncludeThumbs completion:(PIXHandlerCompletion)completion;
#pragma mark Main
/**
 *  列出相簿主圖及相片牆資訊 http://developer.pixnet.pro/#!/doc/pixnetApi/albumMain
 *
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)getAlbumMainWithCompletion:(PIXHandlerCompletion)completion;

#pragma mark config
/**
 *  列出相簿個人設定 http://developer.pixnet.pro/#!/doc/pixnetApi/albumConfig
 *
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)getAlbumConfigWithCompletion:(PIXHandlerCompletion)completion;

#pragma mark SetFolders
/**
 *  列出相本及資料夾列表 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetfolders
 *
 *  @param userName   相本擁有者,必要參數
 *  @param trimUser   是否每篇文章都要回傳作者資訊, 如果設定為 YES, 則就不回傳. 預設是 NO
 *  @param page       頁數, 預設為1
 *  @param perPage    每頁幾筆, 預設為100
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)getAlbumSetsWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion;
/**
 *  修改相簿首頁排序 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetfoldersPosition
 *
 *  @param ids        相簿id, array 裡的值為 NSString, id 的順序即為相簿的新順序
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)sortSetFoldersWithFolderIDs:(NSArray *)ids completion:(PIXHandlerCompletion)completion;

#pragma mark Sets
/**
 *  列出個人所有相本(不含資料夾) http://developer.pixnet.pro/#!/doc/pixnetApi/albumSets
 *
 *  @param userName   相本擁有者,必要參數
 *  @param parentID   可以藉此指定拿到特定相簿資料夾底下的相簿
 *  @param trimUser   是否每篇文章都要回傳作者資訊, 如果設定為 1, 則就不回傳. 預設是 NO
 *  @param page       頁數, 預設為1
 *  @param perPage    每頁幾筆, 預設為100
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)getAlbumSetsWithUserName:(NSString *)userName
                       parentID:(NSString *)parentID
                       trimUser:(BOOL)trimUser
                           page:(NSUInteger)page
                        perPage:(NSUInteger)perPage
                     shouldAuth:(BOOL)shouldAuth
                     completion:(PIXHandlerCompletion)completion;
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
-(void)getAlbumSetWithUserName:(NSString *)userName setID:(NSString *)setId page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
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
-(void)getAlbumSetElementsWithUserName:(NSString *)userName setID:(NSString *)setId elementType:(PIXAlbumElementType)elementType page:(NSUInteger)page perPage:(NSUInteger)perPage password:(NSString *)password withDetail:(BOOL)withDetail trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
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
-(void)getAlbumSetCommentsWithUserName:(NSString *)userName setID:(NSString *)setId password:(NSString *)password page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
/**
 *  新增一則相簿上的留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetCommentsCreate
 *
 *  @param setId      相簿 ID
 *  @param body       留言內容
 *  @param password   如果被留言的相本被密碼保護，則需要指定這個參數以通過授權
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)createAlbumSetCommentWithSetID:(NSString *)setId body:(NSString *)body password:(NSString *)password completion:(PIXHandlerCompletion)completion;
/**
 *  新增一則相片上的留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumCommentsCreate
 *
 *  @param elementID  相片 ID
 *  @param body       留言內容
 *  @param password   如果被留言的相本被密碼保護，則需要指定這個參數以通過授權
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)createElementCommentWithElementID:(NSString *)elementID body:(NSString *)body password:(NSString *)password completion:(PIXHandlerCompletion)completion;
/**
 *  將相簿上某則留言註記為廣告 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetCommentsMarkSpam
 *
 *  @param commentId  該則留言的 id
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)markAlbumSetCommentAsSpamWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion;
/**
 *  將相簿上某則留言註記為非廣告 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetCommentsMarkHam
 *
 *  @param commentId  該則留言的 id
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)markAlbumSetCommentAsHamWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion;
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
-(void)getAlbumSetsNearbyWithUserName:(NSString *)userName location:(CLLocationCoordinate2D)location distanceMin:(NSUInteger)distanceMin distanceMax:(NSUInteger)distanceMax page:(NSUInteger)page perPage:(NSUInteger)perPage trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;

#pragma mark Folders(PIXNET VIP 才會有 folder)
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
-(void)getAlbumFoldersWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
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
-(void)getAlbumFolderWithUserName:(NSString *)userName folderID:(NSString *)folderId page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
/**
 *  修改資料夾裡的相簿排序 http://developer.pixnet.pro/#!/doc/pixnetApi/albumSetsPosition
 *
 *  @param parentId   屬於哪一個相簿資料夾,必要欄位
 *  @param ids        相簿id, array 裡的值為 NSString, id 的順序即為相簿的新順序
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)sortAlbumSetsWithParentID:(NSString *)parentId IDs:(NSArray *)ids completion:(PIXHandlerCompletion)completion;
/**
 *  新增資料夾 http://developer.pixnet.pro/#!/doc/pixnetApi/albumFoldersCreate
 *
 *  @param folderTitle       資料夾標題
 *  @param folderDescription 資料夾描述
 *  @param completion        succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)createAlbumFolderWithTitle:(NSString *)folderTitle description:(NSString *)folderDescription completion:(PIXHandlerCompletion)completion;
/**
 *  修改資料夾 http://developer.pixnet.pro/#!/doc/pixnetApi/albumFoldersUpdate
 *
 *  @param folderId          資料夾 ID
 *  @param folderTitle       資料夾標題
 *  @param folderDescription 資料夾描述
 *  @param completion        succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)updateAlbumFolderWithFolderID:(NSString *)folderId title:(NSString *)folderTitle description:(NSString *)folderDescription completion:(PIXHandlerCompletion)completion;
/**
 *  刪除資料夾 http://developer.pixnet.pro/#!/doc/pixnetApi/albumFoldersDelete
 *
 *  @param folderId  資料夾 ID
 *  @param comletion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)deleteAlbumFolderWithFolderID:(NSString *)folderId completion:(PIXHandlerCompletion)completion;
/**
 *  列出相本(或照片)的留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumComments
 *
 *  @param userName   相本擁有者, 必要參數
 *  @param elementId  指定要回傳的留言所在的相簿 setID 與 elementID 只要指定其中一個即可, 未用到的參數請給 nil
 *  @param setId      指定要回傳的留言所在的相簿 setID 與 elementID 只要指定其中一個即可, 未用到的參數請給 nil
 *  @param password   如果指定使用者的相簿被密碼保護，則需要指定這個參數以通過授權
 *  @param page       頁數
 *  @param perPage    每頁幾筆
 *  @param shouldAuth 是否需要認證
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
//-(void)getAlbumCommentsWithUserName:(NSString *)userName elementID:(NSString *)elementId setID:(NSString *)setId password:(NSString *)password page:(NSUInteger)page perPage:(NSUInteger)perPage shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;

#pragma mark Element
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
-(void)getElementsNearbyWithUserName:(NSString *)userName location:(CLLocationCoordinate2D)location distanceMin:(NSUInteger)distanceMin distanceMax:(NSUInteger)distanceMax page:(NSUInteger)page perPage:(NSUInteger)perPage withDetail:(BOOL)withDetail type:(PIXAlbumElementType)type trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth completion:(PIXHandlerCompletion)completion;
/**
 *  取得單一照片 http://developer.pixnet.pro/#!/doc/pixnetApi/albumElementsId
 *
 *  @param userName    相本擁有者，必要參數
 *  @param elementId   照片 ID，必要參數
 *  @param withSetInfo 是否要回傳這張照片所屬的相簿資訊
 *  @param completion  succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)getElementWithUserName:(NSString *)userName
                    elementID:(NSString *)elementId
                  withSetInfo:(BOOL)withSetInfo
                   completion:(PIXHandlerCompletion)completion;

/**
 *  修改圖片(或影片)裡的參數 http://developer.pixnet.pro/#!/doc/pixnetApi/albumElementsUpdate
 *
 *  @param elementId          圖片(或影片)的 ID，必要參數
 *  @param elementTitle       圖片(或影片)標題
 *  @param elementDescription 圖片(或影片)描述
 *  @param setId              圖片(或影片)所屬的相簿 ID
 *  @param videoThumbType     影片截圖類型，如不設定請給 PIXVideoThumbTypeNone
 *  @param tags               由 NSString instance 組成的 array
 *  @param location           照片(或影片)的經緯度，如不需要此參數，可使用 kCLLocationCoordinate2DInvalid
 *  @param completion         succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)updateElementWithElementID:(NSString *)elementId elementTitle:(NSString *)elementTitle elementDescription:(NSString *)elementDescription setID:(NSString *)setId videoThumbType:(PIXVideoThumbType)videoThumbType tags:(NSArray *)tags location:(CLLocationCoordinate2D)location completion:(PIXHandlerCompletion)completion;
/**
 *  刪除單張圖片(或影片) http://developer.pixnet.pro/#!/doc/pixnetApi/albumElementsDelete
 *
 *  @param elementId  圖片(或影片)的 ID, 必要參數
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)deleteElementWithElementID:(NSString *)elementId completion:(PIXHandlerCompletion)completion;
/**
 *  修改相簿裡圖片影片排序 http://developer.pixnet.pro/#!/doc/pixnetApi/albumElementsPosition
 *
 *  @param setId      相簿 ID，必要參數
 *  @param ids        圖片 ID, array 裡的值為 NSString, id 的順序即為圖片的新順序，必要參數
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)sortElementsWithSetID:(NSString *)setId elementIDs:(NSArray *)ids completion:(PIXHandlerCompletion)completion;
/**
 *  取得相片裡的留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumComments
 *
 *  @param userName   相片擁有者名稱，必要參數
 *  @param elementId  相片 ID，必要參數
 *  @param password   相片所屬相簿如果有密碼保護，就代入這個參數
 *  @param page       頁數
 *  @param perPage    一頁幾筆
 *  @param completion succeed=YES 時 result 可以用(而 errorMessage 就會是 nil)，succeed=NO 時 result 會是 nil，而錯誤原因會在 errorMessage 裡
 */
-(void)getElementCommentsWithUserName:(NSString *)userName elementID:(NSString *)elementId password:(NSString *)password page:(NSUInteger)page perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion;
#pragma mark 留言
/**
 *  取得單一則留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumCommentsId
 *
 *  @param userName   相片或相簿的擁有者名稱，必要參數
 *  @param commentId  該則留言ID，必要參數
 *  @param completion succeed=YES 時 result 可以用(而 errorMessage 就會是 nil)，succeed=NO 時 result 會是 nil，而錯誤原因會在 errorMessage 裡
 */
-(void)getCommentWithUserName:(NSString *)userName commentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion;
/**
 *  將某則相片裡的留言標記為廣告留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumCommentsMarkSpam
 *
 *  @param commentId  留言ID, 必要參數
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)markCommentAsSpamWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion;
/**
 *  將某則相片裡留言標記為非廣告留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumCommentsMarkHam
 *
 *  @param commentId  留言ID, 必要參數
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)markCommentAsHamWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion;
/**
 *  刪除某則留言 http://developer.pixnet.pro/#!/doc/pixnetApi/albumCommentsDelete
 *
 *  @param commentId  留言ID, 必要參數
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)deleteCommentWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion;
/**
 *  新增相簿圖片影片 http://developer.pixnet.pro/#!/doc/pixnetApi/albumElementsCreate
 *
 *  @param elementData             必要參數，圖片的 NSData instance。
 *  @param setId                   必要參數，上傳進哪本相簿的相簿 ID
 *  @param elementTitle            照片(或影片)標題
 *  @param elementDescription      照片(或影片)描述
 *  @param tags                    由 NSString instance 組成的 array
 *  @param location                照片(或影片)的經緯度，如不需要此參數，可使用 kCLLocationCoordinate2DInvalid
 *  @param videoThumbType          如果上傳的檔案是影音檔, 可以選擇影片縮圖方式
 *  @param picShouldRotateByExif   照片是否按照 exif 旋轉
 *  @param videoShouldRotateByMeta 影片是否按照 header 旋轉
 *  @param shouldUseQuadrate       是否使用方形縮圖
 *  @param shouldAddWatermark      是否加浮水印
 *  @param uploadInBackground      當 app 被送入背景時是否繼續上傳單一檔案？背景上傳只能在 iOS 7.0 以後版本執行。
 *  @param isElementFirst          新上傳照片(或影片)的放相簿前面
 */
-(void)createElementWithElementData:(NSData *)elementData setID:(NSString *)setId elementTitle:(NSString *)elementTitle elementDescription:(NSString *)elementDescription tags:(NSArray *)tags location:(CLLocationCoordinate2D)location videoThumbType:(PIXVideoThumbType)videoThumbType picShouldRotateByExif:(BOOL)picShouldRotateByExif videoShouldRotateByMeta:(BOOL)videoShouldRotateByMeta shouldUseQuadrate:(BOOL)shouldUseQuadrate shouldAddWatermark:(BOOL)shouldAddWatermark isElementFirst:(BOOL)isElementFirst wouldUploadInBackground:(BOOL)uploadInBackground completion:(PIXHandlerCompletion)completion;
/**
 *  新增相簿圖片影片 http://developer.pixnet.pro/#!/doc/pixnetApi/albumElementsCreate
 *
 *  @param elementData             必要參數，圖片的 NSData instance。
 *  @param setId                   必要參數，上傳進哪本相簿的相簿 ID
 *  @param elementTitle            照片(或影片)標題
 *  @param elementDescription      照片(或影片)描述
 *  @param tags                    由 NSString instance 組成的 array
 *  @param location                照片(或影片)的經緯度，如不需要此參數，可使用 kCLLocationCoordinate2DInvalid
 *  @param videoThumbType          如果上傳的檔案是影音檔, 可以選擇影片縮圖方式
 *  @param picShouldRotateByExif   照片是否按照 exif 旋轉
 *  @param videoShouldRotateByMeta 影片是否按照 header 旋轉
 *  @param shouldUseQuadrate       是否使用方形縮圖
 *  @param shouldAddWatermark      是否加浮水印
 *  @param isElementFirst          新上傳照片(或影片)的放相簿前面
 */
-(void)createElementWithElementData:(NSData *)elementData setID:(NSString *)setId elementTitle:(NSString *)elementTitle elementDescription:(NSString *)elementDescription tags:(NSArray *)tags location:(CLLocationCoordinate2D)location videoThumbType:(PIXVideoThumbType)videoThumbType picShouldRotateByExif:(BOOL)picShouldRotateByExif videoShouldRotateByMeta:(BOOL)videoShouldRotateByMeta shouldUseQuadrate:(BOOL)shouldUseQuadrate shouldAddWatermark:(BOOL)shouldAddWatermark isElementFirst:(BOOL)isElementFirst completion:(PIXHandlerCompletion)completion __attribute__((deprecated));
#pragma mark faces
/**
 *  新增人臉標記
 *
 *  @param elementId   要加人臉標記的相片 ID，必要欄位
 *  @param beTagedUser 要被標記的使用者帳號，被標記者必須設定標記者為好友。必要欄位
 *  @param tagFrame    被標記的影像範圍，當沒有使用 recommendId 時，這是必要欄位
 *  @param recommendId 如果在 -getCommentWithUserName:commentID:completion: 有系統推薦標記的使用者，可在這裡使用
 *  @param completion  succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)tagFriendWithElementID:(NSString *)elementId beTaggedUser:(NSString *)beTaggedUser tagFrame:(CGRect)tagFrame recommendID:(NSString *)recommendId completion:(PIXHandlerCompletion)completion;
/**
 *  更新人臉標記 http://developer.pixnet.pro/#!/doc/pixnetApi/albumFacesFaceid
 *
 *  @param faceId      要被改變的人臉 id，必要欄位
 *  @param elementId   相片或影像的 id，必要欄位
 *  @param beTaggedUser    要更新標記的使用者帳號。被標記者必須設定標記者為好友。必要欄位。
 *  @param newTagFrame 被標記的影像範圍，必要欄位
 *  @param completion  succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)updateTagedFaceWithFaceId:(NSString *)faceId elementId:(NSString *)elementId beTaggedUser:(NSString *)beTaggedUser newTagFrame:(CGRect)newTagFrame completion:(PIXHandlerCompletion)completion;
/**
 *  刪除人臉標記 http://developer.pixnet.pro/#!/doc/pixnetApi/albumFacesDelete
 *
 *  @param faceId     要被刪除的人臉 id，必要欄位
 *  @param completion succeed=YES 時 result 可以用(errorMessage為 nil)，succeed=NO 時 result會是 nil，錯誤原因會在 errorMessage 裡
 */
-(void)deleteTagWithFaceId:(NSString *)faceId completion:(PIXHandlerCompletion)completion;
@end
