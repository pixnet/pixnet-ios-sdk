//
//  PIXAPIHandler.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//
static NSString *kConsumerKey;
static NSString *kConsumerSecret;
static NSString *kCallbackURL;

#import "PIXAPIHandler.h"
#import "GCOAuth.h"
#import "NSMutableURLRequest+PIXCategory.h"
#import "PIXCredentialStorage.h"
#import "NSError+PIXCategory.h"
#import "LROAuth2Client.h"
#import "LROAuth2AccessToken.h"
#import "LROAuth2ClientDelegateHandler.h"
#import "PIXURLSessionDelegateHandler.h"
#import "NSData+Base64.h"
#import "OMGHTTPURLRQ.h"

static NSString *const kApiURLPrefix = @"https://emma.pixnet.cc/";
static NSString *const kApiURLHost = @"emma.pixnet.cc";
//here
//static NSString *const kApiURLPrefix = @"http://login.pixnet.cc.33852.alpha.pixnet/";
//static NSString *const kApiURLHost = @"login.pixnet.cc.33852.alpha.pixnet";

static NSString *const kUserNameIdentifier = @"kUserNameIdentifier";
static NSString *const kUserPasswordIdentifier = @"kUserPasswordIdentifier";
static NSString *const kOauthTokenIdentifier = @"kOauthTokenIdentifier";
static NSString *const kOauthTokenSecretIdentifier = @"kOauthTokenSecretIdentifier";
static NSString *const kAuthTypeKey = @"kAuthTypeKey";
//static PIXAuthType authType;

@interface PIXAPIHandler ()
@property (nonatomic, strong) NSDictionary *paramForXAuthRequest;
@property (nonatomic, strong) LROAuth2Client *oauth2Client;
@property (nonatomic, strong) LROAuth2ClientDelegateHandler *oauth2ClientDelegateHandler;
@property (nonatomic, copy) PIXHandlerCompletion getOAuth2AccessTokenCompletion;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, strong) NSDictionary *userDictionaryForXAuth;
@end

@implementation PIXAPIHandler

+(instancetype)sharedInstance{
    static PIXAPIHandler *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PIXAPIHandler alloc] init];
        sharedInstance.oauth2Client = [[LROAuth2Client alloc] initWithClientID:kConsumerKey
                                                                        secret:kConsumerSecret
                                                                   redirectURL:[NSURL URLWithString:kCallbackURL]];
        sharedInstance.oauth2Client.userURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth2/authorize", kApiURLPrefix]];
//        sharedInstance.oauth2Client.userURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kApiURLPrefix]];
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

- (instancetype)init {
    self = [super init];
    if (self) {
        _timeoutInterval = 8;
    }
    return self;
}
-(void)setInternetConnectionTimeoutInterval:(NSTimeInterval)timeoutInterval {
    _timeoutInterval = timeoutInterval;
}
+(void)setConsumerKey:(NSString *)aKey consumerSecret:(NSString *)aSecret{
    kConsumerKey = [aKey copy];
    kConsumerSecret = [aSecret copy];
    kCallbackURL = [NSString stringWithFormat:@"pixnetapi-%@://callback", [kConsumerKey copy]];
}
+(void)setConsumerKey:(NSString *)aKey consumerSecret:(NSString *)aSecret callbackURL:(NSString *)callbackURL{
    kConsumerKey = [aKey copy];
    kConsumerSecret = [aSecret copy];
    kCallbackURL = [NSString stringWithFormat:@"pixnetapi-%@://callback", [kConsumerKey copy]];
}
+(BOOL)isConsumerKeyAndSecretAssigned {
    BOOL assigned = YES;
    if (kConsumerKey == nil || kConsumerSecret == nil) {
        assigned = NO;
    }
    return assigned;
}

