//
//  PIXAlbumTests.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 4/17/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIXNETSDK.h"
#import "PIXTestObjectGenerator.h"

@interface PIXAlbumTests : XCTestCase

@end

@implementation PIXAlbumTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLogin
{
    [PIXNETSDK setConsumerKey:@"1a9dbd703c629400926a32effdda6d3f" consumerSecret:@"70218adabeb077139a5e111bd088af8f"];
    __block BOOL waiting = YES;
    [PIXNETSDK authByXauthWithUserName:@"dolphinsue" userPassword:@"parkerSue319" requestCompletion:^(BOOL succeed, id result, NSError *error) {
        waiting = NO;
        if (succeed) {
//            [self getAlbums];
            NSLog(@"logined: %@", result);
            [self GetAlbums];
        } else {
            NSLog(@"loging failed: %@", error);
            XCTFail(@"login failed");
        }
    }];
}
-(void)GetAlbums{
    __block BOOL waiting = YES;
    [[PIXNETSDK new] getAlbumSetsWithUserName:@"dolphinsue" page:1 completion:^(BOOL succeed, id result, NSError *error) {
        waiting = NO;
        if (succeed) {
            NSLog(@"albums: %@", result);
        } else {
            NSLog(@"get album sets failed: %@", error);
            XCTFail(@"get album sets failed");
        }
    }];
}
-(void)getAlbumsWithPages:(NSArray *)pages{
}
@end
