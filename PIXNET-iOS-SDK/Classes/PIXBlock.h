//
//  PIXBlock.h
//  PIXNET-iOS-SDK
//
//  Created by Dolphin on 2014/6/17.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIXAPIHandler.h"

@interface PIXBlock : NSObject
/**
 *  取得黑名單列表 http://developer.pixnet.pro/#!/doc/pixnetApi/blocks
 *
 *  @param completion PIXHandlerCompletion
 */
-(void)getBlocksWithCompletion:(PIXHandlerCompletion)completion;
/**
 *  新增黑名單 http://developer.pixnet.pro/#!/doc/pixnetApi/blocksCreate
 *
 *  @param userName   要被加入黑名單的 user name
 *  @param completion PIXHandlerCompletion
 */
-(void)createBlockWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion;
/**
 *  移除黑名單 http://developer.pixnet.pro/#!/doc/pixnetApi/blocksDelete
 *
 *  @param userName   要從黑名單移除的 user name
 *  @param completion PIXHandlerCompletion
 */
-(void)deleteBlockWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion;
@end
