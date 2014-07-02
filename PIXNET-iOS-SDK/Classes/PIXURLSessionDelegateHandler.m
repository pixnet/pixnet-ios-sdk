//
//  PIXURLSessionDelegateHandler.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/30/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "PIXURLSessionDelegateHandler.h"
@interface PIXURLSessionDelegateHandler()
@property (nonatomic, strong) NSData *receivedData;

@end

@implementation PIXURLSessionDelegateHandler
-(instancetype)initWithCompletionHandler:(SessionDelegateComplete)completion{
    self = [super init];
    if (self) {
        _sessionDelegateComplete = completion;
    }
    return self;
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
//    NSLog(@"totalBytesSent: %lli, totalBytesExpectedToSend: %lli", totalBytesSent, totalBytesExpectedToSend);
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        _sessionDelegateComplete(NO, nil, nil, error);
    } else {
        _sessionDelegateComplete(YES, (NSHTTPURLResponse *)task.response, _receivedData, nil);
    }
}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSData *data = [NSData dataWithContentsOfURL:location];
    _receivedData = data;
}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{

}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{

}
@end
