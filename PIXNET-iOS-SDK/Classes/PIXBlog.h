//
//  PIXBlog.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//
//  這個 class 用來處理輸出入參數的規格正確性
//  除了 ＊ 是 required 外，其餘參數為 optional

#import <Foundation/Foundation.h>
#import "PIXAPIHandler.h"
/**
 *  這個 class 主要用來處理 Blog API Method ， 並檢查輸入參數正規性
 *  除了 ＊ 是 require 參數外，其餘參數為 optional
 */
@interface PIXBlog : NSObject
/**
 *  PIXNET Blog 分類設定
 */
typedef NS_ENUM(NSInteger, PIXBlogCategoryType) {
    /**
     *  設定為 分類
     */
    PIXBlogCategoryTypeCategory = 0,
    /**
     *  設定為 資料夾
     */
    PIXBlogCategoryTypeFolder = 1
};
/**
 *  PIXNET Blog 文章狀態
 */
typedef NS_ENUM(NSInteger, PIXArticleStatus){
    /**
     *  刪除
     */
    PIXArticleStatusDelete = 0,
    /**
     *  草稿
     */
    PIXArticleStatusDraft = 1,
    /**
     *  公開
     */
    PIXArticleStatusPublic = 2,
    /**
     *  密碼
     */
    PIXArticleStatusPassword = 3,
    /**
     *  隱藏
     */
    PIXArticleStatusPrivate = 4,
    /**
     *  好友
     */
    PIXArticleStatusFriend = 5,
    /**
     *  共同作者
     */
    PIXArticleStatusCoAuthor = 7
};
/**
 *  PIXNET Blog 文章留言權限
 */
typedef NS_ENUM(NSInteger, PIXArticleCommentPerm){
    /**
     *  關閉留言
     */
    PIXArticleCommentPermClose = 0,
    /**
     *  開放所有人留言
     */
    PIXArticleCommentPermPublic = 1,
    /**
     *  僅開放會員留言
     */
    PIXArticleCommentPermMember = 2,
    /**
     *  開放好友留言
     */
    PIXArticleCommentPermFriend = 3
};

