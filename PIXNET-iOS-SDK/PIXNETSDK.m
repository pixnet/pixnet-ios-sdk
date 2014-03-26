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
+(void)setConsumerKey:(NSString *)aKey consumerSecrect:(NSString *)aSecrect{
    [PIXAPIHandler setConsumerKey:aKey consumerSecrect:aSecrect];
}
+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password completion:(RequestCompletion)completion{
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
- (void)getBlogInformationWithUserID:(NSString *)userID completion:(RequestCompletion)completion{
    [[PIXBlog new] getBlogInformationWithUserID:userID completion:completion];
}

- (void)getBlogCategoriesWithUserID:(NSString *)userID andPassword:(NSString *)passwd completion:(RequestCompletion)completion{

}
@end
