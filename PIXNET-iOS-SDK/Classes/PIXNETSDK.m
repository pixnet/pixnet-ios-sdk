//
//  PIXNETSDK.m
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/3/13.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//

#import "PIXNETSDK.h"

@implementation PIXNETSDK
+(void)setConsumerKey:(NSString *)aKey consumerSecret:(NSString *)aSecret{
    [PIXAPIHandler setConsumerKey:aKey consumerSecret:aSecret];
}
+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password requestCompletion:(PIXHandlerCompletion)completion{
    [PIXAPIHandler authByXauthWithUserName:userName userPassword:password requestCompletion:completion];
}
+(BOOL)isAuthed{
    return [PIXAPIHandler isAuthed];
}
+(void)logout{
    [PIXAPIHandler logout];
}
+(instancetype)sharedInstance{
    if (![PIXAPIHandler isConsumerKeyAndSecrectAssigned]) {
        NSLog(@"您尚未設定 consumer key 或 consumer secrect");
        return nil;
    }
    static PIXNETSDK *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PIXNETSDK alloc] init];
    });
    return sharedInstance;
}
#pragma mark - User Method
-(void)getUserWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion{
    [[PIXUser new] getUserWithUserName:userName completion:completion];
}

-(void)getAccountWithCompletion:(PIXHandlerCompletion)completion{
    [[PIXUser new] getAccountWithCompletion:completion];
}

#pragma mark - Blog Method
#pragma mark - Blog Imformation

- (void)getBlogInformationWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogInformationWithUserName:userName completion:completion];
}

#pragma mark - Blog Categories

- (void)getBlogCategoriesWithUserName:(NSString *)userName
                             password:(NSString *)passwd
                           completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogCategoriesWithUserName:userName password:passwd completion:completion];
    
}
#pragma mark Categories method need access token

- (void)createBlogCategoriesWithName:(NSString *)name
                                type:(PIXBlogCategoryType)type
                         description:(NSString *)description
                        siteCategory:(NSString *)siteCateID
                          completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] createBlogCategoriesWithName:name type:type description:description siteCategory:siteCateID completion:completion];

}

- (void)updateBlogCategoryFromID:(NSString *)categoryID
                           newName:(NSString *)newName
                              type:(PIXBlogCategoryType)type
                       description:(NSString *)description
                        completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] updateBlogCategoryFromID:categoryID newName:newName type:type description:description completion:completion];
}

- (void)deleteBlogCategoriesByID:(NSString *)categoriesID
                      completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] deleteBlogCategoriesByID:categoriesID type:PIXBlogCategoryTypeCategory completion:completion];
}

- (void)deleteBlogFolderByID:(NSString *)folderID
                  completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] deleteBlogCategoriesByID:folderID type:PIXBlogCategoryTypeFolder completion:completion];
}

- (void)sortBlogCategoriesTo:(NSArray *)categoriesIDArray
                  completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] sortBlogCategoriesTo:categoriesIDArray completion:completion];
}

#pragma mark - Blog Articles
- (void)getBlogAllArticlesWithUserName:(NSString *)userName
                              password:(NSString *)passwd
                                  page:(NSUInteger)page
                               perpage:(NSUInteger)articlePerPage
                            completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogAllArticlesWithUserName:userName
                                         password:passwd
                                             page:page
                                          perpage:20
                                   userCategories:nil
                                           status:PIXArticleStatusPublic
                                            isTop:NO
                                         trimUser:YES
                                       completion:completion];
}

- (void)getBlogSingleArticleWithUserName:(NSString *)userName
                               articleID:(NSString *)articleID
                            blogPassword:(NSString *)blogPasswd
                         articlePassword:(NSString *)articlePasswd
                              completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogSingleArticleWithUserName:userName articleID:articleID blogPassword:blogPasswd articlePassword:articlePasswd completion:completion];
}

- (void)getBlogRelatedArticleByArticleID:(NSString *)articleID
                                userName:(NSString *)userName
                            relatedLimit:(NSUInteger)limit
                              completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogRelatedArticleByArticleID:articleID
                                           userName:userName
                                           withBody:NO
                                       relatedLimit:limit
                                         completion:completion];
}

