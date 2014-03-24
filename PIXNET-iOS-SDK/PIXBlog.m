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
- (void)getBlogInformationWithUserID:(NSString *)userID
                          completion:(RequestCompletion)completion{
    //檢查進來的參數
    if (userID == nil) {
        completion(NO, nil, @"userID 不可為 nil");
        return;
    }
    [[PIXAPIHandler new] callAPI:@"blog" parameters:@{@"user": userID} requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
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
- (void)getBlogCategoriesWithUserID:(NSString *)userID
                        andPassword:(NSString *)passwd completion:(RequestCompletion)completion{
    //檢查進來的參數
    if (userID == nil) {
        completion(NO, nil, @"userID 不可為 nil");
        return;
    }
    if (passwd == nil) {
        [[PIXAPIHandler new] callAPI:@"blog" parameters:@{@"user": userID} requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
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
    }else {
        [[PIXAPIHandler new] callAPI:@"blog" parameters:@{@"user": userID, @"passwd": passwd} requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
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

}

#pragma mark - Blog Articles
- (void)getBlogAllArticlesWithUserID:(NSString *)userID
                         andPassword:(NSString *)passwd
                            withpage:(NSInteger)page
                      articlePerPage:(NSInteger)articlePerPage
                          completion:(RequestCompletion)completion{
    //檢查進來的參數
    if (userID == nil) {
        completion(NO, nil, @"userID 不可為 nil");
        return;
    }
    if (passwd == nil) {
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"user"] = userID;
        params[@"page"] = @(page);
        params[@"per_page"] = @(articlePerPage);
        
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
    }else {
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"user"] = userID;
        params[@"password"] = passwd;
        params[@"page"] = @(page);
        params[@"per_page"] = @(articlePerPage);
        
        [[PIXAPIHandler new] callAPI:@"blog" parameters:params requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
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
}

- (void)getBlogSingleArticleWithUserID:(NSString *)userID
                      withBlogPassword:(NSString *)blogPasswd
                    andArticlePassword:(NSString *)articlePasswd
                            completion:(RequestCompletion)completion{
    if (userID == nil) {
        completion(NO, nil, @"userID 不可為 nil");
        return;
    }
    
    

}

@end
