//
//  NSError+PIXCategory.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/10/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
typedef NS_ENUM(NSInteger, PIXErrorCode) {
    PIXErrorCodeParameter,
    
};
#import <Foundation/Foundation.h>

@interface NSError (PIXCategory)
+(instancetype)PIXErrorWithCode:(PIXErrorCode)errorCode;
@end
