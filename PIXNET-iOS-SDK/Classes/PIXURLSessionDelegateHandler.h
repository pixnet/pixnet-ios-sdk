//
//  PIXURLSessionDelegateHandler.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/30/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
typedef void (^SessionDelegateComplete)(BOOL succeed, NSHTTPURLResponse *response, NSData *receivedData, NSError *error);
#import <Foundation/Foundation.h>

@interface PIXURLSessionDelegateHandler : NSObject<NSURLSessionDownloadDelegate>
@property (nonatomic, copy, readonly) SessionDelegateComplete sessionDelegateComplete;

-(instancetype)initWithCompletionHandler:(SessionDelegateComplete)completion;
@end
