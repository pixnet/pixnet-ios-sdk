//
//  PIXAPIHandler.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//
static const NSString *kConsumerKey;
static const NSString *kConsumerSecrect;


#import "PIXAPIHandler.h"
#import <AFXAuthClient.h>
#import <AFNetworking.h>

static const NSString *kApiURLPrefix = @"https://emma.pixnet.cc/";
static NSMutableDictionary *_authClientDictionary;
static AFXAuthClient *_authClient;

@interface PIXAPIHandler ()

@end

@implementation PIXAPIHandler
+(void)setConsumerKey:(NSString *)aKey consumerSecrect:(NSString *)aSecrect{
    kConsumerKey = [aKey copy];
    kConsumerSecrect = [aSecrect copy];
}
+(BOOL)isConsumerKeyAndSecrectAssigned{
    BOOL assigned = YES;
    if (kConsumerKey == nil || kConsumerSecrect == nil) {
        assigned = NO;
    }
    return assigned;
}
+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password requestCompletion:(RequestCompletion)completion{
    if (![self isConsumerKeyAndSecrectAssigned]) {
        completion(NO, nil, @"consumer key 或 consumer secrect 尚未設定");
        return;
    }
    _authClient = [[AFXAuthClient alloc] initWithBaseURL:[NSURL URLWithString:[kApiURLPrefix copy]] key:[kConsumerKey copy] secret:[kConsumerSecrect copy]];
    [_authClient authorizeUsingXAuthWithAccessTokenPath:@"oauth/access_token" accessMethod:@"POST" username:userName password:password success:^(AFXAuthToken *accessToken) {
//        NSLog(@"authed token key: %@", accessToken.key);
        completion(YES, accessToken, nil);
    } failure:^(NSError *error) {
//        NSLog(@"auth failed: %@", error);
        completion(NO, nil, error.localizedDescription);
    }];
}
+(instancetype)sharedInstance{
    static PIXAPIHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PIXAPIHandler alloc] init];
    });
    return sharedInstance;
}

-(void)callAPI:(NSString *)apiPath parameters:(NSDictionary *)parameters requestCompletion:(RequestCompletion)completion{
    [self callAPI:apiPath httpMethod:@"GET" parameters:parameters requestCompletion:completion];
}

-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod parameters:(NSDictionary *)parameters requestCompletion:(RequestCompletion)completion{
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:NO parameters:parameters requestCompletion:completion];
}

-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth parameters:(NSDictionary *)parameters requestCompletion:(RequestCompletion)completion{
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:shouldAuth shouldExecuteInBackground:NO parameters:parameters requestCompletion:completion];
}
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth shouldExecuteInBackground:(BOOL)backgroundExec parameters:(NSDictionary *)parameters requestCompletion:(RequestCompletion)completion{
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:shouldAuth shouldExecuteInBackground:backgroundExec uploadData:nil parameters:parameters requestCompletion:completion];
}
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth shouldExecuteInBackground:(BOOL)backgroundExec uploadData:(NSData *)uploadData parameters:(NSDictionary *)parameters requestCompletion:(RequestCompletion)completion{
    NSString *parameterString = nil;
    if (parameters != nil) {
        parameterString = [self parametersStringFromDictionary:parameters];
    }
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", kApiURLPrefix, apiPath];
    if (httpMethod == nil || [httpMethod isEqualToString:@"GET"]) {
        [urlString appendString:[NSString stringWithFormat:@"?%@", parameterString]];
    }
    
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *urlRequest = [self requestWithURL:requestUrl apiPath:apiPath shouldAuth:shouldAuth httpMethod:httpMethod parameters:parameters];
    
    if (backgroundExec) {
        //這裡要用 NSURLSession
    } else {
        //這裡可以用 NSURLConnection
        if (uploadData == nil) {
            //NSURLConnection 下載
            [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (connectionError == nil) {
                        NSHTTPURLResponse *hr = (NSHTTPURLResponse *)response;
                        if (hr.statusCode == 200) {
                            completion(YES, data, nil);
                        } else {
                            completion(NO, data, [NSHTTPURLResponse localizedStringForStatusCode:hr.statusCode]);
                        }
                    } else {
                        completion(NO, data, connectionError.localizedDescription);
                    }
                });
            }];
        } else {
           //NSURLConnection 上傳
        }
    }
}
-(NSMutableURLRequest *)requestWithURL:(NSURL *)url apiPath:(NSString *)path shouldAuth:(BOOL)auth httpMethod:(NSString *)httpMethod parameters:(NSDictionary *)parameters{
    NSMutableURLRequest *request = nil;
    if (auth) {
        request = [_authClient requestWithMethod:httpMethod path:path parameters:parameters];
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
/**
 *  為每一個 user 設立一個自己的 AFXAuthClient instance
 *
 *  @param userName
 *
 *  @return AFXAuthClient client
 */
+(AFXAuthClient *)authClientWithUserName:(NSString *)userName{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _authClientDictionary = [NSMutableDictionary new];
    });
    AFXAuthClient *client = _authClientDictionary[userName];
    if (client == nil) {
        client = [[AFXAuthClient alloc] initWithBaseURL:[NSURL URLWithString:[kApiURLPrefix copy]] key:[kConsumerKey copy] secret:[kConsumerSecrect copy]];
        [_authClientDictionary setObject:client forKey:userName];
    }
    return client;
}
@end
