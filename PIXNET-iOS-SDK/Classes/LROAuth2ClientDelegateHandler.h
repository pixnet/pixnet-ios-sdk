//
//  LROAuth2ClientDelegateHandler.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/24/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
#import "LROAuth2AccessToken.h"
#import <Foundation/Foundation.h>
#import "LROAuth2Client.h"

typedef void (^PIXGetOAuth2AccessTokenCompletion)(BOOL succeed, LROAuth2AccessToken *accessToken, NSError *error);
typedef NSString *(^PIXRefreshOAuth2AccessTokenCompletion)(BOOL succeed, LROAuth2AccessToken *accessToken, NSError *error);

@interface LROAuth2ClientDelegateHandler : NSObject<LROAuth2ClientDelegate>
-(instancetype)initWithOAuth2Completion:(PIXGetOAuth2AccessTokenCompletion)completion;
@end
