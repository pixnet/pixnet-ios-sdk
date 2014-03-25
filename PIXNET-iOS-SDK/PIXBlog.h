//
//  PIXBlog.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//
//  這個 class 用來處理輸出入參數的規格正確性

#import <Foundation/Foundation.h>
#import "PIXAPIHandler.h"

@interface PIXBlog : NSObject
//+(instancetype)sharedInstance;
#pragma mark - Blog imformation
- (void)getBlogInformationWithUserName:(NSString *)userName
                          completion:(RequestCompletion)completion;

#pragma mark - Blog Categories
//dosen't need Access token
- (void)getBlogCategoriesWithUserName:(NSString *)userName
                             Password:(NSString *)passwd
                           completion:(RequestCompletion)completion;

//need access token
- (void)postBlogCategoriesWithName:(NSString *)name
                        completion:(RequestCompletion)completion;

- (void)changeBlogCategoriesFromID:(NSString *)categoriesID
                                to:(NSString *)newName
                        completion:(RequestCompletion)completion;

- (void)deleteBlogCategoriesByID:(NSString *)categoriesID
                      completion:(RequestCompletion)completion;

- (void)sortBlogCategoriesTo:(NSArray *)categoriesIDArray
                  completion:(RequestCompletion)completion;

#pragma mark - Blog Articles
//dosen't need Access token
- (void)getBlogAllArticlesWithuserName:(NSString *)userName
                              Password:(NSString *)passwd
                                  Page:(NSInteger)page
                               Perpage:(NSInteger)articlePerPage
                            completion:(RequestCompletion)completion;

- (void)getBlogSingleArticleWithUserName:(NSString *)userName
                            BlogPassword:(NSString *)blogPasswd
                         ArticlePassword:(NSString *)articlePasswd
                              completion:(RequestCompletion)completion;

- (void)getBlogRelatedArticleByArticleID:(NSString *)articleID
                                UserName:(NSString *)userName
                            RelatedLimit:(NSInteger)limit
                              completion:(RequestCompletion)completion;

- (void)getBlogArticleCommentsWithUserName:(NSString *)userName
                               articleID:(NSString *)articleID
                            blogPassword:(NSString *)blogPasswd
                         articlePassword:(NSString *)articlePassword
                                    page:(NSInteger)page
                         commentsPerPage:(NSInteger)commentPerPage
                              completion:(RequestCompletion)completion;

- (void)getBlogLatestArticleWithUserName:(NSString *)userName
                            completion:(RequestCompletion)completion;

- (void)getBlogHotArticleWithUserName:(NSString *)userName
                         completion:(RequestCompletion)completion;

- (void)getblogSearchArticleWithKeyword:(NSString *)keyword
                                 inUser:(NSString *)userName
                             completion:(RequestCompletion)completion;
//need access token
//還沒寫

#pragma mark - Blog Comments
//dosen't need Access token
- (void)getBlogCommentsWithUserName:(NSString *)userName
                     andArticleID:(NSString *)articleID
                             page:(NSInteger)page
                          perPage:(NSInteger)perPage
                       completion:(RequestCompletion)completion;

- (void)getBlogSingleCommentWithUserName:(NSString *)userName
                         andCommmentID:(NSString *)commentID
                            completion:(RequestCompletion)completiom;

- (void)getBlogLatestCommentWithUserName:(NSString *)userName
                            completion:(RequestCompletion)completion;
//need access token
//還沒寫


#pragma mark - 0 Blog Categories list
//dosen't need Access token
- (void)getBlogCategoriesListCompletion:(RequestCompletion)completion;

//need access token
//還沒寫

@end
