//
//  PIXBlog.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//

#import "PIXBlog.h"
#import "PIXAPIHandler.h"
#import "NSObject+PIXCategory.h"
#import "NSError+PIXCategory.h"
#import "NSDictionary+PIXCategory.h"

@implementation PIXBlog

#pragma mark - Blog information

- (void)getSiteCategoriesForArticleWithGroups:(BOOL)isIncludeGroups isIncludeThumbs:(BOOL)isIncludeThumbs completion:(PIXHandlerCompletion)completion {
    NSDictionary *params = @{@"include_groups":[NSString stringWithFormat:@"%i", isIncludeGroups], @"include_thumbs":[NSString stringWithFormat:@"%i", isIncludeThumbs]};
    [[PIXAPIHandler new] callAPI:@"blog/site_categories/article" httpMethod:@"GET" parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}

- (void)getSiteCategoriesForBlogWithGroups:(BOOL)isIncludeGroups isIncludeThumbs:(BOOL)isIncludeThumbs completion:(PIXHandlerCompletion)completion {
    NSDictionary *params = @{@"include_groups":[NSString stringWithFormat:@"%i", isIncludeGroups], @"include_thumbs":[NSString stringWithFormat:@"%i", isIncludeThumbs]};
    [[PIXAPIHandler new] callAPI:@"blog/site_categories/blog" httpMethod:@"GET" parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}

- (void)getSuggestedTagsWithUser:(NSString *)user completion:(PIXHandlerCompletion)completion {
    if (!user || user.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"user 一定要有資料"]);
        return;
    }
    [[PIXAPIHandler new] callAPI:@"blog/suggested_tags" parameters:@{@"user": user} requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
};

- (void)getBlogInformationWithUserName:(NSString *)userName
                            completion:(PIXHandlerCompletion)completion{
    //檢查進來的參數
    if (userName == nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing User Name"]);
        return;
    }
    [[PIXAPIHandler new] callAPI:@"blog" httpMethod:@"GET" parameters:@{@"user":userName} requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}
- (void)updateBlogInformationWithBlogName:(NSString *)blogName blogDescription:(NSString *)blogDescription keywords:(NSArray *)keywords siteCategoryId:(NSString *)siteCategoryId completion:(PIXHandlerCompletion)completion{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    if (blogName && blogName.length>0) {
        params[@"name"] = blogName;
    }
    if (blogDescription && blogDescription.length>0) {
        params[@"description"] = blogDescription;
    }
    if (keywords) {
        for (id keyword in keywords) {
            if (![keyword isKindOfClass:[NSString class]]) {
                completion(NO, nil, [NSError PIXErrorWithParameterName:@"Every value in keywords should be string"]);
                return;
            }
        }
        params[@"keyword"] = [keywords componentsJoinedByString:@","];
    }
    if (siteCategoryId && siteCategoryId.length>0) {
        params[@"site_category_id"] = siteCategoryId;
    }
    [[PIXAPIHandler new] callAPI:@"blog" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}

#pragma mark - Blog Categories
- (void)getBlogCategoriesWithUserName:(NSString *)userName
                             password:(NSString *)passwd
                                 type:(NSString *)type
                           completion:(PIXHandlerCompletion)completion{
    //檢查進來的參數
    if (userName == nil || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing User Name"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user"] = userName;

    if (passwd != nil) {
        params[@"blog_password"] = passwd;
    }
    if (type) {
        if ([type isEqualToString:@"folder"]) {
            params[@"type"] = type;
        } else {
            params[@"type"] = @"category";
        }
    }
    [[PIXAPIHandler new] callAPI:@"blog/categories" parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}
#pragma mark Categories need access token
- (void)createBlogCategoriesWithName:(NSString *)name
                                type:(PIXBlogCategoryType)type
                         description:(NSString *)description
                        siteCategory:(NSString *)siteCateID
                          completion:(PIXHandlerCompletion)completion{

    if (name == nil || name.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Category Name"]);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"name"] = name;

    if (type == PIXBlogCategoryTypeCategory) {
        params[@"type"] = @"category";
        params[@"site_category_done"] = @"1";
        if (siteCateID) {
            params[@"site_category_id"] = siteCateID;
        }
    }else if (type == PIXBlogCategoryTypeFolder){
        params[@"type"] = @"folder";
    }

    if (description != nil && description.length != 0) {
        params[@"description"] = description;
    }
    [[PIXAPIHandler new] callAPI:@"blog/categories" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}

- (void)updateBlogCategoryFromID:(NSString *)categoryID
                         newName:(NSString *)newName
                            type:(PIXBlogCategoryType)type
                     description:(NSString *)description
                      completion:(PIXHandlerCompletion)completion{
    if (categoryID==nil || categoryID.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"categoryID 參數有誤"]);
        return;
    }
    if (newName == nil || newName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing New Name"]);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"name"] = newName;
    switch (type) {
        case PIXBlogCategoryTypeCategory:
            params[@"type"] = @"category";
            break;
        case PIXBlogCategoryTypeFolder:
            params[@"type"] = @"folder";
            break;
        default:
            break;
    }

    if (description != nil && description.length > 0) {
        params[@"description"] = description;
    }

    NSString *path = [NSString stringWithFormat:@"blog/categories/%@", categoryID];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}

- (void)deleteBlogCategoriesByID:(NSString *)categoriesID
                            type:(PIXBlogCategoryType)type
                      completion:(PIXHandlerCompletion)completion{
    if (categoriesID == nil || categoriesID.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Category/Folder ID"]);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];

    switch (type) {
        case PIXBlogCategoryTypeCategory:
            params[@"type"] = @"category";
            break;
        case PIXBlogCategoryTypeFolder:
            params[@"type"] = @"folder";
            break;
        default:
            break;
    }
    params[@"_method"] = @"delete";

    NSString *path = [NSString stringWithFormat:@"blog/categories/%@", categoriesID];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}

- (void)sortBlogCategoriesTo:(NSArray *)categoriesIDArray
                  completion:(PIXHandlerCompletion)completion{
    NSString *idsString = [categoriesIDArray componentsJoinedByString:@"-"];
    NSDictionary *params = @{@"ids": idsString};

    [[PIXAPIHandler new] callAPI:@"blog/categories/position" httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}


#pragma mark - Blog Articles

- (void)getBlogAllArticlesWithUserName:(NSString *)userName password:(NSString *)passwd page:(NSUInteger)page perpage:(NSUInteger)articlePerPage userCategories:(NSArray <NSString *>*)userCategories status:(PIXArticleStatus)status isTop:(BOOL)isTop trimUser:(BOOL)trimUser shouldAuth:(BOOL)shouldAuth thumbSize:(ThumbSize)thumbSize completion:(PIXHandlerCompletion)completion {
    //檢查進來的參數
    if (userName == nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing User Name"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;

    if (passwd && passwd.length>0) {
        params[@"blog_password"] = passwd;
    }
    if (page <= 0) {
        params[@"page"] = @"1";
    } else {
        params[@"page"] = [NSString stringWithFormat:@"%lu", (unsigned long)page];
    }
    if (articlePerPage <= 0) {
        params[@"per_page"] = @"20";
    } else {
        params[@"per_page"] = [NSString stringWithFormat:@"%lu", (unsigned long)articlePerPage];
    }
    if (userCategories) {
        if (userCategories.count > 10) {
            completion(NO, nil, [NSError PIXErrorWithParameterName:@"個人自行定義的分類最多只能10個"]);
            return;
        }
        for (id value in userCategories) {
            if (![value isKindOfClass:[NSString class]]) {
                completion(NO, nil, [NSError PIXErrorWithParameterName:@"個人自行定義的分類裡每個值都一定要是 NSString"]);
                return;
            }
        }
        params[@"category_id"] = [userCategories componentsJoinedByString:@","];
    }
    if (status >= 0) {
        params[@"status"] = [NSString stringWithFormat:@"%li", (long)status];
    }
    params[@"is_top"] = [NSString stringWithFormat:@"%i", isTop];
    params[@"trim_user"] = [NSString stringWithFormat:@"%i", trimUser];
    params = [self getThumbSizeParams:thumbSize params:params];

    [[PIXAPIHandler new] callAPI:@"blog/articles" httpMethod:@"GET" shouldAuth:shouldAuth parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [self succeedHandleWithData:result completion:completion];
        } else {
            completion(NO, nil, error);
        }
    }];
}

- (void)getBlogSingleArticleWithUserName:(NSString *)userName articleID:(NSString *)articleID needAuth:(BOOL)needAuth blogPassword:(NSString *)blogPasswd articlePassword:(NSString *)articlePasswd thumbSize:(ThumbSize)thumbSize completion:(PIXHandlerCompletion)completion {

    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing User Name"]);
        return;
    }
    if (articleID == nil || articleID.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Article ID"]);
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
    
    params = [self getThumbSizeParams:thumbSize params:params];
    
    NSString *path = [NSString stringWithFormat:@"blog/articles/%@", articleID];
    [[PIXAPIHandler new] callAPI:path httpMethod:@"GET" shouldAuth:needAuth parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSError *jsonError;
            NSDictionary *dictionary1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&jsonError];
            if (jsonError) {
                completion(NO, nil, jsonError);
                return;
            }
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[dictionary1 PIXDictionaryByReplacingNullsWithBlanks]];
            NSMutableString *htmlString = [NSMutableString stringWithString:dictionary[@"article"][@"body"]];
            //將 read more 的註解轉成圖片
            [htmlString replaceOccurrencesOfString:kReadMoreSymbolString withString:kReadMoreHTMLString options:NSCaseInsensitiveSearch range:NSMakeRange(0, htmlString.length)];
            NSMutableDictionary *articleDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary[@"article"]];
            articleDictionary[@"body"] = htmlString;
            dictionary[@"article"] = articleDictionary;
            completion(succeed, dictionary, error);
        } else {
            completion(succeed, nil, error);
        }
    }];
}

- (void)getBlogRelatedArticleByArticleID:(NSString *)articleID
                                userName:(NSString *)userName
                                withBody:(BOOL)withBody
                            relatedLimit:(NSUInteger)limit
                              completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing User Name"]);
        return;
    }
    if (articleID == nil || articleID.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Article ID"]);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"user"] = userName;
    if (limit > 0) {
        params[@"limit"] = [NSString stringWithFormat:@"%lu", (unsigned long)limit];
    }
    params[@"with_body"] = [NSString stringWithFormat:@"%i", withBody];

    NSString *path = [NSString stringWithFormat:@"blog/articles/%@/related", articleID];
    [[PIXAPIHandler new] callAPI:path parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
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
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing User Name"]);
        return;
    }
    if (articleID == nil || articleID.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Article ID"]);
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
               requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
}

- (void)getBlogLatestArticleWithUserName:(NSString *)userName
                            blogPassword:(NSString *)blogPassword
                                   limit:(NSUInteger)limit
                                trimUser:(BOOL)trimUser
                               thumbSize:(ThumbSize)thumbSize
                              completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing User Name"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];

    params[@"user"] = userName;
    if (blogPassword && blogPassword.length>0) {
        params[@"blog_password"] = blogPassword;
    }
    params[@"limit"] = [NSString stringWithFormat:@"%lu", (unsigned long)limit];
    params[@"trim_user"] = [NSString stringWithFormat:@"%i", trimUser];
    params = [self getThumbSizeParams:thumbSize params:params];
    [[PIXAPIHandler new] callAPI:@"blog/articles/latest"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];

}

