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
- (void)getBlogInformationWithUserID:(NSString *)userID completion:(RequestCompletion)completion;
@end
