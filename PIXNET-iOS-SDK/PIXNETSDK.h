//
//  PIXNETSDK.h
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/3/13.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//


#import <Foundation/Foundation.h>
@class PIXBlog;
#import "PIXAPIHandler.h"
#import "PIXAlbum.h"

@interface PIXNETSDK : NSObject

+(void)setConsumerKey:(NSString *)aKey consumerSecrect:(NSString *)aSecrect;
+(instancetype)sharedInstance;
//Blog Method

/**
 *  取得部落格資訊
 *
 *  @param userID 痞客邦帳號
 *
 *  @return 該部落格的基本資訊
 */
- (void)getBlogInformationWithUserID:(NSString *)userID completion:(RequestCompletion)completion;


@end
