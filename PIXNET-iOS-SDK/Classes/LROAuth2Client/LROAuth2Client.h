//
//  LROAuth2Client.h
//  LROAuth2Client
//
//  Created by Luke Redpath on 14/05/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LROAuth2ClientDelegate.h"

@class LROAuth2AccessToken;

@interface LROAuth2Client : NSObject {
    //  NSString *clientID;
    //  NSString *clientSecret;
    //  NSURL *cancelURL;
    //  NSURL *userURL;
    //  NSURL *tokenURL;
    //  LROAuth2AccessToken *accessToken;
    //  NSMutableArray *requests;
    
//    BOOL debug;
    
@private
    BOOL isVerifying;
}
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *clientSecret;
@property (nonatomic, strong) NSURL *redirectURL;
@property (nonatomic, strong) NSURL *cancelURL;
@property (nonatomic, strong) NSURL *userURL;
@property (nonatomic, strong) NSURL *tokenURL;
@property (nonatomic, strong) NSMutableArray *requests;
@property (nonatomic, strong) LROAuth2AccessToken *accessToken;
@property (nonatomic, weak) id<LROAuth2ClientDelegate> delegate;
@property (nonatomic, weak) id<UIWebViewDelegate> webViewDelegate;
@property (nonatomic, assign) BOOL debug;

- (id)initWithClientID:(NSString *)clientID
                secret:(NSString *)secret
           redirectURL:(NSURL *)url;

- (NSURLRequest *)userAuthorizationRequestWithParameters:(NSDictionary *)additionalParameters;
- (void)verifyAuthorizationWithAccessCode:(NSString *)accessCode;
- (void)refreshAccessToken:(LROAuth2AccessToken *)__accessToken;
@end

@interface LROAuth2Client (UIWebViewIntegration) <UIWebViewDelegate>
- (void)authorizeUsingWebView:(UIWebView *)webView;
- (void)authorizeUsingWebView:(UIWebView *)webView additionalParameters:(NSDictionary *)additionalParameters;
- (void)extractAccessCodeFromCallbackURL:(NSURL *)url;
@end
