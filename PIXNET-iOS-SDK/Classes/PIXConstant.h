//
//  PIXConstant.h
//  PIXNET-iOS-SDK
//
//  Created by jnlin on 2014/3/22.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIXConstant : NSObject {
    NSString *msgFmtRequiredParameter;
    NSString *msgMissingUserName;
}

@property (nonatomic, retain) NSString *msgFmtRequiredParameter;
@property (nonatomic, retain) NSString *msgMissingUserName;

+ (id)sharedConstant;

@end


