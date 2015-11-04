//
//  NSMutableURLRequest+PIXCategory.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/7/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//

static const NSString *kBoundaryConstant = @"PIXNETBOUNDRYPIXNETBOUNDRYPIXNETBOUNDRYPIXNETBOUNDRY";
static const NSString *kNewLineSymbol = @"\r\n";

#import "NSMutableURLRequest+PIXCategory.h"
//#import "NSData+PIXCategory.h"
#import "OARequestParameter.h"

@implementation NSMutableURLRequest (PIXCategory)
- (BOOL)isMultipart {
	return [[self valueForHTTPHeaderField:@"Content-Type"] hasPrefix:@"multipart/form-data"];
}

- (NSArray *)parameters {
    NSString *encodedParameters = nil;
    
	if (![self isMultipart]) {
		if ([[self HTTPMethod] isEqualToString:@"GET"] || [[self HTTPMethod] isEqualToString:@"DELETE"]) {
			encodedParameters = [[self URL] query];
		} else {
			encodedParameters = [[NSString alloc] initWithData:[self HTTPBody] encoding:NSUTF8StringEncoding];
		}
	}
    
    if (encodedParameters == nil || [encodedParameters isEqualToString:@""]) {
        return nil;
    }
    //    NSLog(@"raw parameters %@", encodedParameters);
    NSArray *encodedParameterPairs = [encodedParameters componentsSeparatedByString:@"&"];
    NSMutableArray *requestParameters = [NSMutableArray arrayWithCapacity:[encodedParameterPairs count]];
    
    for (NSString *encodedPair in encodedParameterPairs) {
        NSArray *encodedPairElements = [encodedPair componentsSeparatedByString:@"="];
        OARequestParameter *parameter = [[OARequestParameter alloc] initWithName:[[encodedPairElements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                                           value:[[encodedPairElements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [requestParameters addObject:parameter];
    }
    
    return requestParameters;
}
//單一檔案，未用 base64
-(void)PIXAttachData:(NSData *)data{
    NSArray *parameters = [self parameters];
    [self setValue:[@"multipart/form-data; boundary=" stringByAppendingString:[kBoundaryConstant copy]] forHTTPHeaderField:@"Content-type"];
    
    NSMutableData *bodyData = [NSMutableData data];
    for (OARequestParameter *parameter in parameters) {
        NSString *param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",
                           kBoundaryConstant, [parameter URLEncodedName], [parameter value]];
        [bodyData appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //@"upload_file" 這個參數是 PIXNET 後台 API 指定的參數
    NSString *filePrefix = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n",
                            kBoundaryConstant, @"upload_file", @"filename", @"application/x-octetstream"];
    [bodyData appendData:[filePrefix dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:data];
    [bodyData appendData:[[[@"\r\n--" stringByAppendingString:[kBoundaryConstant copy]] stringByAppendingString:@"--"] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    [self setHTTPBody:bodyData];;
}

-(void)PIXAttachDatas:(NSArray *)datas{
    NSArray *parameters = [self parameters];
    [self setValue:[@"multipart/form-data; boundary=" stringByAppendingString:[kBoundaryConstant copy]] forHTTPHeaderField:@"Content-type"];
    
    NSMutableData *bodyData = [NSMutableData data];
    for (OARequestParameter *parameter in parameters) {
        NSString *param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",
                           kBoundaryConstant, [parameter URLEncodedName], [parameter value]];
        [bodyData appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //@"upload_file" 這個參數是 PIXNET 後台 API 指定的參數
    int totalLength = 0;
    for (NSDictionary *data in datas) {
        NSString *keyString = [[data allKeys] lastObject];
        NSData *content = data[keyString];
        NSString *filePrefix = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n",
                                kBoundaryConstant, keyString, keyString, @"application/x-octetstream"];
        [bodyData appendData:[filePrefix dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:content];
        [bodyData appendData:[[[@"\r\n--" stringByAppendingString:[kBoundaryConstant copy]] stringByAppendingString:@"--"] dataUsingEncoding:NSUTF8StringEncoding]];
        totalLength += [content length];
    }
    [self setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    [self setHTTPBody:bodyData];;
}
+(instancetype)PIXURLRequestForOauth2POST:(NSString *)urlString parameters:(NSDictionary *)parameters{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    //設定 http header
    NSString *contentTypeValue = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", kBoundaryConstant];
    [request addValue:contentTypeValue forHTTPHeaderField:@"Content-Type"];
    //設定 http body
    [request setHTTPBody:[stringForFormData(parameters) dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}
static NSString* stringForFormData(NSDictionary *parameters){
    // 做為 form data 參數間的分隔線，前面要有兩個減號
    NSString *boundaryWtihNewLine = [NSString stringWithFormat:@"--%@%@", kBoundaryConstant, kNewLineSymbol];
    __block NSMutableArray *array = [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSString  *_Nonnull obj, BOOL * _Nonnull stop) {
        NSString *string = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"%@%@%@%@", key, kNewLineSymbol, kNewLineSymbol, obj, kNewLineSymbol];;
        [array addObject:string];
    }];
    NSString *string = [array componentsJoinedByString:boundaryWtihNewLine];
    // 做為 form data 所有參數的結尾的 boundary，前後都要有兩個減號
    string = [NSString stringWithFormat:@"%@%@--%@--", boundaryWtihNewLine, string, kBoundaryConstant];
    return string;
}
@end
