//
//  LROAuth2ClientDelegateHandler.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/24/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
typedef void (^PIXGetOAuth2AccessTokenCompletion)(BOOL succeed, NSString *token, NSError *error);

#import <Foundation/Foundation.h>
#import <LROAuth2Client.h>

@interface LROAuth2ClientDelegateHandler : NSObject<LROAuth2ClientDelegate>
-(instancetype)initWithOAuth2Completion:(PIXGetOAuth2AccessTokenCompletion)completion;
@end
