//
//  PIXTestObjectGenerator.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/16/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIXTestObjectGenerator : NSObject
/**
 *  用來產生一些容易發生問題的 NSDictionary instance
 *
 *  @return NSDictionary instance
 */
+(NSDictionary *)PIXTestDictionary;
/**
 *  產生一個指定長度的隨機字串
 *
 *  @param length 您可以在這裡指定該 string 的長度
 *
 *  @return NSString instance
 */
+(NSString *)PIXTestStringByRandomWithLength:(NSUInteger)length;
/**
 *  產生一個 array，該 array 裡的值是一堆容易出問題的 NSNumber instance
 *
 *  @return NSArray instance
 */
+(NSArray *)PIXNumbersArray;
/**
 *  產生一個 array，該 array 裡的值是一堆容易出問題的 NSString instance
 *
 *  @return NSArray instance
 */
+(NSArray *)PIXStringsArray;
@end
