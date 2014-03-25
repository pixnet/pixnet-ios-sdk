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

#pragma mark - Blog information
- (void)getBlogInformationWithUserName:(NSString *)userName
                          completion:(RequestCompletion)completion{
    //檢查進來的參數
    if (userName == nil) {
        completion(NO, nil, @"userName 不可為 nil");
        return;
    }
    [[PIXAPIHandler new] callAPI:@"blog" parameters:@{@"user": userName} requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
        //檢查出去的參數
        if (succeed) {
            NSError *jsonError = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&jsonError];
            if (jsonError) {
                completion(NO, nil, jsonError.localizedDescription);
            } else {
                if ([dict[@"error"] intValue] == 0) {
                    completion(YES, dict[@"blog"], nil);
                } else {
                    completion(NO, nil, dict[@"message"]);
                }
            }
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}

#pragma mark - Blog Categories
- (void)getBlogCategoriesWithUserName:(NSString *)userName
                             Password:(NSString *)passwd
                           completion:(RequestCompletion)completion{
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
    [[PIXAPIHandler new] callAPI:@"blog" parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
        completion(NO, nil, errorMessage);
        if (succeed) {
            NSError *jsonError = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&jsonError];
            if (jsonError) {
                completion(NO, nil, jsonError.localizedDescription);
            } else {
                if ([dict[@"error"] intValue] == 0) {
                    completion(YES, dict[@"blog"], nil);
                } else {
                    completion(NO, nil, dict[@"message"]);
                }
            }
        } else {
            completion(NO, nil, errorMessage);
        }
    }];
}

#pragma mark - Blog Articles
- (void)getBlogAllArticlesWithuserName:(NSString *)userName
                              Password:(NSString *)passwd
                                  Page:(NSInteger)page
                               Perpage:(NSInteger)articlePerPage
                            completion:(RequestCompletion)completion{
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
    
    [[PIXAPIHandler new] callAPI:@"blog"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       
                       NSError *jsonError = nil;
                       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&jsonError];
                       
                       if (jsonError) {
                           
                           completion(NO, nil, jsonError.localizedDescription);
                           
                       } else {
                           if ([dict[@"error"] intValue] == 0) {
                               
                               completion(YES, dict[@"blog"], nil);
                               
                           } else {
                               
                               completion(NO, nil, dict[@"message"]);
                           }
                       }
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
}

- (void)getBlogSingleArticleWithUserName:(NSString *)userName
                            BlogPassword:(NSString *)blogPasswd
                         ArticlePassword:(NSString *)articlePasswd
                              completion:(RequestCompletion)completion{
    if (userName == nil) {
        completion(NO, nil, @"userName 不可為 nil");
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
    
    [[PIXAPIHandler new] callAPI:@"blog"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       
                       NSError *jsonError = nil;
                       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&jsonError];
                       
                       if (jsonError) {
                           
                           completion(NO, nil, jsonError.localizedDescription);
                           
                       } else {
                           if ([dict[@"error"] intValue] == 0) {
                               
                               completion(YES, dict[@"blog"], nil);
                               
                           } else {
                               
                               completion(NO, nil, dict[@"message"]);
                           }
                       }
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
}

- (void)getBlogRelatedArticleByArticleID:(NSString *)articleID
                                UserName:(NSString *)userName
                            RelatedLimit:(NSInteger)limit
                              completion:(RequestCompletion)completion{
    if (userName == nil) {
        completion(NO, nil, @"userName 不可為 nil");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    if (limit != 0 || limit) {
        params[@"limit"] = @(limit);
    }
    
    [[PIXAPIHandler new] callAPI:@"blog"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
                   completion(NO, nil, errorMessage);
                   if (succeed) {
                       
                       NSError *jsonError = nil;
                       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&jsonError];
                       
                       if (jsonError) {
                           
                           completion(NO, nil, jsonError.localizedDescription);
                           
                       } else {
                           if ([dict[@"error"] intValue] == 0) {
                               
                               completion(YES, dict[@"blog"], nil);
                               
                           } else {
                               
                               completion(NO, nil, dict[@"message"]);
                           }
                       }
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];

}

@end