+(void)logout{
    NSString *identifierForXAuth = [[PIXCredentialStorage sharedInstance] stringForIdentifier:kOauthTokenIdentifier];
    if (identifierForXAuth) {
        [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:kOauthTokenIdentifier];
        [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:kOauthTokenSecretIdentifier];
        [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:kUserNameIdentifier];
        [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:kUserPasswordIdentifier];
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:[PIXAPIHandler filePathForOAuth2AccessToken] error:nil];
    }

    //將目前的登入狀態改為 undefined
    [[NSUserDefaults standardUserDefaults] setInteger:PIXAuthTypeUndefined forKey:kAuthTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //移除 user ID 及 password
    [PIXAPIHandler sharedInstance].userDictionaryForXAuth = nil;

    // 清除 cookies 及 cache，避免使用者無法切換 open id 帳號
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *httpCookie in [storage cookies]) {
        [storage deleteCookie:httpCookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)authByOAuth2WithLoginView:(UIWebView *)loginView completion:(PIXHandlerCompletion)completion{
    [self loginByOAuth2WithLoginView:loginView completion:completion];
}
// 可以用 Open ID 或是輸入帳密登入 PIXNET
+(void)loginByOAuth2WithLoginView:(UIWebView *)loginView completion:(PIXHandlerCompletion)completion{
    [self launchLoginByOAuth2:loginView additionalParameter:@{@"login_theme" : @"mobileapp"} completion:completion];
}
// 只用 Open ID 登入 PIXNET
+(void)loginByOAuth2OpenIDOnlyWithLoginView:(UIWebView *)loginView completion:(PIXHandlerCompletion)completion {
    [self launchLoginByOAuth2:loginView additionalParameter:@{@"login_theme" : @"mobileapp_openid"} completion:completion];
}

+ (void)launchLoginByOAuth2:(UIWebView *)loginView additionalParameter:(NSDictionary *)parameter completion:(PIXHandlerCompletion)completion {
    if (kConsumerSecret==nil || kConsumerKey==nil || kCallbackURL==nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"consumer key、consumer secret 或 callbackURL 尚未設定"]);
        return;
    }
    PIXAPIHandler *singleton = [PIXAPIHandler sharedInstance];
    singleton.getOAuth2AccessTokenCompletion = completion;
    //先檢查是否已有之前已存下來的 token
    LROAuth2AccessToken *storedToken = [NSKeyedUnarchiver unarchiveObjectWithFile:[PIXAPIHandler filePathForOAuth2AccessToken]];
    if (storedToken) {
        [[NSUserDefaults standardUserDefaults] setInteger:PIXAuthTypeOAuth2 forKey:kAuthTypeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"已有使用者登入中，若要讓另一使用者登入，請先執行 +logout"]);
        return;
    } else {
        if (parameter) {
            [singleton.oauth2Client authorizeUsingWebView:loginView additionalParameters:parameter];
        } else {
            [singleton.oauth2Client authorizeUsingWebView:loginView];
        }
    }
}

+(NSString *)filePathForOAuth2AccessToken{
    // http://stackoverflow.com/questions/12371321/where-should-i-save-data-files-i-want-to-keep-long-term-and-how-do-i-prevent
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask ,YES);
    NSString *documentsDir = paths[0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if (![fileManager fileExistsAtPath:documentsDir isDirectory:&isDirectory]) {
        __autoreleasing NSError *error;
        BOOL isCreated = [fileManager createDirectoryAtPath:documentsDir withIntermediateDirectories:YES attributes:nil error:&error];
        NSAssert(isCreated, error.localizedDescription);
    }
    NSString *path = [documentsDir stringByAppendingPathComponent:@"oauth2token"];
    return path;
}