#pragma mark - Blog imformation
/**
 *  列出部落格資訊 http://emma.pixnet.cc/blog
 *
 *  @param userName   ＊指定要回傳的使用者資訊
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)getBlogInformationWithUserName:(NSString *)userName
                          completion:(PIXHandlerCompletion)completion;

#pragma mark - Blog Categories
//dosen't need Access token
/**
 *  讀取使用者部落格分類資訊 http://emma.pixnet.cc/blog/categories
 *
 *  @param userName   ＊指定要回傳的使用者資訊
 *  @param passwd     如果指定使用者的 Blog 被密碼保護，則需要指定這個參數以通過授權，沒有則輸入 nil
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)getBlogCategoriesWithUserName:(NSString *)userName
                             password:(NSString *)passwd
                           completion:(PIXHandlerCompletion)completion;

#pragma mark Categories method need access token
/**
 *  新增部落格個人分類（需認證） http://emma.pixnet.cc/blog/categories
 *
 *  @param name        ＊分類名稱
 *  @param type        ＊請輸入分類 PIXBlogCategoryType 型別, 輸入 nil 即預設為 Category
 *  @param description 分類說明
 *  @param cateID      ＊對應的全站文章類別 id. 當 type 為 category 為必須參數
 *  @param completion  succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)createBlogCategoriesWithName:(NSString *)name
                                type:(PIXBlogCategoryType)type
                         description:(NSString *)description
                        siteCategory:(NSString *)siteCateID
                          completion:(PIXHandlerCompletion)completion;
/**
 *  修改部落格個人分類 (需認證) http://developer.pixnet.pro/#!/doc/pixnetApi/blogCategoriesUpdate
 *
 *  @param categoryID ＊要修改的 Category / Folder ID
 *  @param newName      ＊修改後的顯示名稱
 *  @param type         請輸入修改類型 PIXBlogCategoryType 型別, 輸入 nil 即預設為 Category
 *  @param description  修改後的分類說明
 *  @param completion   succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)updateBlogCategoryFromID:(NSString *)categoryID
                           newName:(NSString *)newName
                              type:(PIXBlogCategoryType)type
                       description:(NSString *)description
                        completion:(PIXHandlerCompletion)completion;
/**
 *  刪除部落格個人分類（需認證） http://emma.pixnet.cc/blog/categories/:id
 *
 *
 *  @param categoriesID ＊要刪除的 Category / Folder ID
 *  @param type         請輸入要刪除類型 PIXBlogCategoryType 型別, 輸入 nil 即預設為 Category
 *  @param completion   succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)deleteBlogCategoriesByID:(NSString *)categoriesID
                            type:(PIXBlogCategoryType)type
                      completion:(PIXHandlerCompletion)completion;

/**
 *  修改部落格分類排序（需認證） http://developer.pixnet.pro/#!/doc/pixnetApi/blogCategoriesPosition
 *
 *  @param categoriesIDArray ＊輸入以部落格分類ID組成已排序好的 Array(value 必為 NSString)，分類將會以陣列順序重新排序。放在越前面的表示圖片的順序越優先。不過在排序上分類資料夾的排序要優先於分類，所以對分類資料夾的排序指定只會影響資料夾群本身
 *  @param completion        succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)sortBlogCategoriesTo:(NSArray *)categoriesIDArray
                  completion:(PIXHandlerCompletion)completion;

#pragma mark - Blog Articles
//dosen't need Access token
/**
 *  列出部落格個人文章 http://emma.pixnet.cc/blog/articles
 *
 *  @param userName       ＊指定要回傳的使用者資訊
 *  @param passwd         如果指定使用者的 Blog 被密碼保護，則需要指定這個參數以通過授權，沒有則輸入 nil
 *  @param page           頁數, 預設為 1, 不需要則輸入 nil
 *  @param articlePerPage 每頁幾筆, 預設為 100, 不需要則輸入 nil
 *  @param completion     succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)getBlogAllArticlesWithUserName:(NSString *)userName
                              password:(NSString *)passwd
                                  page:(NSUInteger)page
                               perpage:(NSUInteger)articlePerPage
                            completion:(PIXHandlerCompletion)completion;

/**
 *  讀取部落格個人文章 http://emma.pixnet.cc/blog/articles/:id
 *
 *  @param userName      ＊指定要回傳的使用者資訊
 *  @param articleID     ＊指定要回傳的文章ID
 *  @param blogPasswd    如果指定使用者的 Blog 被密碼保護，則需要指定這個參數以通過授權，沒有則輸入 nil
 *  @param articlePasswd 如果指定使用者的文章被密碼保護，則需要指定這個參數以通過授權，沒有則輸入 nil
 *  @param completion    succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中 
 */
- (void)getBlogSingleArticleWithUserName:(NSString *)userName
                               articleID:(NSString *)articleID
                            blogPassword:(NSString *)blogPasswd
                         articlePassword:(NSString *)articlePasswd
                              completion:(PIXHandlerCompletion)completion;

