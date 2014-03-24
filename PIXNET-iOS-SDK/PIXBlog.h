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
- (void)getBlogInformationWithUserID:(NSString *)userID
                          completion:(RequestCompletion)completion;

#pragma mark - Blog Categories
//dosen't need Access token
- (void)getBlogCategoriesWithUserID:(NSString *)userID
                        andPassword:(NSString *)passwd
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
- (void)getBlogAllArticlesWithUserID:(NSString *)userID
                         andPassword:(NSString *)passwd
                            withpage:(NSInteger)page
                      articlePerPage:(NSInteger)articlePerPage
                          completion:(RequestCompletion)completion;

- (void)getBlogSingleArticleWithUserID:(NSString *)userID
                      withBlogPassword:(NSString *)blogPasswd
                    andArticlePassword:(NSString *)articlePasswd
                            completion:(RequestCompletion)completion;

- (void)getBlogRelatedArticleByArticleID:(NSString *)articleID
                                  userID:(NSString *)userID
                         andRelatedLimit:(NSInteger)limit
                              completion:(RequestCompletion)completion;

- (void)getBlogArticleCommentsWithUserID:(NSString *)userID
                               articleID:(NSString *)articleID
                            blogPassword:(NSString *)blogPasswd
                         articlePassword:(NSString *)articlePassword
                                    page:(NSInteger)page
                         commentsPerPage:(NSInteger)commentPerPage
                              completion:(RequestCompletion)completion;

- (void)getBlogLatestArticleWithUserID:(NSString *)userID
                            completion:(RequestCompletion)completion;

- (void)getBlogHotArticleWithUserID:(NSString *)userID
                         completion:(RequestCompletion)completion;

- (void)getblogSearchArticleWithKeyword:(NSString *)keyword
                                 inUser:(NSString *)userID
                             completion:(RequestCompletion)completion;
//need access token
//還沒寫

#pragma mark - Blog Comments
//dosen't need Access token
- (void)getBlogCommentsWithUserID:(NSString *)userID
                     andArticleID:(NSString *)articleID
                             page:(NSInteger)page
                          perPage:(NSInteger)perPage
                       completion:(RequestCompletion)completion;

- (void)getBlogSingleCommentWithUserID:(NSString *)userID
                         andCommmentID:(NSString *)commentID
                            completion:(RequestCompletion)completiom;

- (void)getBlogLatestCommentWithUserID:(NSString *)userID
                            completion:(RequestCompletion)completion;
//need access token
//還沒寫


#pragma mark - Blog Categories list
//dosen't need Access token
- (void)getBlogCategoriesListCompletion:(RequestCompletion)completion;

//need access token
//還沒寫

@end
