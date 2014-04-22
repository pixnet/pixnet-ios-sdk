//
//  PIXAlbumTests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/17/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

//開始測試則請先設定好這四個常數
static NSString *kUser = @"";
static NSString *kUserPassword = @"";
static NSString *kConsumerKey = @"";
static NSString *kConsumerSecret = @"";

static NSString *kFolderTitle = @"Unit test folder title";
static NSString *kSetTitle = @"Unit test set";
static NSString *kSetDescription = @"Unit test set description";
static NSString *kSetComment = @"Unit test comment in set";

#import <XCTest/XCTest.h>
#import "PIXNETSDK.h"
#import "PIXTestObjectGenerator.h"

@interface PIXAlbumTests : XCTestCase
@property (nonatomic, strong) XCTestLog *testLog;

@end

@implementation PIXAlbumTests

- (void)setUp
{
    [super setUp];
    _testLog = [XCTestLog new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMain
{
    [PIXNETSDK setConsumerKey:kConsumerKey consumerSecret:kConsumerSecret];
    __block BOOL done = NO;
    //登入
    [PIXNETSDK authByXauthWithUserName:kUser userPassword:kUserPassword requestCompletion:^(BOOL succeed, id result, NSError *error) {
        //產生一個 folder
        NSString *folderId = [self createAlbumFolder];
        //產生一個相簿
        NSString *albumSetId = [self createAlbumSet];
        //產生一個相簿裡的留言
        NSString *commentId = [self createAlbumSetComment:albumSetId Comment:kSetComment];
        //將留言設為廣告
        [self markCommentInSetAsSpam:commentId];
        //將留言設為非廣告
        [self markCommentInSetAsHam:commentId];
        //取得相簿裡所有留言
//        NSArray *commentArray = [self getAlbumSetComments:albumSetId];
        //將相簿移到 folder 底下
        [self removeSet:albumSetId toFolder:folderId];
        
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}
//將相簿裡的某則留言設為非廣告
-(BOOL)markCommentInSetAsHam:(NSString *)commentId{
    __block BOOL done = NO;
    __block BOOL spamed = NO;
    
    [[PIXNETSDK new] markCommentAsHamWithCommentID:commentId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            spamed = YES;
            [_testLog testLogWithFormat:@"mark comment in set as ham: %@\n", commentId];
        } else {
            XCTFail(@"mark comment in set as ham failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return spamed;
}

//將相簿裡的某則留言設為廣告
-(BOOL)markCommentInSetAsSpam:(NSString *)commentId{
    __block BOOL done = NO;
    __block BOOL spamed = NO;

    [[PIXNETSDK new] markCommentAsSpamWithCommentID:commentId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            spamed = YES;
            [_testLog testLogWithFormat:@"mark comment in set as spam: %@\n", commentId];
        } else {
            XCTFail(@"mark comment in set as spam failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return spamed;
}
-(NSArray *)getAlbumSetComments:(NSString *)setId{
    __block BOOL done = NO;
    __block NSArray *array = nil;
    [[PIXNETSDK new] getAlbumSetCommentsWithUserName:kUser setID:setId password:nil page:1 completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            array = result[@"comments"];
            [_testLog testLogWithFormat:@"album set comments count: %lu in album set: %@\n", (unsigned long)array.count, setId];
        } else {
            XCTFail(@"get comments in album set failed: %@\n", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return array;
}
-(NSString *)createAlbumSetComment:(NSString *)setId Comment:(NSString *)comment{
    __block BOOL done = NO;
    __block NSString *commentId = nil;
    [[PIXNETSDK new] createAlbumSetCommentWithSetID:setId body:comment password:nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            commentId = result[@"comment"][@"id"];
            [_testLog testLogWithFormat:@"create comment in set succeed: %@ album set: %@\n", commentId, setId];
        } else {
            
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return commentId;
}
-(BOOL)removeSet:(NSString *)setId toFolder:(NSString *)folderId{
    __block BOOL done = NO;
    __block BOOL moved = NO;
    [[PIXNETSDK new] updateAlbumSetWithSetID:setId setTitle:kSetTitle setDescription:kSetDescription permission:PIXAlbumSetPermissionTypeOpen categoryID:0 isLockRight:NO isAllowCC:YES commentRightType:PIXAlbumSetCommentRightTypeAll password:nil passwordHint:nil friendGroupIDs:nil allowCommercialUse:YES allowDerivation:YES parentID:folderId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            moved = YES;
        } else {
            XCTFail(@"update album set failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return moved;
}
//建立一個 folder
-(NSString *)createAlbumFolder{
    __block BOOL done = NO;
    __block NSString *folderId = nil;
    [[PIXNETSDK new] createAlbumFolderWithTitle:kFolderTitle description:@"unit test folder description" completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            folderId = result[@"folder"][@"id"];
            [_testLog testLogWithFormat:@"create folder succeed: %@", folderId];
        } else {
            XCTFail(@"create folder failed: %@", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return folderId;
}
// 建立一個 set
-(NSString *)createAlbumSet{
    __block BOOL done = NO;
    __block NSString *setId = nil;
    [[PIXNETSDK new] createAlbumSetWithTitle:kSetTitle description:kSetDescription permission:PIXAlbumSetPermissionTypeOpen isAllowCC:YES commentRightType:PIXAlbumSetCommentRightTypeAll password:nil passwordHint:nil friendGroupIDs:nil parentID:nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            setId = result[@"set"][@"id"];
            [_testLog testLogWithFormat:@"create set succeed: %@\n", setId];
        } else {
            XCTFail(@"create album set failed: %@\n", error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return setId;
}
-(NSArray *)getAlbumSetsAndFolders{
    __block BOOL done = NO;
    __block NSArray *array = nil;
    [[PIXNETSDK new] getAlbumSetsWithUserName:@"dolphinsue" page:1 completion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        if (succeed) {
            array = result[@"setfolders"];
            [_testLog testLogWithFormat:@"album set count: %lu\n", (unsigned long)array.count];
        } else {
            NSLog(@"get album sets failed: %@", error);
            XCTFail(@"get album sets failed");
        }
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return array;
}
-(NSArray *)getAlbumSets{
    __block BOOL done = NO;
    __block NSArray *array = nil;
    [[PIXNETSDK new] getAlbumSetsWithUserName:@"dolphinsue" parentID:nil page:1 completion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        if (succeed) {
            array = result[@"sets"];
        } else {
            NSLog(@"get album sets failed: %@", error);
            XCTFail(@"get album sets failed");
        }
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return array;
}
@end
