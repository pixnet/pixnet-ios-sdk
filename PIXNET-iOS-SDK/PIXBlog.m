//
//  PIXBlog.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//

#import "PIXBlog.h"
#import "PIXAPIHandler.h"

@implementation PIXBlog

+(instancetype)sharedInstance{
    static PIXBlog *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PIXBlog alloc] init];
    });
    return sharedInstance;
}

-(void)succeedHandleWithData:(id)data completion:(PIXHandlerCompletion)completion{
    NSError *jsonError;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    if (jsonError == nil) {
        if ([dict[@"error"] intValue] == 0) {
            completion(YES, dict, nil);
        } else {
            completion(NO, nil, dict[@"message"]);
        }
    } else {
        completion(NO, nil, jsonError.localizedDescription);
    }
}


#pragma mark - Blog information
- (void)getBlogInformationWithUserName:(NSString *)userName
                          completion:(PIXHandlerCompletion)completion{
    //檢查進來的參數
    if (userName == nil) {
        completion(NO, nil, @"userName 不可為 nil");
        return;
    }
    [[PIXAPIHandler new] callAPI:@"blog" parameters:@{@"user": userName} requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
        //檢查出去的參數
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}

#pragma mark - Blog Categories
- (void)getBlogCategoriesWithUserName:(NSString *)userName
                             password:(NSString *)passwd
                           completion:(PIXHandlerCompletion)completion{
    //檢查進來的參數
    if (userName == nil) {
        completion(NO, nil, @"userName 不可為 nil");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    
    if (passwd != nil) {
        params[@"password"] = passwd;
    }
    [[PIXAPIHandler new] callAPI:@"blog/categories" parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
        completion(NO, nil, errorMessage);
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}

#pragma mark - Blog Articles
- (void)getBlogAllArticlesWithUserName:(NSString *)userName
                              password:(NSString *)passwd
                                  page:(NSUInteger)page
                               perpage:(NSUInteger)articlePerPage
                            completion:(PIXHandlerCompletion)completion{
    //檢查進來的參數
    if (userName == nil) {
        completion(NO, nil, @"userName 不可為 nil");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    
    if (passwd != nil) {
        params[@"password"] = passwd;
    }
    if (page != 0 || page) {
        params[@"page"] = @(page);
    }
    if (articlePerPage !=0 || articlePerPage) {
        params[@"per_page"] = @(articlePerPage);
    }
    
    [[PIXAPIHandler new] callAPI:@"blog/articles"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
}

- (void)getBlogSingleArticleWithUserName:(NSString *)userName
                               articleID:(NSString *)articleID
                            blogPassword:(NSString *)blogPasswd
                         articlePassword:(NSString *)articlePasswd
                              completion:(PIXHandlerCompletion)completion{
    
    if (userName == nil || userName.length == 0 || !userName) {
        completion(NO, nil, @"Missing User Name");
        return;
    }
    if (articleID == nil || articleID.length == 0) {
        completion(NO, nil, @"Missing Article ID");
        return;
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    if (blogPasswd != nil) {
        params[@"blog_password"] = blogPasswd;
    }
    if (articlePasswd != nil) {
        params[@"article_password"] = articlePasswd;
    }
    
    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blog/articles/%@", articleID]
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
}

- (void)getBlogRelatedArticleByArticleID:(NSString *)articleID
                                userName:(NSString *)userName
                            relatedLimit:(NSUInteger)limit
                              completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"Missing User Name");
        return;
    }
    if (articleID == nil || articleID.length == 0) {
        completion(NO, nil, @"Missing Article ID");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    if (limit != 0 || limit) {
        params[@"limit"] = @(limit);
    }
    
    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blog/articles/%@/related", articleID]
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];

}

- (void)getBlogArticleCommentsWithUserName:(NSString *)userName
                                 articleID:(NSString *)articleID
                              blogPassword:(NSString *)blogPasswd
                           articlePassword:(NSString *)articlePassword
                                      page:(NSUInteger)page
                           commentsPerPage:(NSUInteger)commentPerPage
                                completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"Missing User Name");
        return;
    }
    if (articleID == nil || articleID.length == 0) {
        completion(NO, nil, @"Missing Article ID");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];

    params[@"user"] = userName;
    params[@"article_id"] = articleID;
    
    if (blogPasswd || blogPasswd.length != 0) {
        params[@"blog_password"] = blogPasswd;
    }
    if (articlePassword || articlePassword.length != 0) {
        params[@"article_password"] = articlePassword;
    }
    if (page) {
        params[@"page"] = @(page);
    }
    if (commentPerPage) {
        params[@"per_page"] = @(commentPerPage);
    }
    
    [[PIXAPIHandler new] callAPI:@"blog/comments"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
}

- (void)getBlogLatestArticleWithUserName:(NSString *)userName
                              completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"Missing User Name");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"user"] = userName;
    
    [[PIXAPIHandler new] callAPI:@"blog/articles/latest"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
    
}