- (void)getBlogArticleCommentsWithUserName:(NSString *)userName
                                 articleID:(NSString *)articleID
                              blogPassword:(NSString *)blogPasswd
                           articlePassword:(NSString *)articlePassword
                                      page:(NSUInteger)page
                           commentsPerPage:(NSUInteger)commentPerPage
                                completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogArticleCommentsWithUserName:userName articleID:articleID blogPassword:blogPasswd articlePassword:articlePassword page:page commentsPerPage:commentPerPage completion:completion];
}

- (void)getBlogLatestArticleWithUserName:(NSString *)userName
                            blogPassword:(NSString *)blogPassword
                              completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogLatestArticleWithUserName:userName
                                       blogPassword:blogPassword
                                              limit:20
                                           trimUser:YES
                                         completion:completion];
}

- (void)getBlogHotArticleWithUserName:(NSString *)userName
                             password:(NSString *)passwd
                           completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogHotArticleWithUserName:userName password:passwd limit:1 trimUser:YES completion:completion];
}

- (void)getblogSearchArticleWithKeyword:(NSString *)keyword
                               userName:(NSString *)userName
                                   page:(NSUInteger)page
                                perPage:(NSUInteger)perPage
                             completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getblogSearchArticleWithKeyword:keyword userName:userName searchType:PIXArticleSearchTypeKeyword page:page perPage:perPage completion:completion];
}
#pragma mark Article method need access token
- (void)createBlogArticleWithTitle:(NSString *)title
                              body:(NSString *)body
                        completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] createBlogArticleWithTitle:title
                                         body:body
                                       status:PIXArticleStatusPublic
                                     publicAt:nil
                               userCategoryID:nil
                               siteCategoryID:nil
                               useNewLineToBR:YES
                                  commentPerm:PIXArticleCommentPermBlogConfig
                                commentHidden:NO
                                         tags:nil
                                     thumbURL:nil
                                    trackback:nil
                                     password:nil
                                 passwordHint:nil
                                friendGroupID:nil
                                notifyTwitter:-1
                               notifyFacebook:-1
                                   completion:completion];
    
}

- (void)updateBlogArticleWithArticleID:(NSString *)articleID
                                 title:(NSString *)title
                                  body:(NSString *)body
                                status:(PIXArticleStatus)status
                              publicAt:(NSDate *)date
                        userCategoryID:(NSString *)userCategoryId
                        siteCategoryID:(NSString *)cateID
                           commentPerm:(PIXArticleCommentPerm)commentPerm
                         commentHidden:(BOOL)commentHidden
                                  tags:(NSArray *)tagArray
                              thumbURL:(NSString *)thumburl
                             trackback:(NSArray *)trackback
                              password:(NSString *)passwd
                          passwordHint:(NSString *)passwdHint
                         friendGroupID:(NSString *)friendGroupID
                         notifyTwitter:(BOOL)notifyTwitter
                        notifyFacebook:(BOOL)notifyFacebook
                            completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] updateBlogArticleWithArticleID:articleID
                                            title:title
                                             body:body
                                           status:status
                                         publicAt:date
                                   userCategoryID:userCategoryId
                                   siteCategoryID:cateID
                                   useNewLineToBR:YES
                                      commentPerm:commentPerm
                                    commentHidden:commentHidden
                                             tags:tagArray
                                         thumbURL:thumburl
                                        trackback:trackback
                                         password:passwd
                                     passwordHint:passwdHint
                                    friendGroupID:friendGroupID
                                    notifyTwitter:notifyTwitter
                                   notifyFacebook:notifyFacebook
                                       completion:completion];
}

- (void)deleteBlogArticleByArticleID:(NSString *)articleID
                          completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] deleteBlogArticleByArticleID:articleID completion:completion];
}

#pragma mark - Blog Comments

