//
//  NSData+PIXCategory.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/7/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "NSData+PIXCategory.h"

@implementation NSData (PIXCategory)
-(NSString *)PIXContentTypeStringForImageData{
    PIXImageDataType type = [self PIXContentTypeForImageData];
    NSString *typeString = nil;
    switch (type) {
        case PIXImageDataTypeJPEG:
            typeString = @"jpeg";
            break;
        case PIXImageDataTypePNG:
            typeString = @"png";
            break;
        case PIXImageDataTypeTIFF:
            typeString = @"tiff";
            break;
        case PIXImageDataTypeGIF:
            typeString = @"gif";
            break;
        default:
            break;
    }
    return typeString;
}
-(PIXImageDataType)PIXContentTypeForImageData{
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return PIXImageDataTypeJPEG;
            break;
        case 0x89:
            return PIXImageDataTypePNG;
            break;
        case 0x47:
            return PIXImageDataTypeGIF;
            break;
        case 0x49:
        case 0x4D:
            return PIXImageDataTypeTIFF;
            break;
            
        default:
            break;
    }
    return PIXImageDataTypeUnknown;
}
@end
