//
//  PIXAlbumTests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/17/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

//開始測試則請先設定好這四個常數
static NSString *kUser = @"dolphinsue";
static NSString *kUserPassword = @"howardSue319";
static NSString *kConsumerKey = @"1a9dbd703c629400926a32effdda6d3f";
static NSString *kConsumerSecret = @"70218adabeb077139a5e111bd088af8f";

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
        //列出相簿主圖及相片牆
        [self getAlbumMain];
        //列出相簿及folder 列表
        [self getAlbumSetsAndFolders];
        
        //產生一個 folder
        NSString *folderId = [self createAlbumFolder];
        //修改 folder
        [self updateFolder:folderId];
        //取得 folder 列表
        [self getAlbumFolders];
        
        //產生一個相簿
        NSString *albumSetId = [self createAlbumSet];
        //修改相簿
        [self updateAlbum:albumSetId];
        //取得相簿列表
        NSArray *albums = [self getAlbumSets];
        //修改相簿的順序
        [self sortAlbumsWithOrdinaryAlbums:albums];
        //取得附近的相簿
        [self getAlbumsetsNearby];
        
        //產生一個相簿裡的留言
        NSString *commentId = [self createAlbumSetComment:albumSetId Comment:kSetComment];
        //將相簿留言設為廣告
        [self markCommentInSetAsSpam:commentId];
        //將相簿留言設為非廣告
        [self markCommentInSetAsHam:commentId];
        //取得相簿裡所有留言
        [self getAlbumSetComments:albumSetId];
        //將相簿移到 folder 底下
        [self removeSet:albumSetId toFolder:folderId];
        
        //新增一張照片
        [self addElementInAlbum:albumSetId];
        
        //刪除相簿
        [self deleteAlbum:albumSetId];
        //刪除資料夾
        [self deleteFolder:folderId];
        
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}
-(NSString *)addElementInAlbum:(NSString *)albumId{
    __block BOOL done = NO;
    __block NSString *elementId = nil;
    UIImage *image = [UIImage imageNamed:@"pixFox.jpg"];
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    [[PIXNETSDK new] addElementWithElementData:data setID:albumId elementTitle:@"unit test photo title" elementDescription:@"unit test photo description" tags:nil location:kCLLocationCoordinate2DInvalid completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"add element succeed");
            elementId = result[@"element"][@"id"];
        } else {
            XCTFail(@"mark comment in set as ham failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return elementId;
}
-(void)getAlbumMain{
    __block BOOL done = NO;
    [[PIXNETSDK new] getAlbumMainWithCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"get album main succeed");
            NSLog(@"albums in main: %@", result);
        } else {
            XCTFail(@"mark comment in set as ham failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getAlbumsetsNearby{
    __block BOOL done = NO;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(25.0685028,121.5456014);
    [[PIXNETSDK new] getAlbumSetsNearbyWithUserName:kUser location:location distanceMin:1 distanceMax:5000 page:1 completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"get nearby albums count: %li", [result[@"sets"] count]);
        } else {
            XCTFail(@"mark comment in set as ham failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
//將首頁的相簿以相反的順序排序
-(void)sortAlbumsWithOrdinaryAlbums:(NSArray *)oAlbums{
    __block BOOL done = NO;
    NSMutableArray *nArray = [NSMutableArray new];
    for (NSDictionary *album in oAlbums) {
        [nArray addObject:album[@"id"]];
    }
    NSArray *reversedArray = [[nArray reverseObjectEnumerator] allObjects];
    [[PIXNETSDK new] sortSetFoldersWithFolderIDs:reversedArray completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"albums are reversed");
        } else {
            XCTFail(@"mark comment in set as ham failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}

-(void)getAlbumFolders{
    __block BOOL done = NO;
    [[PIXNETSDK new] getAlbumFoldersWithUserName:kUser trimUser:NO page:1 completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [_testLog testLogWithFormat:@"get folders succeed, folders count: %lu\n", (unsigned long)[result[@"setfolders"] count]];
        } else {
            XCTFail(@"mark comment in set as ham failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)updateFolder:(NSString *)folderId{
    __block BOOL done = NO;
    [[PIXNETSDK new] updateAlbumFolderWithFolderID:folderId title:@"folder title updated" description:@"folder description updated" completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [_testLog testLogWithFormat:@"folder updated: %@\n", folderId];
        } else {
            XCTFail(@"mark comment in set as ham failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)updateAlbum:(NSString *)albumId{
    __block BOOL done = NO;
    [[PIXNETSDK new] updateAlbumSetWithSetID:albumId setTitle:@"album title updated" setDescription:@"album description updated" permission:PIXAlbumSetPermissionTypeOpen categoryID:nil isLockRight:NO isAllowCC:NO commentRightType:PIXAlbumSetCommentRightTypeFriend password:nil passwordHint:nil friendGroupIDs:nil allowCommercialUse:NO allowDerivation:NO parentID:nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [_testLog testLogWithFormat:@"album updated: %@\n", albumId];
        } else {
            XCTFail(@"mark comment in set as ham failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)deleteFolder:(NSString *)folderId{
    __block BOOL done = NO;
    
    [[PIXNETSDK new] deleteAlbumFolderWithFolderID:folderId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [_testLog testLogWithFormat:@"delete folder: %@\n", folderId];
        } else {
            XCTFail(@"mark comment in set as ham failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)deleteAlbum:(NSString *)albumId{
    __block BOOL done = NO;

    [[PIXNETSDK new] deleteAlbumSetWithSetID:albumId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [_testLog testLogWithFormat:@"delete album: %@\n", albumId];
        } else {
            XCTFail(@"mark comment in set as ham failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
//將相簿裡的某則留言設為非廣告
-(BOOL)markCommentInSetAsHam:(NSString *)commentId{
    __block BOOL done = NO;
    __block BOOL spamed = NO;
    
    [[PIXNETSDK new] markAlbumSetCommentAsHamWithCommentID:commentId completion:^(BOOL succeed, id result, NSError *error) {
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

    [[PIXNETSDK new] markAlbumSetCommentAsSpamWithCommentID:commentId completion:^(BOOL succeed, id result, NSError *error) {
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
            NSLog(@"album set comments count: %lu in album set: %@\n", (unsigned long)array.count, setId);
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
            NSLog(@"album set and folders count: %lu", (unsigned long)array.count);
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
            NSLog(@"get album sets count: %li", [array count]);
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
