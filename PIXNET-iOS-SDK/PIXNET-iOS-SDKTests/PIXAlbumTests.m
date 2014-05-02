//
//  PIXAlbumTests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/17/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

//開始測試則請先設定好這四個常數
//static NSString *kUser = @"";
//static NSString *kUserPassword = @"";
//static NSString *kConsumerKey = @"";
//static NSString *kConsumerSecret = @"";

static NSString *kFolderTitle = @"Unit test folder title";
static NSString *kSetTitle = @"Unit test set";
static NSString *kSetDescription = @"Unit test set description";
static NSString *kSetComment = @"Unit test comment in set";

#import <XCTest/XCTest.h>
#import "PIXNETSDK.h"
#import "PIXTestObjectGenerator.h"
#import "UserForTest.h"

@interface PIXAlbumTests : XCTestCase
@property (nonatomic, strong) XCTestLog *testLog;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) UserForTest *testUser;

@end

@implementation PIXAlbumTests

- (void)setUp
{
    [super setUp];
    _testLog = [XCTestLog new];
    _location = CLLocationCoordinate2DMake(25.0685028,121.5456014);
    _testUser = [[UserForTest alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMain
{
    [PIXNETSDK setConsumerKey:_testUser.consumerKey consumerSecret:_testUser.consumerSecret];
    __block BOOL done = NO;

    [PIXNETSDK logout];
    
    __block BOOL authed = NO;
    //登入
    [PIXNETSDK authByXauthWithUserName:_testUser.userName userPassword:_testUser.userPassword requestCompletion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        if (succeed) {
            NSLog(@"auth succeed!");
            authed = YES;
        } else {
            NSLog(@"auth failed: %@", error);
        }
        
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if (!authed) {
        return;
    }
    //列出相簿全站分類
    [self getAlbumSiteCategories];
    //列出相簿個人設定
    [self getAlbumConfig];
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
    NSString *elementId = [self addElementInAlbum:albumSetId];
    //修改相片
    [self updateElement:elementId];

    //新增相片留言
    NSString *elementCommentId = [self createElementComment:elementId];
    //讀取相片裡所有留言
    [self getElementComments:elementId];
    //將相片裡的留言設為廣告
    [self markElementCommentAsSpam:elementCommentId];
    //將相片裡的留言設為非廣告
    [self markElementCommentAsHam:elementCommentId];
    
    //新增人臉標記
    NSString *faceId = [self tagFaceOnElement:elementId];
    //更新人臉標記
    [self updateFace:faceId element:elementId];
    
    //讀取單一照片
    [self getElement:elementId];
    
    //刪除人臉標記
    [self deleteFace:faceId];
    //刪除相片裡的留言
    [self deleteElementComment:elementCommentId];
    //刪除相片
    [self deleteElement:elementId];
    //刪除相簿
    [self deleteAlbum:albumSetId];
    //刪除資料夾
    [self deleteFolder:folderId];


}
-(void)getAlbumSiteCategories{
    __block BOOL done = NO;
    [[PIXNETSDK new] getAlbumSiteCategoriesWithIsIncludeGroups:YES isIncludeThumbs:NO completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"get album site categories succeed");
        } else {
            XCTFail(@"get album site categories failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getAlbumConfig{
    __block BOOL done = NO;
    [[PIXNETSDK new] getAlbumConfigWithCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"get album config succeed");
        } else {
            XCTFail(@"get album config failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)deleteFace:(NSString *)faceId{
    __block BOOL done = NO;
    [[PIXNETSDK new] deleteTagWithFaceID:faceId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"face tag is deleted: %@", faceId);
        } else {
            XCTFail(@"delete face tag failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)updateFace:(NSString *)faceId element:(NSString *)elementId{
    __block BOOL done = NO;
    [[PIXNETSDK new] updateTagedFaceWithFaceId:faceId elementId:elementId beTaggedUser:_testUser.userName newTagFrame:CGRectMake(20, 20, 10, 10) completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"face tag is updated: %@", faceId);
        } else {
            XCTFail(@"update face tag failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(NSString *)tagFaceOnElement:(NSString *)elementId{
    __block BOOL done = NO;
    __block NSString *faceId = nil;
    [[PIXNETSDK new] tagFriendWithElementID:elementId beTaggedUser:_testUser.userName tagFrame:CGRectMake(0, 0, 10, 10) completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            faceId = result[@"element"][@"faces"][@"tagged"][0][@"id"];
            NSLog(@"tag face succeed: %@", faceId);
        } else {
            XCTFail(@"tag face failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return faceId;
}
-(void)deleteElementComment:(NSString *)commentId{
    __block BOOL done = NO;
    [[PIXNETSDK new] deleteCommentWithCommentID:commentId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"element comment has been deleted: %@", commentId);
        } else {
            XCTFail(@"delete element comment failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)deleteElement:(NSString *)elementId{
    __block BOOL done = NO;
    [[PIXNETSDK new] deleteElementWithElementID:elementId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"element has been deleted: %@", elementId);
        } else {
            XCTFail(@"delete element failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)markElementCommentAsHam:(NSString *)commentId{
    __block BOOL done = NO;
    [[PIXNETSDK new] markCommentAsHamWithCommentID:commentId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"mark element comment as ham: %@", commentId);
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
-(void)markElementCommentAsSpam:(NSString *)commentId{
    __block BOOL done = NO;
    [[PIXNETSDK new] markCommentAsSpamWithCommentID:commentId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"mark element comment as spam: %@", commentId);
        } else {
            XCTFail(@"mark comment in set as spam failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getElementComments:(NSString *)elementId{
    __block BOOL done = NO;
    [[PIXNETSDK new] getElementCommentsWithUserName:_testUser.userName elementID:elementId password:nil page:1 completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"get element comments count: %lu", (unsigned long)[result[@"comments"] count]);
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
-(NSString *)createElementComment:(NSString *)elementId{
    __block BOOL done = NO;
    __block NSString *comId = nil;
    [[PIXNETSDK new] createElementCommentWithElementID:elementId body:@"unit test comment body in element" password:nil completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            comId = result[@"comment"][@"id"];
            NSLog(@"create element comment succeed: %@", comId);
        } else {
            XCTFail(@"mark comment in set as ham failed: %@", error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return comId;
}
-(void)getElement:(NSString *)elementId{
    __block BOOL done = NO;
    [[PIXNETSDK new] getElementWithUserName:_testUser.userName elementID:elementId completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"get element succeed: %@", elementId);
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
-(void)updateElement:(NSString *)elementId{
    __block BOOL done = NO;
    [[PIXNETSDK new] updateElementWithElementID:elementId elementTitle:@"updated element title" elementDescription:@"updated element description" setID:nil videoThumbType:PIXVideoThumbTypeNone tags:nil location:_location completion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            NSLog(@"update element succeed: %@", elementId);
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
    [[PIXNETSDK new] getAlbumSetsNearbyWithUserName:_testUser.userName location:_location distanceMin:1 distanceMax:5000 page:1 completion:^(BOOL succeed, id result, NSError *error) {
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
    [[PIXNETSDK new] getAlbumFoldersWithUserName:_testUser.userName trimUser:NO page:1 completion:^(BOOL succeed, id result, NSError *error) {
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
    [[PIXNETSDK new] getAlbumSetCommentsWithUserName:_testUser.userName setID:setId password:nil page:1 completion:^(BOOL succeed, id result, NSError *error) {
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
    [[PIXNETSDK new] getAlbumSetsWithUserName:_testUser.userName page:1 completion:^(BOOL succeed, id result, NSError *error) {
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
    [[PIXNETSDK new] getAlbumSetsWithUserName:_testUser.userName parentID:nil page:1 completion:^(BOOL succeed, id result, NSError *error) {
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