- (void)getBlogCommentsWithUserName:(NSString *)userName
                          articleID:(NSString *)articleID
                               page:(NSUInteger)page
                            perPage:(NSUInteger)perPage
                         completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogCommentsWithUserName:userName articleID:articleID blogPassword:nil articlePassword:nil filter:PIXBlogCommentFilterTypeAll isSortAscending:YES page:1 perPage:10 completion:completion];
    
}

- (void)getBlogSingleCommentWithUserName:(NSString *)userName
                              commmentID:(NSString *)commentID
                              completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogSingleCommentWithUserName:userName commmentID:commentID completion:completion];

}

- (void)getBlogLatestCommentWithUserName:(NSString *)userName
                              completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogLatestCommentWithUserName:userName completion:completion];
}

#pragma mark Comment method need access token

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
                            completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] createBlogCommentWithArticleID:articleID
                                             body:body
                                         userName:userName
                                           author:author
                                            title:title
                                              url:url
                                           isOpen:isOpen
                                            email:email
                                     blogPassword:blogPasswd
                                  articlePassword:articlePasswd
                                       completion:completion];
}

- (void)replyBlogCommentWithCommnetID:(NSString *)commentID
                                 body:(NSString *)body
                           completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] replyBlogCommentWithCommnetID:commentID body:body completion:completion];
}

- (void)updateBlogCommentOpenWithCommentID:(NSString *)commentID
                                    isOpen:(BOOL)isOpen
                                completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] updateBlogCommentOpenWithCommentID:commentID isOpen:isOpen completion:completion];
}

- (void)updateBlogCommentSpamWithCommentID:(NSString *)commentID
                                    isSpam:(BOOL)isSpam
                                completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] updateBlogCommentSpamWithCommentID:commentID isSpam:isSpam completion:completion];
}

- (void)deleteBlogCommentWithCommentID:(NSString *)commentID
                            completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] deleteBlogCommentWithCommentID:commentID completion:completion];
}