- (void)getBlogHotArticleWithUserName:(NSString *)userName password:(NSString *)passwd fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate limit:(NSUInteger)limit trimUser:(BOOL)trimUser thumbSize:(ThumbSize)thumbSize completion:(PIXHandlerCompletion)completion {
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing User Name"]);
        return;
    }
    if ((fromDate && !toDate) || (!fromDate && toDate)) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"fromDate 與 toDate 為成對參數，兩者必須同時有值或同時為 nil"]);
        return;
    }
    if (([fromDate compare:toDate] != NSOrderedAscending) && (fromDate && toDate)) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"fromDate 一定要早於 toDate"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];

    params[@"user"] = userName;

    if (passwd || passwd.length >0 || passwd !=nil ) {
        params[@"blog_password"] = passwd;
    }
    params[@"limit"] = [NSString stringWithFormat:@"%lu", (unsigned long)limit];
    params[@"trim_user"] = [NSString stringWithFormat:@"%i", trimUser];
    params = [self getThumbSizeParams:thumbSize params:params];
    NSMutableString *pathString = [NSMutableString stringWithString:@"blog/articles/hot"];
    if (fromDate && toDate) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyyMMdd";
        [pathString appendFormat:@"/%@-%@", [formatter stringFromDate:fromDate], [formatter stringFromDate:toDate]];
    }
    [[PIXAPIHandler new] callAPI:pathString
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
}