+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password requestCompletion:(PIXHandlerCompletion)completion{
    //檢查是否已設定 consumer key 及 consumer secret
    if (kConsumerSecret==nil || kConsumerKey==nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"consumer key 或 consumer secret 尚未設定"]);
        return;
    }

    NSString *localUser = [[PIXCredentialStorage sharedInstance] stringForIdentifier:kUserNameIdentifier];
    NSString *localPassword = [[PIXCredentialStorage sharedInstance] stringForIdentifier:kUserPasswordIdentifier];
    if ((localUser!=nil && ![localUser isEqualToString:userName]) || (localPassword!=nil && ![localPassword isEqualToString:password])) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"前一個使用者尚未登出，請先執行 +logout"]);
        return;
    }
    [[PIXCredentialStorage sharedInstance] storeStringForIdentifier:kUserNameIdentifier string:userName];
    [[PIXCredentialStorage sharedInstance] storeStringForIdentifier:kUserPasswordIdentifier string:password];
    [PIXAPIHandler sharedInstance].userDictionaryForXAuth = @{@"x_auth_username":userName, @"x_auth_password":password, @"x_auth_mode":@"client_auth"};

    //如果 local 端已有 token 就不再去跟後台要
    NSString *token = [[PIXCredentialStorage sharedInstance] stringForIdentifier:kOauthTokenIdentifier];
    NSString *secret = [[PIXCredentialStorage sharedInstance] stringForIdentifier:kOauthTokenSecretIdentifier];

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
                [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:kUserNameIdentifier];
                [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:kUserPasswordIdentifier];
                
                completion(NO, nil, connectionError);
                return;
            } else {
                NSHTTPURLResponse *hur = (NSHTTPURLResponse *)response;
                if (hur.statusCode != 200) {
                    [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:kUserNameIdentifier];
                    [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:kUserPasswordIdentifier];

                    completion(NO, nil, [NSError PIXErrorWithHTTPStatusCode:hur.statusCode]);
                    return;
                } else {
                    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSArray *array = [dataString componentsSeparatedByString:@"&"];
                    for (NSString *string in array) {
                        NSArray *array0 = [string componentsSeparatedByString:@"="];
                        if ([array0[0] isEqualToString:@"oauth_token"]) {
                            [[PIXCredentialStorage sharedInstance] storeStringForIdentifier:kOauthTokenIdentifier string:array0[1]];
                        }
                        if ([array0[0] isEqualToString:@"oauth_token_secret"]) {
                            [[PIXCredentialStorage sharedInstance] storeStringForIdentifier:kOauthTokenSecretIdentifier string:array0[1]];
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
            NSString *token = [[PIXCredentialStorage sharedInstance] stringForIdentifier:kOauthTokenIdentifier];
            NSString *secret = [[PIXCredentialStorage sharedInstance] stringForIdentifier:kOauthTokenSecretIdentifier];
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
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:shouldAuth shouldExecuteInBackground:backgroundExec uploadData:uploadData parameters:parameters timeoutInterval:8 requestCompletion:completion];
}
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth shouldExecuteInBackground:(BOOL)backgroundExec uploadData:(NSData *)uploadData parameters:(NSDictionary *)parameters timeoutInterval:(NSTimeInterval)timeoutInterval requestCompletion:(PIXHandlerCompletion)completion{
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
    _timeoutInterval = timeoutInterval;
    NSString *parameterString = nil;
    if (parameters != nil && [parameters isKindOfClass:[NSDictionary class]]) {
        parameterString = [self parametersStringFromDictionary:parameters];
    }
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", kApiURLPrefix, apiPath];
    if ((httpMethod == nil || [httpMethod isEqualToString:@"GET"]) && parameterString) {
        [urlString appendString:[NSString stringWithFormat:@"?%@", [parameterString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }

    NSURL *requestUrl = [NSURL URLWithString:urlString];

    NSMutableURLRequest *urlRequest = [self requestWithURL:requestUrl apiPath:apiPath shouldAuth:shouldAuth httpMethod:httpMethod parameters:parameters timeoutInterval:timeoutInterval];
    if (uploadData && [uploadData isKindOfClass:[NSData class]]) {
        [urlRequest PIXAttachData:uploadData];
    }

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
                        NSString *errorCode = receivedObject[@"code"];
                        if (errorCode) {
//                            completion(NO, data, [NSError PIXErrorWithParameterName:receivedObject[@"message"]]);
                            completion(NO, data, [NSError PIXErrorWithServerResponse:receivedObject]);
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
-(NSMutableURLRequest *)requestWithURL:(NSURL *)url apiPath:(NSString *)path shouldAuth:(BOOL)auth httpMethod:(NSString *)httpMethod parameters:(NSDictionary *)parameters timeoutInterval:(NSTimeInterval)timeoutInterval{
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
    [request setTimeoutInterval:timeoutInterval];
    return request;
}
-(NSString *)parametersStringFromDictionary:(NSDictionary *)dictionary{
    NSMutableString *parameterString = [NSMutableString string];
    NSArray *keys = [dictionary allKeys];
    for (NSString *key in keys) {
        [parameterString appendString:[NSString stringWithFormat:@"%@=%@&", key, dictionary[key]]];
    }
    //一律使用 json 格式處理回傳的資料
    [parameterString appendString:@"format=json"];

    return parameterString;
}
// 不知為何，不能直接用 -parametersStringFromDictionary 不然 format=json 及 access_token 這兩個參數會消失，所以才另外做了這個 function
-(NSString *)parametersStringForOauth2FromDictionary:(NSDictionary *)dictionary{
    NSMutableString *parameterString = [NSMutableString string];
    NSArray *keys = [dictionary allKeys];
    for (NSString *key in keys) {
        [parameterString appendString:[NSString stringWithFormat:@"%@=%@", key, dictionary[key]]];
        if (![key isEqualToString:keys.lastObject]) {
            [parameterString appendString:@"&"];
        }
    }
    return parameterString;
}
// 用來生成一個 oauth2 的 request
-(NSMutableURLRequest *)requestForOAuth2WithPath:(NSString *)path parameters:(NSDictionary *)params httpMethod:(NSString *)httpMethod{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.timeoutInterval = _timeoutInterval;
    [request setHTTPMethod:httpMethod];
    NSString *urlString = nil;
    NSMutableDictionary *tempParams = [NSMutableDictionary dictionary];
    //將 access token 加到 query 的參數裡
    LROAuth2AccessToken *currentToken = [self accessTokenForCurrent];
    tempParams[@"access_token"] = currentToken.accessToken;
    tempParams[@"format"] = @"json";
    if (params != nil && [params isKindOfClass:[NSDictionary class]]) {
        if ([httpMethod isEqualToString:@"GET"]) {  // 有參數的 dictionary
            [tempParams addEntriesFromDictionary:params];
            urlString = [NSString stringWithFormat:@"%@%@?%@", kApiURLPrefix, path, [self parametersStringForOauth2FromDictionary:tempParams]];
            [request setURL:[NSURL URLWithString:urlString]];
        } else {
            BOOL isUploadFile = [params.allKeys containsObject:@"upload_file"];
            if (isUploadFile) {
                //用 OAuth2 上傳檔案
                urlString = [NSString stringWithFormat:@"%@%@", kApiURLPrefix, path];
                OMGMultipartFormData *formData = [OMGMultipartFormData new];
                [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
                    if (![key isEqualToString:@"upload_file"]) {
                        tempParams[key] = obj;
                    }
                }];
                [formData addParameters:tempParams];
                NSData *uploadingFile = params[@"upload_file"];
                NSString *encodedString = [uploadingFile base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [formData addText:encodedString parameterName:@"upload_file"];
//                NSMutableURLRequest *mutableURLRequest = [OMGHTTPURLRQ POST:urlString :formData];
                NSError *error;
                NSMutableURLRequest *mutableURLRequest = [OMGHTTPURLRQ POST:urlString :formData error:&error];
                return mutableURLRequest;
            } else {
                if ([params.allKeys containsObject:@"_method"]) {
                    urlString = [NSString stringWithFormat:@"%@%@", kApiURLPrefix, path];
                    [request setURL:[NSURL URLWithString:urlString]];
                    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
                        tempParams[key] = obj;
                    }];
                    NSString *bodyString = [self parametersStringForOauth2FromDictionary:tempParams];
                    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
                    return request;
                } else {
                    urlString = [NSString stringWithFormat:@"%@%@", kApiURLPrefix, path];
                    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
                        tempParams[key] = obj;
                    }];
                    NSMutableURLRequest *request = [NSMutableURLRequest PIXURLRequestForOauth2POST:urlString parameters:tempParams];
                    return request;
                }
            }
        }
    } else {  // 沒有參數的 request
        urlString = [NSString stringWithFormat:@"%@%@?%@", kApiURLPrefix, path, [self parametersStringForOauth2FromDictionary:tempParams]];
        [request setURL:[NSURL URLWithString:urlString]];
    }
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
            LROAuth2ClientDelegateHandler *originalHandler = singleton.oauth2Client.delegate;
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
                singleton.oauth2Client.delegate = originalHandler;
            }
            return singleton.oauth2Client.accessToken;
        } else {
            return storedToken;
        }
    } else {
        return storedToken;
    }
}