/**
 *  讀取指定 ID 文章的相關文章 http://emma.pixnet.cc/blog/articles/:id/related
 *
 *  @param articleID  ＊指定要回傳的文章ID
 *  @param userName   ＊指定要回傳的使用者
 *  @param limit      限制回傳文章的筆數，預設值為1，最大值為10, 不設定則輸入 nil
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)getBlogRelatedArticleByArticleID:(NSString *)articleID
                                userName:(NSString *)userName
                            relatedLimit:(NSUInteger)limit
                              completion:(PIXHandlerCompletion)completion;

/**
 *  列出部落格留言 http://emma.pixnet.cc/blog/comments
 *
 *  @param userName        ＊指定要回傳的使用者資訊
 *  @param articleID       ＊指定要回傳的留言文章
 *  @param blogPasswd      如果指定使用者的 Blog 被密碼保護，則需要指定這個參數以通過授權，沒有則輸入 nil
 *  @param articlePassword 如果指定使用者的文章被密碼保護，則需要指定這個參數以通過授權，沒有則輸入 nil
 *  @param page            頁數, 預設為 1, 不需要則輸入 nil
 *  @param commentPerPage  每頁幾筆, 預設為 100, 不需要則輸入 nil
 *  @param completion      succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)getBlogArticleCommentsWithUserName:(NSString *)userName
                               articleID:(NSString *)articleID
                            blogPassword:(NSString *)blogPasswd
                         articlePassword:(NSString *)articlePassword
                                    page:(NSUInteger)page
                         commentsPerPage:(NSUInteger)commentPerPage
                              completion:(PIXHandlerCompletion)completion;
/**
 *  列出部落格最新文章 http://emma.pixnet.cc/blog/articles/latest
 *
 *  @param userName   ＊指定要回傳的使用者資訊
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)getBlogLatestArticleWithUserName:(NSString *)userName
                            completion:(PIXHandlerCompletion)completion;

/**
 *  列出部落格熱門文章 http://emma.pixnet.cc/blog/articles/hot
 *
 *  @param userName   ＊指定要回傳的使用者資訊
 *  @param passwd     如果指定使用者的 Blog 被密碼保護，則需要指定這個參數以通過授權，沒有則輸入 nil
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)getBlogHotArticleWithUserName:(NSString *)userName
                             password:(NSString *)passwd
                         completion:(PIXHandlerCompletion)completion;

/**
 *  搜尋部落格個人文章 http://emma.pixnet.cc/blog/articles/search
 *
 *  @param keyword    ＊關鍵字或標籤
 *  @param userName   指定要回傳的使用者資訊，如輸入 nil 則搜尋全站
 *  @param page       頁數, 預設為 1, 不需要則輸入 nil
 *  @param perPage    每頁幾筆, 預設為 100, 不需要則輸入 nil
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)getblogSearchArticleWithKeyword:(NSString *)keyword
                               userName:(NSString *)userName
                                   page:(NSUInteger)page
                                perPage:(NSUInteger)perPage
                             completion:(PIXHandlerCompletion)completion;

#pragma mark Article method need access token

/**
 *  新增部落格個人文章（需認證）  http://emma.pixnet.cc/blog/articles
 *
 *  @param title         ＊文章標題
 *  @param body          ＊文章內容
 *  @param status        文章狀態，使用 PIXArticleStatus 型別
 *  @param date          公開時間，這個表示文章的發表時間，預設為現在時間
 *  @param cateID        全站分類的該類別 id
 *  @param commentPerm   可留言權限，使用 PIXArticleCommentPerm 型別
 *  @param commentHidden 預設留言狀態， Yes 為強制隱藏 NO 為顯示(公開)，預設為 NO 公開(顯示)
 *  @param tagArray      文章標籤
 *  @param thumburl      文章縮圖網址, 會影響 oEmbed 與 SNS (Twitter, Facebook, Plurk …) 抓到的縮圖
 *  @param passwd        當 status 被設定為 PIXArticleStatusPassword 時需要輸入這個參數以設定為此文章的密碼
 *  @param passwdHint    當 status 被設定為 PIXArticleStatusPassword 時需要輸入這個參數以設定為此文章的密碼提示
 *  @param friendGroupID 當 status 被設定為 PIXArticleStatusFriend 時可以輸入這個參數以設定此文章可閱讀的好友群組, 預設不輸入代表所有好友
 *  @param completion    succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)createBlogArticleWithTitle:(NSString *)title
                              body:(NSString *)body
                            status:(PIXArticleStatus)status
                    siteCategoryID:(NSString *)cateID
                       commentPerm:(PIXArticleCommentPerm)commentPerm
                     commentHidden:(BOOL)commentHidden
                              tags:(NSArray *)tagArray
                          thumbURL:(NSString *)thumburl
                          password:(NSString *)passwd
                      passwordHine:(NSString *)passwdHint
                     friendGroupID:(NSString *)friendGroupID
                        completion:(PIXHandlerCompletion)completion;
/**
 *  修改部落格個人文章（需認證） http://emma.pixnet.cc/blog/articles/:id
 *
 *  @param articleID     ＊要修改的文章 ID
 *  @param title         ＊修改後的文章標題
 *  @param body          ＊修改後的文章內容
 *  @param status        文章狀態，使用 PIXArticleStatus 型別
 *  @param date          公開時間，這個表示文章的發表時間，預設為現在時間
 *  @param cateID        全站分類的類別id
 *  @param commentPerm   可留言權限，使用 PIXArticleCommentPerm 型別
 *  @param commentHidden 預設留言狀態， Yes 為強制隱藏 NO 為顯示(公開)，預設為 NO 公開(顯示)
 *  @param tagArray      文章標籤
 *  @param thumburl      文章縮圖網址, 會影響 oEmbed 與 SNS (Twitter, Facebook, Plurk …) 抓到的縮圖
 *  @param passwd        當 status 被設定為 PIXArticleStatusPassword 時需要輸入這個參數以設定為此文章的密碼
 *  @param passwdHint    當 status 被設定為 PIXArticleStatusPassword 時需要輸入這個參數以設定為此文章的密碼提示
 *  @param friendGroupID 當 status 被設定為 PIXArticleStatusFriend 時可以輸入這個參數以設定此文章可閱讀的好友群組, 預設不輸入代表所有好友
 *  @param completion    succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)updateBlogArticleWithArticleID:(NSString *)articleID
                                 title:(NSString *)title
                                  body:(NSString *)body
                                status:(PIXArticleStatus)status
                        siteCategoryID:(NSString *)cateID
                           commentPerm:(PIXArticleCommentPerm)commentPerm
                         commentHidden:(BOOL)commentHidden
                                  tags:(NSArray *)tagArray
                              thumbURL:(NSString *)thumburl
                              password:(NSString *)passwd
                          passwordHine:(NSString *)passwdHint
                         friendGroupID:(NSString *)friendGroupID
                            completion:(PIXHandlerCompletion)completion;

/**
 *  刪除部落格個人文章（需認證） http://emma.pixnet.cc/blog/articles/:id
 *
 *  @param articleID  ＊要刪除的文章 ID
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)deleteBlogArticleByArticleID:(NSString *)articleID
                          completion:(PIXHandlerCompletion)completion;


#pragma mark - Blog Comments

/**
 *  列出部落格留言 http://emma.pixnet.cc/blog/comments
 *
 *  @param userName   ＊指定要回傳的使用者資訊
 *  @param articleID  ＊指定要回傳的留言文章
 *  @param page       頁數, 預設為 1, 不需要則輸入 nil
 *  @param perPage    每頁幾筆, 預設為 100, 不需要則輸入 nil
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)getBlogCommentsWithUserName:(NSString *)userName
                          articleID:(NSString *)articleID
                               page:(NSUInteger)page
                            perPage:(NSUInteger)perPage
                         completion:(PIXHandlerCompletion)completion;

/**
 *  讀取單一留言 http://emma.pixnet.cc/blog/comments/:id
 *
 *  @param userName   ＊指定要回傳的使用者資訊
 *  @param commentID  ＊指定要回傳的留言ID
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)getBlogSingleCommentWithUserName:(NSString *)userName
                              commmentID:(NSString *)commentID
                              completion:(PIXHandlerCompletion)completion;


/**
 *  列出部落格最新留言 http://emma.pixnet.cc/blog/comments/latest
 *
 *  @param userName   ＊指定要回傳的使用者資訊
 *  @param completion succeed = YES 時 result 可以用 (errorMessage == nil)，succeed = NO 時 result 會是 nil，錯誤原因會在 errorMessage 裡
 */
