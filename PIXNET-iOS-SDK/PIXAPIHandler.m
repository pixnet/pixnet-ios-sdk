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
#import <AFNetworking.h>

static const NSString *kApiURLPrefix = @"https://emma.pixnet.cc/";

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
    
    NSMutableURLRequest *urlRequest = [self requestWithURL:requestUrl shouldAuth:shouldAuth httpMethod:httpMethod parameters:parameterString];
    
    
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
-(NSMutableURLRequest *)requestWithURL:(NSURL *)url shouldAuth:(BOOL)auth httpMethod:(NSString *)httpMethod parameters:(NSString *)parameterString{
#warning 這裡還沒有產生 auth 用的 request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if (![httpMethod isEqualToString:@"GET"]) {
        [request setHTTPMethod:httpMethod];
        [request setHTTPBody:[parameterString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return request;
}
-(NSString *)parametersStringFromDictionary:(NSDictionary *)dictionary{
    NSMutableString *parameterString = [NSMutableString new];
    
    NSArray *keys = [dictionary allKeys];
    for (NSString *key in keys) {
        [parameterString appendString:[NSString stringWithFormat:@"%@=%@", key, dictionary[key]]];
        if (![[keys lastObject] isEqualToString:key]) {
            [parameterString appendString:@"&"];
        }
    }
    return parameterString;
}
-(NSError *)errorWithHTTPStautsCode:(NSInteger)errorCode{
    NSError *error = nil;
    
    return error;
}
@end