/**.
 *  產生一個用來取得 token 的 URLQuest (for XAuth)
 */
+(NSMutableURLRequest *)requestForXAuthWithPath:(NSString *)path parameters:(NSDictionary *)params httpMethod:(NSString *)httpMethod{
    NSString *token = [[PIXCredentialStorage sharedInstance] stringForIdentifier:kOauthTokenIdentifier];
    NSString *secret = [[PIXCredentialStorage sharedInstance] stringForIdentifier:kOauthTokenSecretIdentifier];
    
    NSDictionary *userDict = nil;
    //判斷是否登入，如無登入才需要帶帳號密碼去驗證，登入過後應該用token及secret去驗證才對
    if (token.length == 0 || secret.length == 0) {
        userDict = [PIXAPIHandler sharedInstance].userDictionaryForXAuth;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userDict];
    
    if (params) {
        [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            dict[key] = obj;
        }];
    }
    NSMutableURLRequest *request = nil;
    NSString *oPath = [NSString stringWithFormat:@"/%@", path];

    if ([httpMethod isEqualToString:@"GET"]) {
        request = (NSMutableURLRequest *)[GCOAuth URLRequestForPath:oPath GETParameters:dict host:kApiURLHost consumerKey:kConsumerKey consumerSecret:kConsumerSecret accessToken:token tokenSecret:secret];
    } else {
        if ([httpMethod isEqualToString:@"POST"]) {
            if ([dict.allKeys containsObject:@"upload_file"]) {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
                NSData *uploadData = dictionary[@"upload_file"];
                dictionary[@"upload_file"] = [uploadData base64EncodedStringWithOptions:0];
                request = (NSMutableURLRequest *)[GCOAuth URLRequestForPath:oPath POSTParameters:dictionary host:kApiURLHost consumerKey:kConsumerKey consumerSecret:kConsumerSecret accessToken:token tokenSecret:secret];
            } else {
                request = (NSMutableURLRequest *)[GCOAuth URLRequestForPath:oPath POSTParameters:dict host:kApiURLHost consumerKey:kConsumerKey consumerSecret:kConsumerSecret accessToken:token tokenSecret:secret];
            }
        } else {
            request = (NSMutableURLRequest *)[GCOAuth URLRequestForPath:oPath HTTPMethod:httpMethod parameters:dict scheme:@"https" host:kApiURLHost consumerKey:kConsumerKey consumerSecret:kConsumerSecret accessToken:token tokenSecret:secret];
        }
    }
    return request;
}
@end