- (void)getBlogLatestCommentWithUserName:(NSString *)userName
                              completion:(PIXHandlerCompletion)completion;


#pragma mark Comment method need access token
/**
 *  新增部落格留言（需認證） http://emma.pixnet.cc/blog/comments
 *
 *  @param articleID     ＊要留言的文章 ID
 *  @param body          ＊留言內容
 *  @param userName      要留言的部落格作者名稱, 若不填入則預設找自己的文章
 *  @param author        留言的暱稱, 不填入則預設代入認證使用者的 display_name
 *  @param title         留言標題
 *  @param url           個人網頁
 *  @param isOpen        公開留言/悄悄話
 *  @param email         電子郵件
 *  @param blogPasswd    如果指定使用者的 Blog 被密碼保護，則需要指定這個參數以通過授權
 *  @param articlePasswd 如果指定使用者的文章被密碼保護，則需要指定這個參數以通過授權
 *  @param completion    succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)createBlogCommentWithArticleID:(NSString *)articleID
                                  body:(NSString *)body
                              userName:(NSString *)userName
                                author:(NSString *)author
                                 title:(NSString *)title
                                   url:(NSString *)url
                                isOpen:(BOOL)isOpen
                                 email:(NSString *)email
                          blogPassword:(NSString *)blogPasswd
                       articlePassword:(NSString *)articlePasswd
                            completion:(PIXHandlerCompletion)completion;
/**
 *  回覆部落格留言，可以重覆使用這個功能來修改回覆內容（需認證） http://emma.pixnet.cc/blog/comments/:id/reply
 *
 *  @param commentID  ＊要回覆/修改的留言 ID
 *  @param body       ＊留言內容/修改後的內容
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)replyBlogCommentWithCommnetID:(NSString *)commentID
                                 body:(NSString *)body
                           completion:(PIXHandlerCompletion)completion;

/**
 *  將留言設為公開/關閉（需認證） http://emma.pixnet.cc/blog/comments/:id/open http://emma.pixnet.cc/blog/comments/:id/close
 *
 *  @param commentID  ＊要公開/關閉的留言 ID
 *  @param isOpen     ＊YES 為 公開， NO 為 關閉 該則留言
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)updateBlogCommentOpenWithCommentID:(NSString *)commentID
                                    isOpen:(BOOL)isOpen
                                completion:(PIXHandlerCompletion)completion;

/**
 *  將留言設為廣告留言/非廣告留言（需認證） http://emma.pixnet.cc/blog/comments/:id/mark_spam http://emma.pixnet.cc/blog/comments/:id/mark_ham
 *
 *  @param commentID  ＊要公開/關閉的留言 ID
 *  @param isSpam     ＊YES 為設成廣告留言， NO 為設成非廣告留言
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)updateBlogCommentSpamWithCommentID:(NSString *)commentID
                                    isSpam:(BOOL)isSpam
                                completion:(PIXHandlerCompletion)completion;

/**
 *  刪除部落格留言（需認證） http://emma.pixnet.cc/blog/comments/:id
 *
 *  @param commentID  ＊要刪除的留言 ID
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)deleteBlogCommentWithCommentID:(NSString *)commentID
                            completion:(PIXHandlerCompletion)completion;


#pragma mark - Site Blog Categories list

/**
 *  列出部落格全站分類 http://developer.pixnet.pro/#!/doc/pixnetApi/blogSiteCategories
 *
 *  @param group      當被設為 YES 或 true 時, 回傳資訊會以全站分類群組為分類，不需要則輸入 NO 或 false
 *  @param thumb      當被設為 YES 或 true 時, 回傳分類資訊會包含縮圖網址，不需要則輸入 NO 或 false
 *  @param completion succeed = YES 時 result 可以用，succeed = NO 時 result 會是 nil，錯誤原因會在 NSError 物件中
 */
- (void)getBlogCategoriesListIncludeGroups:(BOOL)group
                                    thumbs:(BOOL)thumb
                                completion:(PIXHandlerCompletion)completion;


@end
