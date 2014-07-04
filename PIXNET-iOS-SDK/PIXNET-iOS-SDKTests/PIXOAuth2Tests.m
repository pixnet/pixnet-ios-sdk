//
//  PIXOAuth2Tests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 6/24/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//
static NSString *kSetTitle = @"Unit test set";
static NSString *kSetDescription = @"Unit test set description";

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "PIXNETSDK.h"
#import "AppDelegate.h"
#import "UserForTest.h"

@interface PIXOAuth2Tests : XCTestCase<UIWebViewDelegate>
@property (nonatomic, strong) UserForTest *testUser;

@end

@implementation PIXOAuth2Tests

- (void)setUp
{
    [super setUp];
    _testUser = [[UserForTest alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMain{
    [PIXNETSDK setConsumerKey:_testUser.consumerKey consumerSecret:_testUser.consumerSecret callbackURL:_testUser.callbaclURL];
    if ([PIXNETSDK isAuthed]) {
//        [PIXNETSDK logout];
    }
    if (![PIXNETSDK isAuthed]) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        __block UIView *rootView = appDelegate.window.rootViewController.view;
        __block UIWebView *webView = [[UIWebView alloc] initWithFrame:rootView.bounds];
        webView.delegate = self;
        [rootView addSubview:webView];
        
        __block BOOL done = NO;
        [PIXAPIHandler authByOAuth2WithLoginView:webView completion:^(BOOL succeed, id result, NSError *error) {
            if (succeed) {
                if ([PIXAPIHandler isAuthed]) {
                    [webView removeFromSuperview];
                    NSLog(@"login token: %@", result);
                } else {
                    XCTFail(@"login not succeed");
                }
            } else {
                XCTFail(@"login failed: %@", error);
            }
            done = YES;
        }];
        while (!done) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    if (![PIXNETSDK isAuthed]) {
        return;
    }
    [self getBlockList];
    //產生一個相簿
    NSString *albumSetId = [self createAlbumSet];
    //新增一張照片
//    NSString *elementId = [self addElementInAlbum:albumSetId];
    //刪除相片
//    if (elementId) {
//        [self deleteElement:elementId];
//    }

    //刪除相簿
    [self deleteAlbum:albumSetId];
    
    //取得 private user info
    [self getUserAccount];
    
    //更改使用者資訊
    [self editUserAccount];
    //改密碼
    [self updatePassword];
    
    //取得 MIB 資訊
    NSDictionary *mibInfos = [self getUserMib];
    BOOL isAppliedMIB = [mibInfos[@"applied"] boolValue];
    if (isAppliedMIB) {
        NSArray *mibPositions = [self fetchPositions:mibInfos];
        [self getMibPositionsInfo:mibPositions];
        //好像後台還沒完成這個 api
//        [self updateMibPositionsInfo:mibPositions];
        [self getAnalytics];
        BOOL isPayable = [mibInfos[@"payable"] boolValue];
        if (isPayable) {
            [self askPayRevenue];
        } else {
            NSLog(@"This account is not payable, so askAccountMIBPayWithCompletion not tested.");
        }
    } else {
        [self createMIB];
    }
    
    return;
}
-(void)askPayRevenue{
    __block BOOL done = NO;
    [[PIXUser new] askAccountMIBPayWithCompletion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"askAccountMIBPayWithCompletion";
        if (succeed) {
            NSLog(@"%@, succeed: %@", methodName, result);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)updatePassword{
    __block BOOL done = NO;
    [[PIXUser new] updateAccountPasswordWithOriginalPassword:_testUser.userPassword newPassword:_testUser.userPassword completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"updateAccountPasswordWithOriginalPassword";
        if (succeed) {
            NSLog(@"%@, succeed: %@", methodName, result);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getAnalytics{
    __block BOOL done = NO;
    [[PIXUser new] getAccountAnalyticsWithStaticDays:45 referDays:7 completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"getAccountAnalyticsWithStaticDays";
        if (succeed) {
            NSLog(@"%@, succeed: %@", methodName, result);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)updateMibPositionsInfo:(NSArray *)positions{
    for (NSString *positionId in positions) {
        __block BOOL done = NO;
        int randomValue = arc4random()%2;
        [[PIXUser new] updateAccountMIBPositionWithPositionID:positionId enabled:[NSNumber numberWithBool:randomValue] fixedAdBox:[NSNumber numberWithBool:randomValue] completion:^(BOOL succeed, id result, NSError *error) {
            NSString *methodName = @"updateAccountMIBPositionWithPositionID";
            if (succeed) {
                NSLog(@"%@, succeed, positionId: %@", methodName, positionId);
            } else {
                XCTFail(@"%@ failed: %@, positionId: %@", methodName, error, positionId);
            }
            done = YES;
        }];
        
        while (!done) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    return;
}
-(void)createMIB{
    __block BOOL done = NO;
    [[PIXUser new] createAccountMIBWithRealName:@"蘇聖傑" idNumber:@"A123456789" idImageFront:[UIImage imageNamed:@"pixFox.jpg"] idImageBack:[UIImage imageNamed:@"pixFox.jpg"] email:@"xxx@pixnet.tw" cellPhone:@"09110123456" mailAddress:@"台北市忠孝南路200號" domicile:@"台北市中山西路999號" enableVideoAd:YES completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"createAccountMIBWithRealName";
        if (succeed) {
            NSLog(@"%@, succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getMibPositionsInfo:(NSArray *)positions{
    for (NSString *positionId in positions) {
        __block BOOL done = NO;
        [[PIXUser new] getAccountMIBPositionWithPositionID:positionId completion:^(BOOL succeed, id result, NSError *error) {
            NSString *methodName = @"getAccountMIBPositionWithPositionID";
            if (succeed) {
                NSLog(@"%@, succeed, positionId: %@", methodName, positionId);
            } else {
                XCTFail(@"%@ failed: %@", methodName, error);
            }
            done = YES;
        }];
        
        while (!done) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    return;
}
-(NSArray *)fetchPositions:(NSDictionary *)mibInfos{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *positionsInArticle = mibInfos[@"blog"][@"positions"][@"article"];
    for (NSDictionary *position in positionsInArticle) {
        [array addObject:position[@"id"]];
    }
    NSArray *positionInBlog = mibInfos[@"blog"][@"positions"][@"blog"];
    for (NSDictionary *position in positionInBlog) {
        [array addObject:position[@"id"]];
    }
    return array;
}
-(NSDictionary *)getUserMib{
    __block BOOL done = NO;
    __block NSDictionary *infos = nil;
    [[PIXUser new] getAccountMIBWithHistoryDays:1 completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"getAccountMibWithHistoryDays";
        if (succeed) {
            NSLog(@"%@, succeed: %li", methodName, [result count]);
            NSLog(@"MIB content: %@", result);
            infos = result[@"mib"];
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return infos;
}
-(void)editUserAccount{
    __block BOOL done = NO;
    UIImage *image = [UIImage imageNamed:@"pixFox.jpg"];
    [[PIXUser new] updateAccountWithPassword:_testUser.userPassword displayName:nil email:nil gender:PIXUserGenderNone address:nil phone:nil birth:nil education:PIXUserEducationNone avatar:image completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"editAccountWithPassword";
        if (succeed) {
            NSLog(@"%@, succeed: %@", methodName, result);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
-(void)getUserAccount{
    for (PIXUserNotificationType type=PIXUserNotificationTypeAll; type<=PIXUserNotificationTypeAppMarket; type++) {
        __block BOOL done = NO;
        [[PIXUser new] getAccountWithNotification:YES notificationType:type withBlogInfo:YES withMib:YES withAnalytics:YES completion:^(BOOL succeed, id result, NSError *error) {
            NSString *methodName = @"getAccountWithNotification";
            if (succeed) {
                NSLog(@"%@, succeed: %li", methodName, type);
            } else {
                XCTFail(@"%@ failed: %@", methodName, error);
            }
            done = YES;
        }];
        
        while (!done) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    return;
}
//-(void)finishLoad:(NSNotification *)sender{
//    NSLog(@"notification object: %@", sender.object);
//}
-(void)deleteAlbum:(NSString *)albumId{
    __block BOOL done = NO;
    
    [[PIXNETSDK new] deleteAlbumSetWithSetID:albumId completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"deleteAlbumSetWithSetID by oauth2";
        if (succeed) {
            NSLog(@"%@, succeed: %@", methodName, result);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}

-(void)getBlockList{
    __block BOOL done = NO;
    [[PIXNETSDK new] getBlocksWithCompletion:^(BOOL succeed, id result, NSError *error) {
        done = YES;
        NSString *methodName = @"getBlocksWithCompletion by oauth2";
        if (succeed) {
            NSLog(@"%@, succeed: %@", methodName, result);
        } else {
            XCTFail(@"%@ failed: %@", methodName, error);
        }
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
// 建立一個 set
-(NSString *)createAlbumSet{
    __block BOOL done = NO;
    __block NSString *setId = nil;
    [[PIXNETSDK new] createAlbumSetWithTitle:kSetTitle description:kSetDescription permission:PIXAlbumSetPermissionTypeOpen isAllowCC:YES commentRightType:PIXAlbumSetCommentRightTypeAll password:nil passwordHint:nil friendGroupIDs:nil parentID:nil completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"createAlbumSetWithTitle by oauth2";
        if (succeed) {
            setId = result[@"set"][@"id"];
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@\n", methodName, error);
        }
        done = YES;
    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return setId;
}
-(NSString *)addElementInAlbum:(NSString *)albumId{
    __block BOOL done = NO;
    __block NSString *elementId = nil;
//    NSURL *movieURL = [[NSBundle mainBundle] URLForResource:@"SHLCutted" withExtension:@"mpg"];
//    NSData *data = [NSData dataWithContentsOfURL:movieURL];
    UIImage *image = [UIImage imageNamed:@"pixFox.jpg"];
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    [[PIXNETSDK new] createElementWithElementData:data setID:albumId elementTitle:@"unit test photo title" elementDescription:@"unit test photo description" tags:nil location:kCLLocationCoordinate2DInvalid completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"createElementWithElementData by oauth2";
        if (succeed) {
            elementId = result[@"element"][@"id"];
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@\n", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return elementId;
}
-(void)deleteElement:(NSString *)elementId{
    __block BOOL done = NO;
    [[PIXNETSDK new] deleteElementWithElementID:elementId completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"deleteElementWithElementID by oauth2";
        if (succeed) {
            NSLog(@"%@ succeed", methodName);
        } else {
            XCTFail(@"%@ failed: %@\n", methodName, error);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return;
}
#pragma webView delegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"webView:didFailLoadWithError:%@", error);
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad:");
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad:");
}
@end