- (void)getBlogHotArticleWithUserName:(NSString *)userName
                               passwd:(NSString *)passwd
                           completion:(PIXHandlerCompletion)completion{
    
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"Missing User Name");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"user"] = userName;
    
    if (passwd || passwd.length >>0 || passwd !=nil) {
        params[@"blog_password"] = passwd;
    }
    
    
    [[PIXAPIHandler new] callAPI:@"blog/articles/hot"
                      parameters:params
              requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
}

- (void)getblogSearchArticleWithKeyword:(NSString *)keyword
                               userName:(NSString *)userName
                                   page:(NSUInteger)page
                                perPage:(NSUInteger)perPage
                             completion:(PIXHandlerCompletion)completion{
    
    if (keyword == nil || keyword.length == 0 || !keyword) {
        completion(NO, nil, @"Missing Search String");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];

    params[@"key"] = keyword;
 
    if (userName || userName.length >> 0 || userName != nil) {
        params[@"user"] = userName;
    } else {
        params[@"site"] = @"true";
    }
    
    if (page) {
        params[@"page"] = @(page);
    }
    
    if (perPage) {
        params[@"per_page"] = @(perPage);
    }
    
    
    [[PIXAPIHandler new] callAPI:@"blog/articles/search"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
    
}

#pragma mark - Blog Comments

- (void)getBlogCommentsWithUserName:(NSString *)userName
                          articleID:(NSString *)articleID
                               page:(NSUInteger)page
                            perPage:(NSUInteger)perPage
                         completion:(PIXHandlerCompletion)completion{
    
    if (userName == nil || userName.length == 0 || !userName) {
        completion(NO, nil, @"Missing User Name");
        return;
    }
    
    if (articleID == nil || articleID.length == 0 || !articleID) {
        completion(NO, nil, @"Missing Article ID");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"user"] = userName;
    params[@"article_id"] = articleID;
    
    if (page) {
        params[@"page"] = @(page);
    }
    if (perPage) {
        params[@"per_page"] = @(perPage);
    }
    
    [[PIXAPIHandler new] callAPI:@"blog/comments"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];

}

- (void)getBlogSingleCommentWithUserName:(NSString *)userName
                              commmentID:(NSString *)commentID
                              completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, @"Missing User Name");
        return;
    }
    
    if (commentID == nil || commentID.length == 0) {
        completion(NO, nil, @"Missing Comment ID");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"user"] = userName;
    
    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blog/comments/%@", commentID]
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
}

- (void)getBlogLatestCommentWithUserName:(NSString *)userName
                              completion:(PIXHandlerCompletion)completion{
    
    NSMutableDictionary *params = [NSMutableDictionary new];

    if (userName || userName != nil || userName.length >> 0) {
        params[@"user"] = userName;
    }
    
    [[PIXAPIHandler new] callAPI:@"blog/comments/latest"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
    
}
#pragma mark - Site Blog Categories list

- (void)getBlogCategoriesListIncludeGroups:(BOOL)group
                                    thumbs:(BOOL)thumb
                                completion:(PIXHandlerCompletion)completion{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if (group) {
        params[@"include_groups"] = @"1";
    }else{
        params[@"include_groups"] = @"0";
    }
    
    if (thumb) {
        params[@"include_thumbs"] = @"1";
    }else{
        params[@"include_thumbs"] = @"0";
    }
    
    [[PIXAPIHandler new] callAPI:@"blog/site_categories"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
    
}

@end
