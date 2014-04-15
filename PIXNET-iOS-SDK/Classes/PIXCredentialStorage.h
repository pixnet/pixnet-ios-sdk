//
//  PIXCredentialStorage.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/8/14.
//  Copyright (c) 2014 PIXNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIXCredentialStorage : NSObject
+(instancetype)sharedInstance;
/**
 *  以加密方式將字串存入 keychain 裡
 *
 *  @param identifier 識別用字串，就像是登入網站用的名稱
 *  @param string     要被存入 keychain 裡的字串
 */
-(void)storeStringForIdentifier:(NSString *)identifier string:(NSString *)string;
/**
 *  取出之前存入的字串
 *
 *  @param identifier 識別用字串，就像是登入網站用的名稱
 *
 *  @return 之前存入的字串
 */
-(NSString *)stringForIdentifier:(NSString *)identifier;
/**
 *  移除之前存入的字串
 *
 *  @param identifier 識別用字串，就像是登入網站用的名稱
 */
-(void)removeStringForIdentifier:(NSString *)identifier;
@end
