//
//  LROAuth2ClientDelegateHandler.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/24/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "LROAuth2ClientDelegateHandler.h"
#import "NSError+PIXCategory.h"

@interface LROAuth2ClientDelegateHandler()
@property (nonatomic, copy) PIXGetOAuth2AccessTokenCompletion getTokenCompletion;

@end

@implementation LROAuth2ClientDelegateHandler
-(instancetype)initWithOAuth2Completion:(PIXGetOAuth2AccessTokenCompletion)completion{
    self = [super init];
    if (self) {
        _getTokenCompletion = completion;
    }
    return self;
}
- (void)oauthClientDidReceiveAccessToken:(LROAuth2Client *)client{
    _getTokenCompletion(YES, client.accessToken, nil);
}
- (void)oauthClientDidRefreshAccessToken:(LROAuth2Client *)client{
    _getTokenCompletion(YES, client.accessToken, nil);
}
- (void)oauthClientDidReceiveAccessCode:(LROAuth2Client *)client{

}

- (void)oauthClientDidCancel:(LROAuth2Client *)client request:(NSURLRequest *)request{
    NSString *queryString = [request.URL query];
    if ([queryString hasPrefix:@"error"]) {
        _getTokenCompletion(NO, nil, [NSError PIXErrorWithParameterName:queryString]);
    } else {
        _getTokenCompletion(NO, nil, [NSError PIXErrorWithParameterName:@"login failed"]);
    }
}

@end
