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
 *  @param userName     哪個使用者的留言板, 必要參數
 *  @param filter       回傳的留言屬性
 *  @param cursor       頁數指標。倘若留言板有下一頁或上一頁時，server 會回傳 next_cursor 或 previours_cursor。
 *  @param perPage      每頁幾筆
 *  @param completion   PIXHandlerCompletion
 */
-(void)getGuestbookMessagesWithUserName:(NSString *)userName filter:(PIXGuestbookFilter)filter cursor:(NSString *)cursor perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion;
/**
 *  讀取單一留言板上的留言 http://developer.pixnet.pro/#!/doc/pixnetApi/guestbookId
 *
 *  @param messageId  要被讀取的單一留言 ID，必要參數
 *  @param userName   該則留言所屬的留言板板主名稱，必要參數
 *  @param completion PIXHandlerCompletion
 */
-(void)getGuestbookMessageWithMessageID:(NSString *)messageId userName:(NSString *)userName completion:(PIXHandlerCompletion)completion;
/**
 *  回覆留言板留言，可以重覆使用這個功能來修改回覆內容 http://developer.pixnet.pro/#!/doc/pixnetApi/guestbookReply
 *
 *  @param messageId  要被回覆的留言 ID，必要參數
 *  @param body       回覆的內容，必要參數
 *  @param completion PIXHandlerCompletion
 */
-(void)replyGuestbookMessageWithMessageID:(NSString *)messageId body:(NSString *)body completion:(PIXHandlerCompletion)completion;
/**
 *  新增一則留言板留言 http://developer.pixnet.pro/#!/doc/pixnetApi/guestbookCreate
 *
 *  @param userName   被留言的板主名稱，必要參數
 *  @param body       留言內容，必要參數
 *  @param author     留言者的暱稱
 *  @param title      留言標題
 *  @param url        留言者個人網頁網址
 *  @param email      留言者電子郵件
 *  @param isOpen     是否為公開留言
 *  @param completion PIXHandlerCompletion
 */
-(void)createGuestbookMessageWithUserName:(NSString *)userName body:(NSString *)body author:(NSString *)author title:(NSString *)title url:(NSString *)url email:(NSString *)email isOpen:(BOOL)isOpen completion:(PIXHandlerCompletion)completion;
/**
 *  將留言設為公開 http://developer.pixnet.pro/#!/doc/pixnetApi/guestbookOpen
 *
 *  @param messageId  要被設定為公開的留言的 ID
 *  @param completion PIXHandlerCompletion
 */
-(void)markGuestbookMessageAsOpenWithMessageID:(NSString *)messageId completion:(PIXHandlerCompletion)completion;
/**
 *  將留言設為悄悄話 http://developer.pixnet.pro/#!/doc/pixnetApi/guestbookClose
 *
 *  @param messageId  要被設定為悄悄話的留言的 ID
 *  @param completion PIXHandlerCompletion
 */
-(void)markGuestbookMessageAsCloseWithMessageID:(NSString *)messageId completion:(PIXHandlerCompletion)completion;
/**
 *  將留言設為廣告留言 http://developer.pixnet.pro/#!/doc/pixnetApi/guestbookMarkSpam
 *
 *  @param messageId  要被設定為廣告的留言的 ID
 *  @param completion PIXHandlerCompletion
 */
-(void)markGuestbookMessageAsSpamWithMessageID:(NSString *)messageId completion:(PIXHandlerCompletion)completion;
/**
 *  將留言設為非廣告留言 http://developer.pixnet.pro/#!/doc/pixnetApi/guestbookMarkHam
 *
 *  @param messageId  要被設定為非廣告的留言的 ID
 *  @param completion PIXHandlerCompletion
 */
-(void)markGuestbookMessageAsHamWithMessageID:(NSString *)messageId completion:(PIXHandlerCompletion)completion;
/**
 *  刪除一則留言板留言 http://developer.pixnet.pro/#!/doc/pixnetApi/guestbookDelete
 *
 *  @param messageId  要被刪除的留言ID，必要參數
 *  @param completion PIXHandlerCompletion
 */
-(void)deleteGuestbookMessageWithMessageID:(NSString *)messageId completion:(PIXHandlerCompletion)completion;
@end