- (void)getblogSearchArticleWithKeyword:(NSString *)keyword
                               userName:(NSString *)userName
                             searchType:(PIXArticleSearchType)searchType
                                   page:(NSUInteger)page
                                perPage:(NSUInteger)perPage
                              thumbSize:(ThumbSize)thumbSize
                             completion:(PIXHandlerCompletion)completion{

    if (keyword == nil || keyword.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Search String"]);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary new];

    params[@"key"] = keyword;

    if (userName && userName.length > 0) {
        params[@"user"] = userName;
    } else {
        params[@"site"] = @"true";
    }
    switch (searchType) {
        case PIXArticleSearchTypeTag:
            params[@"type"] = @"tag";
            break;
        case PIXArticleSearchTypeKeyword:
            params[@"type"] = @"keyword";
            break;
        default:
            break;
    }
    if (page) {
        params[@"page"] = [NSString stringWithFormat:@"%lu", (unsigned long)page];
    }

    if (perPage) {
        params[@"per_page"] = [NSString stringWithFormat:@"%lu", (unsigned long)perPage];
    }
    params = [self getThumbSizeParams:thumbSize params:params];

    [[PIXAPIHandler new] callAPI:@"blog/articles/search"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];

}
#pragma mark Article method need access token
- (void)createBlogArticleWithTitle:(NSString *)title
                              body:(NSString *)body
                            status:(PIXArticleStatus)status
                          publicAt:(NSDate *)date
                    userCategoryID:(NSString *)userCategoryId
                    siteCategoryID:(NSString *)cateID
                 subSiteCategoryID:(NSString *)subCateID
                    useNewLineToBR:(BOOL)useNewLineToBR
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
                       notifyPlurk:(BOOL)notifyPlurk
                             cover:(NSString *)cover
                        completion:(PIXHandlerCompletion)completion{
    [self createOrUpdateBlogArticleWithAPIPath:@"blog/articles"
                                     articleID:nil
                                         title:title
                                          body:body
                                        status:status
                                      publicAt:date
                                userCategoryID:userCategoryId
                                siteCategoryID:cateID
                             subSiteCategoryID:subCateID
                                useNewLineToBR:useNewLineToBR
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
                                   notifyPlurk:notifyPlurk
                                         cover:cover
                                    completion:completion];
}
/*
 * 由於 create 及 update article 的參數都一樣，所以用這個 method 合併處理
 */
- (void)createOrUpdateBlogArticleWithAPIPath:(NSString *)path
                                   articleID:(NSString *)articleId
                                       title:(NSString *)title
                                        body:(NSString *)body
                                      status:(PIXArticleStatus)status
                                    publicAt:(NSDate *)date
                              userCategoryID:(NSString *)userCategoryId
                              siteCategoryID:(NSString *)cateID
                           subSiteCategoryID:(NSString *)subCateID
                              useNewLineToBR:(BOOL)useNewLineToBR
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
                                 notifyPlurk:(BOOL)notifyPlurk
                                       cover:(NSString *)cover
                                  completion:(PIXHandlerCompletion)completion{
    BOOL isCreating = [path isEqualToString:@"blog/articles"];

    if (isCreating && (title == nil || title.length == 0)) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Article Title"]);
        return;
    }
    if (isCreating && (body == nil || body.length == 0)) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Article Body"]);
        return;
    }
    if (!isCreating && (articleId==nil || articleId.length==0)) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Article Id"]);
        return;
    }

    if (status == PIXArticleStatusPassword) {
        if (passwd == nil || passwd.length == 0) {
            completion(NO, nil, [NSError PIXErrorWithParameterName:@"請輸入欲設定之文章密碼"]);
            return;
        }else if (passwdHint == nil || passwdHint.length == 0){
            completion(NO, nil, [NSError PIXErrorWithParameterName:@"請輸入欲設定文章密碼提示"]);
            return;
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (title && title.length>0) {
        params[@"title"] = title;
    }
    if (body && body.length>0) {
        params[@"body"] = body;
    }

    params[@"status"] = [NSString stringWithFormat:@"%li", (long)status];

    if (date) {
        params[@"public_at"] = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
    }

    if (userCategoryId!=nil && userCategoryId.length>0) {
        params[@"category_id"] = userCategoryId;
    }
    if (cateID!=nil && cateID.length>0) {
        params[@"site_category_id"] = cateID;
    }
    if (subCateID!=nil && subCateID.length>0) {
        if ([subCateID isEqualToString:cateID]) {
            completion(NO, nil, [NSError PIXErrorWithParameterName:@"文章設定的全站分類不可相同"]);
            return;
        }
        params[@"sub_site_category_id"] = subCateID;
    }
    params[@"use_nl2br"] = [NSString stringWithFormat:@"%i", useNewLineToBR];

    params[@"comment_perm"] = [NSString stringWithFormat:@"%li", (long)commentPerm];;

    params[@"comment_hidden"] = [NSString stringWithFormat:@"%i", commentHidden];

    if (tagArray) {
        for (id value in tagArray) {
            if (![value isKindOfClass:[NSString class]]) {
                completion(NO, nil, [NSError PIXErrorWithParameterName:@"tagArray 裡的每個值都一定要是 NSString 物件"]);
                return;
            }
        }
        params[@"tags"] = [tagArray componentsJoinedByString:@","];
    }
    if (thumburl && thumburl.length!=0) {
        params[@"thumb"] = thumburl;
    }
    if (trackback && trackback.count>0) {
        for (id value in trackback) {
            if (![value isKindOfClass:[NSString class]]) {
                completion(NO, nil, [NSError PIXErrorWithParameterName:@"trackback 裡每一個值都一定要是 NSString 物件"]);
                return;
            }
        }
        params[@"trackback"] = [trackback componentsJoinedByString:@" "];
    }
    if (status == PIXArticleStatusPassword) {
        params[@"password"] = passwd;
        params[@"password_hint"] = passwdHint;
    }

    if (status == PIXArticleStatusFriend && friendGroupID) {
        params[@"friend_group_ids"] = friendGroupID;
    }
    if ((int)notifyTwitter >= 0) {
        params[@"notify_twitter"] = [NSString stringWithFormat:@"%i", notifyTwitter];
    }
    if ((int)notifyFacebook >= 0) {
        params[@"notify_facebook"] = [NSString stringWithFormat:@"%i", notifyFacebook];
    }
    if ((int)notifyPlurk >= 0) {
        params[@"notify_plurk"] = [NSString stringWithFormat:@"%i", notifyPlurk];
    }
    if (cover) {
        params[@"cover"] = cover;
    }
    [[PIXAPIHandler new] callAPI:path httpMethod:@"POST" shouldAuth:YES shouldExecuteInBackground:NO uploadData:nil parameters:params timeoutInterval:20 requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}
- (void)updateBlogArticleWithArticleID:(NSString *)articleID
                                 title:(NSString *)title
                                  body:(NSString *)body
                                status:(PIXArticleStatus)status
                              publicAt:(NSDate *)date
                        userCategoryID:(NSString *)userCategoryId
                        siteCategoryID:(NSString *)cateID
                     subSiteCategoryID:(NSString *)subCateID
                        useNewLineToBR:(BOOL)useNewLineToBR
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
                           notifyPlurk:(BOOL)notifyPlurk
                                 cover:(NSString *)cover
                            completion:(PIXHandlerCompletion)completion{
    if (articleID==nil || articleID.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Article ID"]);
        return;
    }
    [self createOrUpdateBlogArticleWithAPIPath:[NSString stringWithFormat:@"blog/articles/%@", articleID]
                                     articleID:articleID
                                         title:title
                                          body:body
                                        status:status
                                      publicAt:date
                                userCategoryID:userCategoryId
                                siteCategoryID:cateID
                             subSiteCategoryID:subCateID
                                useNewLineToBR:useNewLineToBR
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
                                   notifyPlurk:notifyPlurk
                                         cover:cover
                                    completion:completion];
}

- (void)deleteBlogArticleByArticleID:(NSString *)articleID
                          completion:(PIXHandlerCompletion)completion{

    if (articleID == nil || articleID.length == 0 || !articleID) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Article ID"]);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"_method"] = @"delete";

    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blog/articles/%@", articleID]
                      httpMethod:@"POST"
                      shouldAuth:YES
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
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
                       blogPassword:(NSString *)blogPassword
                    articlePassword:(NSString *)articlePassword
                             filter:(PIXBlogCommentFilterType)filter
                    isSortAscending:(BOOL)isSortAscending
                               page:(NSUInteger)page
                            perPage:(NSUInteger)perPage
                         completion:(PIXHandlerCompletion)completion{

    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing User Name"]);
        return;
    }
    //    if (articleID == nil || articleID.length == 0) {
    //        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing articleId"]);
    //        return;
    //    }
    if (page<=0 || perPage<=0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"page 及 perPage 都一定要大於0"]);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary new];

    params[@"user"] = userName;
    if (articleID) {
        params[@"article_id"] = articleID;
    }
    if (blogPassword) {
        params[@"blog_password"] = blogPassword;
    }
    if (articlePassword) {
        params[@"article_password"] = articlePassword;
    }
    switch (filter) {
        case PIXBlogCommentFilterTypeNoReply:
            params[@"filter"] = @"noreply";
            break;
        case PIXBlogCommentFilterTypeWhisper:
            params[@"filter"] = @"whisper";
            break;
        case PIXBlogCommentFilterTypeNoSpam:
            params[@"filter"] = @"nospam";
            break;
        default:
            break;
    }
    if (isSortAscending) {
        params[@"sort"] = @"date-posted-asc";
    } else {
        params[@"sort"] = @"date-posted-desc";
    }
    params[@"page"] = [NSString stringWithFormat:@"%lu", (unsigned long)page];
    params[@"per_page"] = [NSString stringWithFormat:@"%lu", (unsigned long)perPage];

    BOOL shouldAuthed = ([PIXAPIHandler isConsumerKeyAndSecretAssigned]&&[PIXAPIHandler isAuthed]);
    [[PIXAPIHandler new] callAPI:@"blog/comments" httpMethod:@"GET" shouldAuth:shouldAuthed parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}

- (void)getBlogSingleCommentWithUserName:(NSString *)userName
                              commmentID:(NSString *)commentID
                              completion:(PIXHandlerCompletion)completion{
    if (userName == nil || userName.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing User Name"]);
        return;
    }

    if (commentID == nil || commentID.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Comment ID"]);
        return;
    }
    
    //已設定ConsumerKey且已取得token
    BOOL shouldAuthed = ([PIXAPIHandler isConsumerKeyAndSecretAssigned]&&[PIXAPIHandler isAuthed]);
    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blog/comments/%@", commentID] httpMethod:@"GET" shouldAuth:shouldAuthed parameters:@{@"user": userName} requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}

- (void)getBlogLatestCommentWithUserName:(NSString *)userName
                              completion:(PIXHandlerCompletion)completion{

    if (userName==nil || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName 參數有誤"]);
        return;
    }
    
    //已設定ConsumerKey且已取得token
    BOOL shouldAuthed = ([PIXAPIHandler isConsumerKeyAndSecretAssigned]&&[PIXAPIHandler isAuthed]);
    [[PIXAPIHandler new] callAPI:@"blog/comments/latest" httpMethod:@"GET" shouldAuth:shouldAuthed parameters:@{@"user": userName} requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}
#pragma mark Comment Method need access token

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

    if (articleID == nil || articleID.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Article ID"]);
        return;
    }
    if (body == nil || body.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Comment Body"]);
        return;
    }
    if (userName==nil || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing userName"]);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"article_id"] = articleID;
    params[@"body"] = body;
    params[@"user"] = userName;

    if (author != nil && author.length != 0) {
        params[@"author"] = author;
    }

    if (title != nil && title.length != 0) {
        params[@"title"] = title;
    }

    if (url != nil && url.length != 0) {
        params[@"url"] = url;
    }

    params[@"is_open"] = [NSString stringWithFormat:@"%i", isOpen];

    if (email != nil && email.length != 0) {
        params[@"email"] = email;
    }

    if (blogPasswd != nil && blogPasswd.length != 0) {
        params[@"blog_password"] = blogPasswd;
    }

    if (articlePasswd != nil && articlePasswd.length != 0) {
        params[@"article_password"] = articlePasswd;
    }

    [[PIXAPIHandler new] callAPI:@"blog/comments"
                      httpMethod:@"POST"
                      shouldAuth:YES
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
}

- (void)replyBlogCommentWithCommnetID:(NSString *)commentID
                                 body:(NSString *)body
                           completion:(PIXHandlerCompletion)completion{
    if (commentID == nil || commentID.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Comment ID"]);
        return;
    }

    if (body == nil || body.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Comment Body"]);
        return;
    }

    NSDictionary *params = @{@"body": body};

    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blog/comments/%@/reply", commentID]
                      httpMethod:@"POST"
                      shouldAuth:YES
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];
}


- (void)updateBlogCommentOpenWithCommentID:(NSString *)commentID
                                    isOpen:(BOOL)isOpen
                                completion:(PIXHandlerCompletion)completion{
    if (commentID == nil || commentID.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Comment ID"]);
        return;
    }
    NSString *isOpenString = nil;

    if (isOpen) {
        isOpenString = @"open";
    }else{
        isOpenString = @"close";
    }

    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blog/comments/%@/%@", commentID, isOpenString]
                      httpMethod:@"POST"
                      shouldAuth:YES
                      parameters:nil
               requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];

}


- (void)updateBlogCommentsOpenWithComments:(NSArray *)comments isOpen:(BOOL)isOpen completion:(PIXHandlerCompletion)completion {
    if (comments.count < 1 || !comments) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"There is nothing in comments"]);
        return;
    }
    for (id o in comments) {
        if (![o isKindOfClass:[NSString class]]) {
            completion(NO, nil, [NSError PIXErrorWithParameterName:@"elements in comments should be string."]);
            return;
        }
    }
    NSString *statusString = @"close";
    if (isOpen) {
        statusString = @"open";
    }
    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blog/comments/%@/%@", [comments componentsJoinedByString:@","], statusString] httpMethod:@"POST" shouldAuth:YES parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}

