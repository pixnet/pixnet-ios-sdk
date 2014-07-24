//
//  PIXAPIHandler.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//
static const NSString *kConsumerKey;
static const NSString *kConsumerSecret;
static const NSString *kCallbackURL;

#import "PIXAPIHandler.h"
#import <GCOAuth.h>
#import "NSMutableURLRequest+PIXCategory.h"
#import "PIXCredentialStorage.h"
#import "NSError+PIXCategory.h"
#import "LROAuth2Client.h"
#import "LROAuth2AccessToken.h"
#import "LROAuth2ClientDelegateHandler.h"
#import "NSDictionary+QueryString.h"
#import "PIXURLSessionDelegateHandler.h"

static const NSString *kApiURLPrefix = @"https://emma.pixnet.cc/";
static const NSString *kApiURLHost = @"emma.pixnet.cc";

static const NSString *kUserNameIdentifier = @"kUserNameIdentifier";
static const NSString *kUserPasswordIdentifier = @"kUserPasswordIdentifier";
static const NSString *kOauthTokenIdentifier = @"kOauthTokenIdentifier";
static const NSString *kOauthTokenSecretIdentifier = @"kOauthTokenSecretIdentifier";
static NSString *kAuthTypeKey = @"kAuthTypeKey";
//static PIXAuthType authType;

@interface PIXAPIHandler ()
@property (nonatomic, strong) NSDictionary *paramForXAuthRequest;
@property (nonatomic, strong) LROAuth2Client *oauth2Client;
@property (nonatomic, strong) LROAuth2ClientDelegateHandler *oauth2ClientDelegateHandler;
@property (nonatomic, copy) PIXHandlerCompletion getOAuth2AccessTokenCompletion;

@end

@implementation PIXAPIHandler

+(instancetype)sharedInstance{
    static PIXAPIHandler *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PIXAPIHandler alloc] init];
        sharedInstance.oauth2Client = [[LROAuth2Client alloc] initWithClientID:[kConsumerKey copy]
                                                                        secret:[kConsumerSecret copy]
                                                                   redirectURL:[NSURL URLWithString:[kCallbackURL copy]]];
        sharedInstance.oauth2Client.userURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth2/authorize", kApiURLPrefix]];
        sharedInstance.oauth2Client.tokenURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth2/grant", kApiURLPrefix]];
        sharedInstance.oauth2ClientDelegateHandler = [[LROAuth2ClientDelegateHandler alloc] initWithOAuth2Completion:^(BOOL succeed, LROAuth2AccessToken *accessToken, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (succeed) {
                    [[NSUserDefaults standardUserDefaults] setInteger:PIXAuthTypeOAuth2 forKey:kAuthTypeKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [NSKeyedArchiver archiveRootObject:accessToken toFile:[PIXAPIHandler filePathForOAuth2AccessToken]];
                    sharedInstance.getOAuth2AccessTokenCompletion(YES, accessToken.accessToken, nil);
                    return;
                } else {
                    sharedInstance.getOAuth2AccessTokenCompletion(NO, nil, error);
                    return;
                }
            });
        }];
        sharedInstance.oauth2Client.delegate = sharedInstance.oauth2ClientDelegateHandler;
    });
    return sharedInstance;
}

+(void)setConsumerKey:(NSString *)aKey consumerSecret:(NSString *)aSecret{
    kConsumerKey = [aKey copy];
    kConsumerSecret = [aSecret copy];
}
+(void)setConsumerKey:(NSString *)aKey consumerSecret:(NSString *)aSecret callbackURL:(NSString *)callbackURL{
    kConsumerKey = [aKey copy];
    kConsumerSecret = [aSecret copy];
    kCallbackURL = [callbackURL copy];
}
+(BOOL)isConsumerKeyAndSecrectAssigned{
    BOOL assigned = YES;
    if (kConsumerKey == nil || kConsumerSecret == nil) {
        assigned = NO;
    }
    return assigned;
}