#pragma mark - Site Blog Categories
- (void)getBlogCategoriesListIncludeGroups:(BOOL)group
                                    thumbs:(BOOL)thumb
                                completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogCategoriesListIncludeGroups:group thumbs:thumb completion:completion];
}
#pragma mark - album(相簿)
-(void)getAlbumSiteCategoriesWithIsIncludeGroups:(BOOL)isIncludeGroups isIncludeThumbs:(BOOL)isIncludeThumbs completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getAlbumSiteCategoriesWithIsIncludeGroups:isIncludeGroups isIncludeThumbs:isIncludeThumbs completion:completion];
}
-(void)getAlbumMainWithCompletion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getAlbumMainWithCompletion:completion];
}
-(void)getAlbumConfigWithCompletion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getAlbumConfigWithCompletion:completion];
}
-(void)getAlbumSetsWithUserName:(NSString *)userName page:(NSUInteger)page completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getAlbumSetsWithUserName:userName trimUser:NO page:page perPage:20 completion:completion];
}
-(void)sortSetFoldersWithFolderIDs:(NSArray *)ids completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] sortSetFoldersWithFolderIDs:ids completion:completion];
}
-(void)getAlbumSetsWithUserName:(NSString *)userName parentID:(NSString *)parentID page:(NSUInteger)page completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getAlbumSetsWithUserName:userName parentID:parentID trimUser:NO page:page perPage:20 shouldAuth:NO completion:completion];
}
-(void)getAlbumSetWithUserName:(NSString *)userName setID:(NSString *)setId page:(NSUInteger)page completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getAlbumSetWithUserName:userName setID:setId page:page perPage:20 shouldAuth:NO completion:completion];
}
-(void)createAlbumSetWithTitle:(NSString *)setTitle description:(NSString *)setDescription permission:(PIXAlbumSetPermissionType)permission isAllowCC:(BOOL)isAllowCc commentRightType:(PIXAlbumSetCommentRightType)commentRightType password:(NSString *)password passwordHint:(NSString *)passwordHint friendGroupIDs:(NSArray *)friendGroupIds parentID:(NSString *)parentId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] createAlbumSetWithTitle:setTitle description:setDescription permission:permission categoryID:@"0" isLockRight:NO isAllowCC:isAllowCc commentRightType:commentRightType password:password passwordHint:passwordHint friendGroupIDs:friendGroupIds allowCommercialUse:NO allowDerivation:NO parentID:parentId completion:completion];
}
-(void)markAlbumSetCommentAsSpamWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] markAlbumSetCommentAsSpamWithCommentID:commentId completion:completion];
}
-(void)markAlbumSetCommentAsHamWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] markAlbumSetCommentAsHamWithCommentID:commentId completion:completion];
}
-(void)updateAlbumSetWithSetID:(NSString *)setId setTitle:(NSString *)setTitle setDescription:(NSString *)setDescription permission:(PIXAlbumSetPermissionType)permission categoryID:(NSString *)categoryId isLockRight:(BOOL)isLockRight isAllowCC:(BOOL)isAllowCc commentRightType:(PIXAlbumSetCommentRightType)commentRightType password:(NSString *)password passwordHint:(NSString *)passwordHint friendGroupIDs:(NSArray *)friendGroupIds allowCommercialUse:(BOOL)allowCommercialUse allowDerivation:(BOOL)allowDerivation parentID:(NSString *)parentId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] updateAlbumSetWithSetID:setId setTitle:setTitle setDescription:setDescription permission:permission categoryID:categoryId isLockRight:isLockRight isAllowCC:isAllowCc commentRightType:commentRightType password:password passwordHint:passwordHint friendGroupIDs:friendGroupIds allowCommercialUse:allowCommercialUse allowDerivation:allowDerivation parentID:parentId completion:completion];
}
-(void)deleteAlbumSetWithSetID:(NSString *)setId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] deleteAlbumSetWithSetID:setId completion:completion];
}
-(void)getAlbumSetElementsWithUserName:(NSString *)userName setID:(NSString *)setId elementType:(PIXAlbumElementType)elementType page:(NSUInteger)page password:(NSString *)password completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getAlbumSetElementsWithUserName:userName setID:setId elementType:elementType page:page perPage:20 password:password withDetail:NO trimUser:NO shouldAuth:NO completion:completion];
}
-(void)getAlbumSetCommentsWithUserName:(NSString *)userName setID:(NSString *)setId password:(NSString *)password page:(NSUInteger)page completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getAlbumSetCommentsWithUserName:userName setID:setId password:password page:page perPage:20 shouldAuth:NO completion:completion];
}
-(void)createAlbumSetCommentWithSetID:(NSString *)setId body:(NSString *)body password:(NSString *)password completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] createAlbumSetCommentWithSetID:setId body:body password:password completion:completion];
}
-(void)createElementCommentWithElementID:(NSString *)elementID body:(NSString *)body password:(NSString *)password completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] createElementCommentWithElementID:elementID body:body password:password completion:completion];
}
-(void)getAlbumSetsNearbyWithUserName:(NSString *)userName location:(CLLocationCoordinate2D)location distanceMin:(NSUInteger)distanceMin distanceMax:(NSUInteger)distanceMax page:(NSUInteger)page completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getAlbumSetsNearbyWithUserName:userName location:location distanceMin:distanceMin distanceMax:distanceMax page:page perPage:100 trimUser:NO shouldAuth:NO completion:completion];
}
-(void)getAlbumFoldersWithUserName:(NSString *)userName trimUser:(BOOL)trimUser page:(NSUInteger)page completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getAlbumFoldersWithUserName:userName trimUser:NO page:page perPage:20 shouldAuth:NO completion:completion];
}
-(void)getAlbumFolderWithUserName:(NSString *)userName folderID:(NSString *)folderId page:(NSUInteger)page completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getAlbumFolderWithUserName:userName folderID:folderId page:page perPage:20 shouldAuth:NO completion:completion];
}
-(void)sortAlbumSetsWithParentID:(NSString *)parentId IDs:(NSArray *)ids completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] sortAlbumSetsWithParentID:parentId IDs:ids completion:completion];
}
-(void)createAlbumFolderWithTitle:(NSString *)folderTitle description:(NSString *)folderDescription completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] createAlbumFolderWithTitle:folderTitle description:folderDescription completion:completion];
}
-(void)updateAlbumFolderWithFolderID:(NSString *)folderId title:(NSString *)folderTitle description:(NSString *)folderDescription completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] updateAlbumFolderWithFolderID:folderId title:folderTitle description:folderDescription completion:completion];
}
-(void)deleteAlbumFolderWithFolderID:(NSString *)folderId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] deleteAlbumFolderWithFolderID:folderId completion:completion];
}
-(void)getElementsNearbyWithUserName:(NSString *)userName location:(CLLocationCoordinate2D)location distanceMin:(NSUInteger)distanceMin distanceMax:(NSUInteger)distanceMax page:(NSUInteger)page withDetail:(BOOL)withDetail type:(PIXAlbumElementType)type completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getElementsNearbyWithUserName:userName location:location distanceMin:distanceMin distanceMax:distanceMax page:page perPage:100 withDetail:withDetail type:type trimUser:NO shouldAuth:NO completion:completion];
}
-(void)getElementWithUserName:(NSString *)userName elementID:(NSString *)elementId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getElementWithUserName:userName elementID:elementId withSetInfo:NO completion:completion];
}
-(void)updateElementWithElementID:(NSString *)elementId elementTitle:(NSString *)elementTitle elementDescription:(NSString *)elementDescription setID:(NSString *)setId videoThumbType:(PIXVideoThumbType)videoThumbType tags:(NSArray *)tags location:(CLLocationCoordinate2D)location completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] updateElementWithElementID:elementId elementTitle:elementTitle elementDescription:elementDescription setID:setId videoThumbType:videoThumbType tags:tags location:location completion:completion];
}
-(void)deleteElementWithElementID:(NSString *)elementId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] deleteElementWithElementID:elementId completion:completion];
}
-(void)sortElementsWithSetID:(NSString *)setId elementIDs:(NSArray *)ids completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] sortElementsWithSetID:setId elementIDs:ids completion:completion];
}
-(void)getElementCommentsWithUserName:(NSString *)userName elementID:(NSString *)elementId password:(NSString *)password page:(NSUInteger)page completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getElementCommentsWithUserName:userName elementID:elementId password:password page:page perPage:20 completion:completion];
}
-(void)getCommentWithUserName:(NSString *)userName commentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] getCommentWithUserName:userName commentID:commentId completion:completion];
}
-(void)markCommentAsSpamWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] markCommentAsSpamWithCommentID:commentId completion:completion];
}
-(void)markCommentAsHamWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] markCommentAsHamWithCommentID:commentId completion:completion];
}
-(void)deleteCommentWithCommentID:(NSString *)commentId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] deleteCommentWithCommentID:commentId completion:completion];
}
-(void)createElementWithElementData:(NSData *)elementData setID:(NSString *)setId elementTitle:(NSString *)elementTitle elementDescription:(NSString *)elementDescription tags:(NSArray *)tags location:(CLLocationCoordinate2D)location completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] createElementWithElementData:elementData setID:setId elementTitle:elementTitle elementDescription:elementDescription tags:tags location:location videoThumbType:PIXVideoThumbTypeEnd picShouldRotateByExif:YES videoShouldRotateByMeta:YES shouldUseQuadrate:YES shouldAddWatermark:YES isElementFirst:YES completion:completion];
}
-(void)tagFriendWithElementID:(NSString *)elementId beTaggedUser:(NSString *)beTaggedUser tagFrame:(CGRect)tagFrame completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] tagFriendWithElementID:elementId beTaggedUser:beTaggedUser tagFrame:tagFrame recommendID:nil completion:completion];
}
-(void)updateTagedFaceWithFaceId:(NSString *)faceId elementId:(NSString *)elementId beTaggedUser:(NSString *)beTaggedUser newTagFrame:(CGRect)newTagFrame completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] updateTagedFaceWithFaceId:faceId elementId:elementId beTaggedUser:beTaggedUser newTagFrame:newTagFrame completion:completion];
}
-(void)deleteTagWithFaceID:(NSString *)faceId completion:(PIXHandlerCompletion)completion{
    [[PIXAlbum new] deleteTagWithFaceId:faceId completion:completion];
}
@end