- (void)updateBlogCommentSpamWithCommentID:(NSString *)commentID
                                    isSpam:(BOOL)isSpam
                                completion:(PIXHandlerCompletion)completion{

    if (commentID == nil || commentID.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Comment ID"]);
        return;
    }

    NSString *isSpamString = nil;

    if (isSpam) {
        isSpamString = @"mark_spam";
    }else{
        isSpamString = @"mark_ham";
    }

    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blog/comments/%@/%@", commentID, isSpamString]
                      httpMethod:@"POST"
                      shouldAuth:YES
                      parameters:nil
               requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];

}

- (void)updateBlogCommentsSpamWithComments:(NSArray *)comments isSpam:(BOOL)isSpam completion:(PIXHandlerCompletion)completion {
    if (comments.count < 1 || !comments) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"There is nothing in comments"]);
        return;
    }
    for (id o in comments) {
        if (![o isKindOfClass:[NSString class]]) {
            completion(NO, nil, [NSError PIXErrorWithParameterName:@"elements in comments should be string."]);
            return;
        }
    }
    NSString *statusString = @"mark_ham";
    if (isSpam) {
        statusString = @"mark_spam";
    }
    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blog/comments/%@/%@", [comments componentsJoinedByString:@","], statusString] httpMethod:@"POST" shouldAuth:YES parameters:nil requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}

