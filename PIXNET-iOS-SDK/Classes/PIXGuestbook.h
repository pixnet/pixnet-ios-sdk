//
//  PIXGuestbook.h
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/4/15.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIXAPIHandler.h"
#import "NSObject+PIXCategory.h"
#import "NSError+PIXCategory.h"
/**
 *  留言的屬性
 */
typedef NS_ENUM(NSInteger, PIXGuestbookFilter) {
    /**
     *  顯示所有留言
     */
    PIXGuestbookFilterNone = 0,
    /**
     *  悄悄話留言
     */
    PIXGuestbookFilterWhisper = 1,
    /**
     *  未被回覆過的留言
     */
    PIXGuestbookFilterNoReply = 2
};
@interface PIXGuestbook : NSObject
/**
 *  列出留言板上的留言  http://developer.pixnet.pro/#!/doc/pixnetApi/guestbook
 *
 *  @param userName     哪個使用者的留言板
 *  @param filter       回傳的留言屬性
 *  @param cursor       頁數指標。倘若留言板有下一頁或上一頁時，server 會回傳 next_cursor 或 previours_cursor。
 *  @param perPage      每頁幾筆
 *  @param completion   PIXHandlerCompletion
 */
-(void)getGuestbookMessagesWithUserName:(NSString *)userName filter:(PIXGuestbookFilter)filter cursor:(NSString *)cursor perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion;
@end