+(void)logout{
    PIXAuthType authType = [[NSUserDefaults standardUserDefaults] integerForKey:kAuthTypeKey];
    switch (authType) {
        case PIXAuthTypeXAuth:{
            [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:[kOauthTokenIdentifier copy]];
            [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:[kOauthTokenSecretIdentifier copy]];
            [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:[kUserNameIdentifier copy]];
            [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:[kUserPasswordIdentifier copy]];
            break;
        }
        case PIXAuthTypeOAuth2:{
            [[NSFileManager defaultManager] removeItemAtPath:[PIXAPIHandler filePathForOAuth2AccessToken] error:nil];
            break;
        }
        default:
            break;
    }
    //將目前的登入狀態改為 undefined
    [[NSUserDefaults standardUserDefaults] setInteger:PIXAuthTypeUndefined forKey:kAuthTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)authByOAuth2WithLoginView:(UIWebView *)loginView completion:(PIXHandlerCompletion)completion{
    [self loginByOAuth2WithLoginView:loginView completion:completion];
}
+(void)loginByOAuth2WithLoginView:(UIWebView *)loginView completion:(PIXHandlerCompletion)completion{
    if (kConsumerSecret==nil || kConsumerKey==nil || kCallbackURL==nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"consumer key、consumer secret 或 callbackURL 尚未設定"]);
        return;
    }
    PIXAPIHandler *singleton = [PIXAPIHandler sharedInstance];
    singleton.getOAuth2AccessTokenCompletion = completion;
//    if (singleton.oauth2ClientDelegateHandler == nil) {
//        singleton.oauth2ClientDelegateHandler = [[LROAuth2ClientDelegateHandler alloc] initWithOAuth2Completion:^(BOOL succeed, LROAuth2AccessToken *accessToken, NSError *error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (succeed) {
//                    [[NSUserDefaults standardUserDefaults] setInteger:PIXAuthTypeOAuth2 forKey:kAuthTypeKey];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    [NSKeyedArchiver archiveRootObject:accessToken toFile:[PIXAPIHandler filePathForOAuth2AccessToken]];
//                    completion(YES, accessToken.accessToken, nil);
//                    return;
//                } else {
//                    completion(NO, nil, error);
//                    return;
//                }
//            });
//        }];
//        //如果外部開發者有承做 UIWebViewDelegate，就將該 webView delegate 丟給 oauth2Client.webViewDelegate 處理
//        if (loginView.delegate) {
//            singleton.oauth2Client.webViewDelegate = loginView.delegate;
//        }
//        singleton.oauth2Client.delegate = singleton.oauth2ClientDelegateHandler;
//    }
    
    //先檢查是否已有之前已存下來的 token
    LROAuth2AccessToken *storedToken = [NSKeyedUnarchiver unarchiveObjectWithFile:[PIXAPIHandler filePathForOAuth2AccessToken]];
    if (storedToken) {
        [[NSUserDefaults standardUserDefaults] setInteger:PIXAuthTypeOAuth2 forKey:kAuthTypeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"已有使用者登入中，若要讓另一使用者登入，請先執行 +logout"]);
        return;
        /*
         if ([storedToken hasExpired]) {
         [singleton.oauth2Client refreshAccessToken:storedToken];
         return;
         } else {
         completion(YES, storedToken.accessToken, nil);
         return;
         }
         */
    } else {
        [singleton.oauth2Client authorizeUsingWebView:loginView];
    }
}
+(NSString *)filePathForOAuth2AccessToken{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask ,YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *path = [documentsDir stringByAppendingPathComponent:@"oauth2token"];
    return path;
}
+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password requestCompletion:(PIXHandlerCompletion)completion{
    //檢查是否已設定 consumer key 及 consumer secret
    if (kConsumerSecret==nil || kConsumerKey==nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"consumer key 或 consumer secret 尚未設定"]);
        return;
    }

    NSString *localUser = [[PIXCredentialStorage sharedInstance] stringForIdentifier:[kUserNameIdentifier copy]];
    NSString *localPassword = [[PIXCredentialStorage sharedInstance] stringForIdentifier:[kUserPasswordIdentifier copy]];
    if ((localUser!=nil && ![localUser isEqualToString:userName]) || (localPassword!=nil && ![localPassword isEqualToString:password])) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"前一個使用者尚未登出，請先執行 +logout"]);
        return;
    }
    [[PIXCredentialStorage sharedInstance] storeStringForIdentifier:[kUserNameIdentifier copy] string:userName];
    [[PIXCredentialStorage sharedInstance] storeStringForIdentifier:[kUserPasswordIdentifier copy] string:password];

    //如果 local 端已有 token 就不再去跟後台要
    NSString *token = [[PIXCredentialStorage sharedInstance] stringForIdentifier:[kOauthTokenIdentifier copy]];
    NSString *secret = [[PIXCredentialStorage sharedInstance] stringForIdentifier:[kOauthTokenSecretIdentifier copy]];

    if (token && secret) {
        [[NSUserDefaults standardUserDefaults] setInteger:PIXAuthTypeXAuth forKey:kAuthTypeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        completion(YES, token, nil);
        return;
    }

    NSURLRequest *request = [self requestForXAuthWithPath:@"oauth/access_token" parameters:nil httpMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (connectionError) {
                completion(NO, nil, connectionError);
                return;
            } else {
                NSHTTPURLResponse *hur = (NSHTTPURLResponse *)response;
                if (hur.statusCode != 200) {
                    completion(NO, nil, [NSError PIXErrorWithHTTPStatusCode:hur.statusCode]);
                    return;
                } else {
                    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSArray *array = [dataString componentsSeparatedByString:@"&"];
                    for (NSString *string in array) {
                        NSArray *array0 = [string componentsSeparatedByString:@"="];
                        if ([array0[0] isEqualToString:@"oauth_token"]) {
                            [[PIXCredentialStorage sharedInstance] storeStringForIdentifier:[kOauthTokenIdentifier copy] string:array0[1]];
                        }
                        if ([array0[0] isEqualToString:@"oauth_token_secret"]) {
                            [[PIXCredentialStorage sharedInstance] storeStringForIdentifier:[kOauthTokenSecretIdentifier copy] string:array0[1]];
                        }
                    }
                    [[NSUserDefaults standardUserDefaults] setInteger:PIXAuthTypeXAuth forKey:kAuthTypeKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    completion(YES, nil, nil);
                    return;
                }
            }
        });
    }];
}
+(BOOL)isAuthed{
    BOOL authed = NO;
    PIXAuthType authType = [[NSUserDefaults standardUserDefaults] integerForKey:kAuthTypeKey];
    switch (authType) {
        case PIXAuthTypeXAuth:{
            NSString *token = [[PIXCredentialStorage sharedInstance] stringForIdentifier:[kOauthTokenIdentifier copy]];
            NSString *secret = [[PIXCredentialStorage sharedInstance] stringForIdentifier:[kOauthTokenSecretIdentifier copy]];
            if (token && secret) {
                authed = YES;
            }
            break;
        }
        case PIXAuthTypeOAuth2:{
            LROAuth2AccessToken *storedToken = [NSKeyedUnarchiver unarchiveObjectWithFile:[PIXAPIHandler filePathForOAuth2AccessToken]];
            if (storedToken) {
                authed = YES;
            }
            break;
        }
        default:
            break;
    }
    return authed;
}
-(void)callAPI:(NSString *)apiPath parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    [self callAPI:apiPath httpMethod:@"GET" parameters:parameters requestCompletion:completion];
}

