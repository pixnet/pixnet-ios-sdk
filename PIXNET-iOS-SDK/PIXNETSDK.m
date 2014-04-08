//
//  PIXNETSDK.m
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/3/13.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//

#import "PIXNETSDK.h"
#import "PIXBlog.h"

@implementation PIXNETSDK
+(void)setConsumerKey:(NSString *)aKey consumerSecret:(NSString *)aSecret{
    [PIXAPIHandler setConsumerKey:aKey consumerSecret:aSecret];
}
+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password requestCompletion:(PIXHandlerCompletion)completion{
    [PIXAPIHandler authByXauthWithUserName:userName userPassword:password requestCompletion:completion];
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

#pragma mark - Blog Articles
- (void)getBlogAllArticlesWithUserName:(NSString *)userName
                              password:(NSString *)passwd
                                  page:(NSUInteger)page
                               perpage:(NSUInteger)articlePerPage
                            completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogAllArticlesWithUserName:userName password:passwd page:page perpage:articlePerPage completion:completion];
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
    [[PIXBlog new] getBlogRelatedArticleByArticleID:articleID userName:userName relatedLimit:limit completion:completion];
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
                              completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogLatestCommentWithUserName:userName completion:completion];
}

- (void)getBlogHotArticleWithUserName:(NSString *)userName
                             password:(NSString *)passwd
                           completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogHotArticleWithUserName:userName password:passwd completion:completion];
}

- (void)getblogSearchArticleWithKeyword:(NSString *)keyword
                               userName:(NSString *)userName
                                   page:(NSUInteger)page
                                perPage:(NSUInteger)perPage
                             completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getblogSearchArticleWithKeyword:keyword userName:userName page:page perPage:perPage completion:completion];
}


#pragma mark - Blog Comments

- (void)getBlogCommentsWithUserName:(NSString *)userName
                          articleID:(NSString *)articleID
                               page:(NSUInteger)page
                            perPage:(NSUInteger)perPage
                         completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogCommentsWithUserName:userName articleID:articleID page:page perPage:perPage completion:completion];
    
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


#pragma mark - Site Blog Categories
- (void)getBlogCategoriesListIncludeGroups:(BOOL)group
                                    thumbs:(BOOL)thumb
                                completion:(PIXHandlerCompletion)completion{
    [[PIXBlog new] getBlogCategoriesListIncludeGroups:group thumbs:thumb completion:completion];
}

@end
