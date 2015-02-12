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
 *  一次將一個使用者加入黑名單 http://developer.pixnet.pro/#!/doc/pixnetApi/blocksCreate
 *
 *  @param userName   要被加入黑名單的 user name
 *  @param completion PIXHandlerCompletion
 */
-(void)createBlockWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion __deprecated_msg("use -updateBlockWithUsers:isAddToBlock:completion: instead of this.");
/**
 *  將一個使用者自黑名單中移除 http://developer.pixnet.pro/#!/doc/pixnetApi/blocksDelete
 *
 *  @param userName   要從黑名單移除的使用者名稱
 *  @param completion PIXHandlerCompletion
 */
-(void)deleteBlockWithUserName:(NSString *)userName completion:(PIXHandlerCompletion)completion __deprecated_msg("use -updateBlockWithUsers:isAddToBlock:completion: instead of this.");
/**
*  一次將多個使用者加入黑名單或自黑名單中移除，
*  http://developer.pixnet.pro/#!/doc/pixnetApi/blocksCreate
* http://developer.pixnet.pro.34669.alpha.pixnet/#!/doc/pixnetApi/blocksDelete
*
*  @param userName   要被加入黑名單或自黑名單中移除的使用者名稱, 由 string 組成的 array。必要參數
*  @param isAddToBlock YES 的話是將他們加入黑名單；NO 的話是將他們自黑名單移除。
*  @param completion PIXHandlerCompletion
*/
-(void)updateBlockWithUsers:(NSArray *)users isAddToBlock:(BOOL)isAddToBlock completion:(PIXHandlerCompletion)completion;
@end