-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:NO parameters:parameters requestCompletion:completion];
}

-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:shouldAuth uploadData:nil parameters:parameters requestCompletion:completion];
}
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth uploadData:(NSData *)uploadData parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:shouldAuth shouldExecuteInBackground:NO uploadData:uploadData parameters:parameters requestCompletion:completion];
}
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuthObj:(NSNumber *)shouldAuth uploadData:(NSData *)uploadData parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:[shouldAuth boolValue] shouldExecuteInBackground:NO uploadData:uploadData parameters:parameters requestCompletion:completion];
}
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth shouldExecuteInBackground:(BOOL)backgroundExec uploadData:(NSData *)uploadData parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    if (shouldAuth) {
        if (kConsumerKey == nil) {
            completion(NO, nil, [NSError PIXErrorWithParameterName:@"您尚未設定必要參數，請先呼叫 +setConsumerKey:consumerSecret:callbackURL:"]);
            return;
        }

        PIXAuthType authType = (PIXAuthType) [[NSUserDefaults standardUserDefaults] integerForKey:kAuthTypeKey];
        if (authType == PIXAuthTypeUndefined) {
            completion(NO, nil, [NSError PIXErrorWithParameterName:@"您尚未取得授權，請先呼叫 +loginByOAuth2WithLoginView:Completion:"]);
            return;
        }
    }
    if (backgroundExec) {
        float osVersionValue = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (osVersionValue < 7.0) {
            completion(NO, nil, [NSError PIXErrorWithParameterName:@"backgroundExec 為 YES 時，iOS 版本至少要 7.0 以上"]);
            return;
        }
    }
    NSString *parameterString = nil;
    if (parameters != nil && [parameters isKindOfClass:[NSDictionary class]]) {
        parameterString = [self parametersStringFromDictionary:parameters];
    }
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", kApiURLPrefix, apiPath];
    if ((httpMethod == nil || [httpMethod isEqualToString:@"GET"]) && parameterString) {
        [urlString appendString:[NSString stringWithFormat:@"?%@", [parameterString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *urlRequest = [self requestWithURL:requestUrl apiPath:apiPath shouldAuth:shouldAuth httpMethod:httpMethod parameters:parameters];
    if (uploadData && [uploadData isKindOfClass:[NSData class]]) {
        [urlRequest PIXAttachData:uploadData];
    }
//    if (uploadData && [uploadData isKindOfClass:[NSArray class]]) {
//        [urlRequest PIXAttachDatas:uploadData];
//    }

    
    if (backgroundExec) {
        //這裡要用 NSURLSession
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"PIXBackgroundExec"];
        PIXURLSessionDelegateHandler *delegateHandler = [[PIXURLSessionDelegateHandler alloc] initWithCompletionHandler:^(BOOL succeed, NSHTTPURLResponse *response, NSData *receivedData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (succeed) {
                    if (response.statusCode == 200) {
                        completion(YES, receivedData, nil);
                        return;
                    } else {
                        completion(NO, nil, [NSError PIXErrorWithHTTPStatusCode:response.statusCode]);
                        return;
                    }
                } else {
                    completion(NO, nil, error);
                    return;
                }
            });
        }];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:delegateHandler delegateQueue:[NSOperationQueue new]];
        NSURLSessionDownloadTask *uploadTask = [session downloadTaskWithRequest:urlRequest];
        [uploadTask resume];
    } else {
        //這裡可以用 NSURLConnection
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (connectionError == nil) {
                    NSHTTPURLResponse *hr = (NSHTTPURLResponse *)response;
                    if (hr.statusCode == 200) {
                        completion(YES, data, nil);
                        return;
                    } else {
                        id receivedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                        NSString *message = receivedObject[@"message"];
                        if (message) {
                            completion(NO, data, [NSError PIXErrorWithParameterName:receivedObject[@"message"]]);
                        } else {
                            completion(NO, data, [NSError PIXErrorWithHTTPStatusCode:hr.statusCode]);
                        }
                        
                        return;
                    }
                } else {
                    if (data) {
                        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        completion(NO, nil, [NSError PIXErrorWithParameterName:string]);
                        return;
                    } else {
                        completion(NO, nil, connectionError);
                        return;
                    }
                }
            });
        }];
        
    }
}
-(NSMutableURLRequest *)requestWithURL:(NSURL *)url apiPath:(NSString *)path shouldAuth:(BOOL)auth httpMethod:(NSString *)httpMethod parameters:(NSDictionary *)parameters{
    NSMutableURLRequest *request = nil;
    PIXAuthType authType = [[NSUserDefaults standardUserDefaults] integerForKey:kAuthTypeKey];
    if (auth) {
        switch (authType) {
            case PIXAuthTypeXAuth:{
                if ([parameters isKindOfClass:[NSDictionary class]]) {
                    request = [PIXAPIHandler requestForXAuthWithPath:path parameters:parameters httpMethod:(NSString *)httpMethod];
                } else {
                    request = [PIXAPIHandler requestForXAuthWithPath:path parameters:nil httpMethod:(NSString *)httpMethod];
                }
                break;
            }
            case PIXAuthTypeOAuth2:{
                request = [self requestForOAuth2WithPath:path parameters:parameters httpMethod:httpMethod];
                break;
            }
            default:
                break;
        }
    } else {
        request = [NSMutableURLRequest requestWithURL:url];
        if (![httpMethod isEqualToString:@"GET"]) {
            [request setHTTPMethod:httpMethod];
            [request setHTTPBody:[[self parametersStringFromDictionary:parameters] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    return request;
}
-(NSString *)parametersStringFromDictionary:(NSDictionary *)dictionary{
    NSMutableString *parameterString = [NSMutableString new];

    NSArray *keys = [dictionary allKeys];
    for (NSString *key in keys) {
        [parameterString appendString:[NSString stringWithFormat:@"%@=%@&", key, dictionary[key]]];
    }
    //一律使用 json 格式處理回傳的資料
    [parameterString appendString:@"format=json"];

    return parameterString;
}
-(NSMutableURLRequest *)requestForOAuth2WithPath:(NSString *)path parameters:(NSDictionary *)params httpMethod:(NSString *)httpMethod{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setHTTPMethod:httpMethod];
    NSMutableDictionary *tempParams = nil;
    if (params!= nil && [params isKindOfClass:[NSDictionary class]]) {
        tempParams = [NSMutableDictionary dictionaryWithDictionary:params];
    } else {
        tempParams = [NSMutableDictionary dictionary];
    }
    //將 access token 加到 query 的參數裡
    LROAuth2AccessToken *currentToken = [self accessTokenForCurrent];
    tempParams[@"access_token"] = currentToken.accessToken;
    NSString *urlString = nil;
    NSString *paramString = [self parametersStringFromDictionary:tempParams];
    if ([httpMethod isEqualToString:@"GET"]) {
        urlString = [NSString stringWithFormat:@"%@%@?%@", kApiURLPrefix, path, paramString];
    } else {
        urlString = [NSString stringWithFormat:@"%@%@", kApiURLPrefix, path];
        [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
//        [request addValue:currentToken.accessToken forHTTPHeaderField:@"access_token"];
    }
    [request setURL:[NSURL URLWithString:urlString]];
    return request;
}
/**
 *  用來取得現在當下可用的 access token
 */
-(LROAuth2AccessToken *)accessTokenForCurrent{
    LROAuth2AccessToken *storedToken = [NSKeyedUnarchiver unarchiveObjectWithFile:[PIXAPIHandler filePathForOAuth2AccessToken]];
    if (storedToken) {
        if ([storedToken hasExpired]) {
            PIXAPIHandler *singleton = [PIXAPIHandler sharedInstance];
            __block BOOL done = NO;
            LROAuth2ClientDelegateHandler *handler = [[LROAuth2ClientDelegateHandler alloc] initWithOAuth2Completion:^(BOOL succeed, LROAuth2AccessToken *accessToken, NSError *error) {
                if (succeed) {
                    done = YES;
                    [NSKeyedArchiver archiveRootObject:accessToken toFile:[PIXAPIHandler filePathForOAuth2AccessToken]];
                }
            }];
            singleton.oauth2Client.delegate = handler;
            [singleton.oauth2Client refreshAccessToken:storedToken];
            while (!done) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            if (!done) {
                [singleton.oauth2Client refreshAccessToken:storedToken];
            }
            return singleton.oauth2Client.accessToken;
        } else {
            return storedToken;
        }
    } else {
        return storedToken;
    }
}

/**
 *  產生一個用來取得 token 的 URLQuest (for XAuth)
 */
+(NSMutableURLRequest *)requestForXAuthWithPath:(NSString *)path parameters:(NSDictionary *)params httpMethod:(NSString *)httpMethod{
    NSString *user = [[PIXCredentialStorage sharedInstance] stringForIdentifier:[kUserNameIdentifier copy]];
    NSString *password = [[PIXCredentialStorage sharedInstance] stringForIdentifier:[kUserPasswordIdentifier copy]];

    NSDictionary *userDict = @{@"x_auth_username":user, @"x_auth_password":password, @"x_auth_mode":@"client_auth"};
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userDict];
    if (params) {
        [dict addEntriesFromDictionary:params];
    }
    NSMutableURLRequest *request = nil;
    NSString *oPath = [NSString stringWithFormat:@"/%@", path];
    NSString *token = [[PIXCredentialStorage sharedInstance] stringForIdentifier:[kOauthTokenIdentifier copy]];
    NSString *secret = [[PIXCredentialStorage sharedInstance] stringForIdentifier:[kOauthTokenSecretIdentifier copy]];
    
    if ([httpMethod isEqualToString:@"GET"]) {
        request = (NSMutableURLRequest *)[GCOAuth URLRequestForPath:oPath GETParameters:dict host:[kApiURLHost copy] consumerKey:[kConsumerKey copy] consumerSecret:[kConsumerSecret copy] accessToken:token tokenSecret:secret];
    } else {
        if ([httpMethod isEqualToString:@"POST"]) {
            request = (NSMutableURLRequest *)[GCOAuth URLRequestForPath:oPath POSTParameters:dict host:[kApiURLHost copy] consumerKey:[kConsumerKey copy] consumerSecret:[kConsumerSecret copy] accessToken:token tokenSecret:secret];
        } else {
            request = (NSMutableURLRequest *)[GCOAuth URLRequestForPath:oPath HTTPMethod:httpMethod parameters:dict scheme:@"https" host:[kApiURLHost copy] consumerKey:[kConsumerKey copy] consumerSecret:[kConsumerSecret copy] accessToken:token tokenSecret:secret];
        }
    }
    return request;
}
@end
