//
//  PIXAPIHandler.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//

#import "PIXAPIHandler.h"

static const NSString *kApiURLPrefix = @"https://emma.pixnet.cc/";

@implementation PIXAPIHandler

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
    NSString *parameterString = nil;
    if (parameters != nil) {
        parameterString = [self parametersStringFromDictionary:parameters];
    }
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", kApiURLPrefix, apiPath];
    if (httpMethod == nil || [httpMethod isEqualToString:@"GET"]) {
        [urlString appendString:[NSString stringWithFormat:@"?%@", parameterString]];
    }
    
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestUrl];
    if (![httpMethod isEqualToString:@"GET"]) {
        [urlRequest setHTTPMethod:httpMethod];
        [urlRequest setHTTPBody:[parameterString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
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