- (void)deleteBlogCommentWithCommentID:(NSString *)commentID
                            completion:(PIXHandlerCompletion)completion{

    if (commentID == nil || commentID.length == 0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"Missing Comment ID"]);
        return;
    }

    NSDictionary *params = @{@"_method":@"delete"};

    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blog/comments/%@", commentID]
                      httpMethod:@"POST"
                      shouldAuth:YES
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
                       completion(NO, nil, errorMessage);
                   }
               }];
}

- (void)deleteBlogComments:(NSArray *)comments completion:(PIXHandlerCompletion)completion {
    for (id o in comments) {
        if (![o isKindOfClass:[NSString class]]) {
            completion(NO, nil, [NSError PIXErrorWithParameterName:[NSString stringWithFormat:@"%@ should be string", o]]);
            return;
        }
    }
    NSDictionary *params = @{@"_method" : @"delete"};
    NSString *commentsString = [comments componentsJoinedByString:@","];
    [[PIXAPIHandler new] callAPI:[NSString stringWithFormat:@"blog/comments/%@", commentsString] httpMethod:@"POST" shouldAuth:YES parameters:params requestCompletion:^(BOOL succeed, id result, NSError *error) {
        [self resultHandleWithIsSucceed:succeed result:result error:error completion:completion];
    }];
}


