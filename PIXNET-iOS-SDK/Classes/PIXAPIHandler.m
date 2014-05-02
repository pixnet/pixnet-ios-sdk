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
#import "NSMutableURLRequest+PIXCategory.h"
#import "PIXCredentialStorage.h"
#import "NSError+PIXCategory.h"

static const NSString *kApiURLPrefix = @"https://emma.pixnet.cc/";
static const NSString *kApiURLHost = @"emma.pixnet.cc";
static const NSString *kUserNameIdentifier = @"kUserNameIdentifier";
static const NSString *kUserPasswordIdentifier = @"kUserPasswordIdentifier";
static const NSString *kOauthTokenIdentifier = @"kOauthTokenIdentifier";
static const NSString *kOauthTokenSecretIdentifier = @"kOauthTokenSecretIdentifier";

@interface PIXAPIHandler ()
@property (nonatomic, strong) NSDictionary *paramForXAuthRequest;
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

+(void)logout{
    [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:[kOauthTokenIdentifier copy]];
    [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:[kOauthTokenSecretIdentifier copy]];
    [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:[kUserNameIdentifier copy]];
    [[PIXCredentialStorage sharedInstance] removeStringForIdentifier:[kUserPasswordIdentifier copy]];
}
+(void)authByXauthWithUserName:(NSString *)userName userPassword:(NSString *)password requestCompletion:(PIXHandlerCompletion)completion{
    //檢查是否已設定 consumer key 及 consumer secret
    if (kConsumerSecret==nil || kConsumerKey==nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"consumer key 或 consumer secret"]);
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
                    completion(YES, nil, nil);
                    return;
                }
            }
        });
    }];
}
+(BOOL)isAuthed{
    NSString *token = [[PIXCredentialStorage sharedInstance] stringForIdentifier:[kOauthTokenIdentifier copy]];
    NSString *secret = [[PIXCredentialStorage sharedInstance] stringForIdentifier:[kOauthTokenSecretIdentifier copy]];
    if (token==nil || secret == nil) {
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
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:shouldAuth uploadData:nil parameters:parameters requestCompletion:completion];
}
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth uploadData:(NSData *)uploadData parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    [self callAPI:apiPath httpMethod:httpMethod shouldAuth:shouldAuth shouldExecuteInBackground:NO uploadData:uploadData parameters:parameters requestCompletion:completion];
}
-(void)callAPI:(NSString *)apiPath httpMethod:(NSString *)httpMethod shouldAuth:(BOOL)shouldAuth shouldExecuteInBackground:(BOOL)backgroundExec uploadData:(NSData *)uploadData parameters:(NSDictionary *)parameters requestCompletion:(PIXHandlerCompletion)completion{
    if (shouldAuth && kConsumerKey == nil) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"您尚未取得授權，請先呼叫 +authByXauthWithUserName:userPassword:requestCompletion:"]);
        return;
    }
    NSString *parameterString = nil;
    if (parameters != nil) {
        parameterString = [self parametersStringFromDictionary:parameters];
    }
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", kApiURLPrefix, apiPath];
    if ((httpMethod == nil || [httpMethod isEqualToString:@"GET"]) && parameterString) {
        [urlString appendString:[NSString stringWithFormat:@"?%@", [parameterString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *urlRequest = [self requestWithURL:requestUrl apiPath:apiPath shouldAuth:shouldAuth httpMethod:httpMethod parameters:parameters];
    if (uploadData) {
        [urlRequest PIXAttachData:uploadData];
    }
    
    if (backgroundExec) {
        //這裡要用 NSURLSession
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
                        completion(NO, data, [NSError PIXErrorWithHTTPStatusCode:hr.statusCode]);
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
/**
 *  產生一個用來取得 token 的 URLQuest
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
