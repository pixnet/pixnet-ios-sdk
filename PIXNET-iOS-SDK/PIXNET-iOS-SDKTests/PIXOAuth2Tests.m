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

@interface PIXOAuth2Tests : XCTestCase
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
        [PIXNETSDK logout];
    }
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    __block UIView *rootView = appDelegate.window.rootViewController.view;
    __block UIWebView *webView = [[UIWebView alloc] initWithFrame:rootView.bounds];
    [rootView addSubview:webView];

    __block BOOL done = NO;
    [PIXAPIHandler authByOAuth2WithCallbackURL:_testUser.callbaclURL loginView:webView completion:^(BOOL succeed, id result, NSError *error) {
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
    [self getBlockList];
    //產生一個相簿
    NSString *albumSetId = [self createAlbumSet];
    //新增一張照片
    NSString *elementId = [self addElementInAlbum:albumSetId];
    //刪除相片
    [self deleteElement:elementId];


    //刪除相簿
    [self deleteAlbum:albumSetId];

    return;
}
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

@end
