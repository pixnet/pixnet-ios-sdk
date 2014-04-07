//
//  NSData+PIXCategory.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/7/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
typedef NS_ENUM(NSUInteger, PIXImageDataType) {
    PIXImageDataTypeJPEG,
    PIXImageDataTypePNG,
    PIXImageDataTypeGIF,
    PIXImageDataTypeTIFF,
    PIXImageDataTypeUnknown
};
#import <Foundation/Foundation.h>

@interface NSData (PIXCategory)
-(PIXImageDataType)PIXContentTypeForImageData;
-(NSString *)PIXContentTypeStringForImageData;
@end