#pragma mark - Site Blog Categories list

- (void)getBlogCategoriesListIncludeGroups:(BOOL)group
                                    thumbs:(BOOL)thumb
                                completion:(PIXHandlerCompletion)completion{

    NSMutableDictionary *params = [NSMutableDictionary new];

    params[@"include_groups"] = [NSString stringWithFormat:@"%i", group];
    params[@"include_thumbs"] = [NSString stringWithFormat:@"%i", thumb];

    [[PIXAPIHandler new] callAPI:@"blog/site_categories"
                      parameters:params
               requestCompletion:^(BOOL succeed, id result, NSError *errorMessage) {
                   if (succeed) {
                       [self succeedHandleWithData:result completion:completion];
                   } else {
                       completion(NO, nil, errorMessage);
                   }
               }];

}

#pragma mark - Get ThumbSize Params

-(NSMutableDictionary *)getThumbSizeParams:(ThumbSize)thumbSize params:(NSMutableDictionary *)params {
    
    switch (thumbSize) {
        case ThumbSizeWith60:
            params[@"thumb_size"] = @"60";
            break;
        case ThumbSizeWith90:
            params[@"thumb_size"] = @"90";
            break;
        case ThumbSizeWith100:
            params[@"thumb_size"] = @"100";
            break;
        case ThumbSizeWith320:
            params[@"thumb_size"] = @"320";
            break;
        case ThumbSizeWith640:
            params[@"thumb_size"] = @"640";
            break;
        case ThumbSizeWith960:
            params[@"thumb_size"] = @"960";
            break;
            
        default:
            params[@"thumb_size"] = [NSNumber numberWithInt:90];
            break;
    }
    
    return params;
}

@end
