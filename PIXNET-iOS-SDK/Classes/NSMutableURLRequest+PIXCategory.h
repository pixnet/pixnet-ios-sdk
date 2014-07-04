//
//  NSMutableURLRequest+PIXCategory.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/7/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (PIXCategory)
-(void)PIXAttachData:(NSData *)data;
/**
 *  將多個檔案附加在 query 裡
 *
 *  @param datas 由數個 NSDictionary 組成的 array, Dictionary 的 key 是檔名，value 是 NSData
 */
-(void)PIXAttachDatas:(NSArray *)datas;
@end
