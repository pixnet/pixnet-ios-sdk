//
//  PIXAPIHandler.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//
static const NSString *kConsumerKey;
static const NSString *kConsumerSecret;


#import "PIXAPIHandler.h"
#import <GCOAuth.h>

static const NSString *kApiURLPrefix = @"https://emma.pixnet.cc/";
static const NSString *kApiURLHost = @"emma.pixnet.cc";
static const NSString *kUserName;
static const NSString *kUserPassword;
static const NSString *kOauthToken;
static const NSString *kOauthTokenSecret;
//static NSDictionary *kAuthClientDictionary = @{@"x_auth_username":userName, @"x_auth_password":password, @"x_auth_mode":@"client_auth"};

@interface PIXAPIHandler ()
@property (nonatomic, strong) NSDictionary *paramForXAuthRequest;
//@property (nonatomic, copy) NSString *oauthTokenSecret;
@end

@implementation PIXAPIHandler
+(void)setConsumerKey:(NSString *)aKey consumerSecret:(NSString *)aSecret{
    kConsumerKey = [aKey copy];
    kConsumerSecret = [aSecret copy];
}
+(BOOL)isConsumerKeyAndSecrectAssigned{
    BOOL assigned = YES;
    if (kConsumerKey == nil || kConsumerSecret == nil) {
        assigned = NO;
    }
    return assigned;
}
+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password requestCompletion:(PIXHandlerCompletion)completion{
    if (kConsumerSecret==nil || kConsumerKey==nil) {
        completion(NO, nil, @"consumer key 或 consumer secrect 尚未設定");
        return;
    }
    kUserName = [userName copy];
    kUserPassword = [password copy];
    NSURLRequest *request = [self requestForXAuthWithPath:@"oauth/access_token" parameters:nil httpMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (connectionError) {
                completion(NO, nil, connectionError.localizedDescription);
            } else {
                NSHTTPURLResponse *hur = (NSHTTPURLResponse *)response;
                if (hur.statusCode != 200) {
                    completion(NO, nil, [NSHTTPURLResponse localizedStringForStatusCode:hur.statusCode]);
                } else {
                    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSArray *array = [dataString componentsSeparatedByString:@"&"];
                    for (NSString *string in array) {
                        NSArray *array0 = [string componentsSeparatedByString:@"="];
                        if ([array0[0] isEqualToString:@"oauth_token"]) {
                            kOauthToken = [array0[1] copy];
                        }
                        if ([array0[0] isEqualToString:@"oauth_token_secret"]) {
                            kOauthTokenSecret = [array0[1] copy];
                        }
                    }
                    completion(YES, kOauthToken, nil);
                }
            }
        });
    }];
}
+(BOOL)isAuthed{
    if (kConsumerKey==nil || kConsumerSecret == nil) {
        return NO;
    } else {
        return YES;
    }
}
-(void)callAPI:(NSString *)apiPath parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    [self callAPI:apiPath httpMethod:@"GET" parameters:parameters requestCompletion:completion];
}

-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:NO parameters:parameters requestCompletion:completion];
}

-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:shouldAuth shouldExecuteInBackground:NO parameters:parameters requestCompletion:completion];
}
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth shouldExecuteInBackground:(BOOL)backgroundExec parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:shouldAuth shouldExecuteInBackground:backgroundExec uploadData:nil parameters:parameters requestCompletion:completion];
}
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth shouldExecuteInBackground:(BOOL)backgroundExec uploadData:(NSData *)uploadData parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    if (shouldAuth && kConsumerKey == nil) {
        completion(NO, nil, @"您尚未取得授權，請先呼叫 +authByXauthWithUserName:userPassword:requestCompletion:");
    }
    NSString *parameterString = nil;
    if (parameters != nil) {
        parameterString = [self parametersStringFromDictionary:parameters];
    }
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", kApiURLPrefix, apiPath];
    if (httpMethod == nil || [httpMethod isEqualToString:@"GET"]) {
        [urlString appendString:[NSString stringWithFormat:@"?%@", [parameterString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
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
        request = [PIXAPIHandler requestForXAuthWithPath:path parameters:parameters httpMethod:(NSString *)httpMethod];
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
+(NSMutableURLRequest *)requestForXAuthWithPath:(NSString *)path parameters:(NSDictionary *)params httpMethod:(NSString *)httpMethod{
    NSDictionary *userDict = @{@"x_auth_username":kUserName, @"x_auth_password":kUserPassword, @"x_auth_mode":@"client_auth"};
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userDict];
    if (params) {
        [dict addEntriesFromDictionary:params];
    }
    NSMutableURLRequest *request = nil;
    NSString *oPath = [NSString stringWithFormat:@"/%@", path];
    if ([httpMethod isEqualToString:@"GET"]) {
        request = (NSMutableURLRequest *)[GCOAuth URLRequestForPath:oPath GETParameters:dict host:[kApiURLHost copy] consumerKey:[kConsumerKey copy] consumerSecret:[kConsumerSecret copy] accessToken:[kOauthToken copy] tokenSecret:[kOauthTokenSecret copy]];
    } else {
        if ([httpMethod isEqualToString:@"POST"]) {
            request = (NSMutableURLRequest *)[GCOAuth URLRequestForPath:oPath POSTParameters:dict host:[kApiURLHost copy] consumerKey:[kConsumerKey copy] consumerSecret:[kConsumerSecret copy] accessToken:[kOauthToken copy] tokenSecret:[kOauthTokenSecret copy]];
        } else {
            request = (NSMutableURLRequest *)[GCOAuth URLRequestForPath:oPath HTTPMethod:httpMethod parameters:dict scheme:@"https" host:[kApiURLHost copy] consumerKey:[kConsumerKey copy] consumerSecret:[kConsumerSecret copy] accessToken:[kOauthToken copy] tokenSecret:[kOauthTokenSecret copy]];
        }
    }
    return request;
}
@end
