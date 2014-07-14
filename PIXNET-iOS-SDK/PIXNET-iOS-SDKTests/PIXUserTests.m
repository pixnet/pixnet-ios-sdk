//
//  PIXUserTests.m
//  PIXNET-iOS-SDK
//
//  Created by jnlin on 2014/4/9.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIXNETSDK.h"
#import "UserForTest.h"
//#import "PIXAPIHandler.h"

@interface PIXUserTests : XCTestCase
@property (nonatomic, strong) UserForTest *testUser;
@end

@implementation PIXUserTests

- (void)setUp
{
    [super setUp];
    _testUser = [[UserForTest alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMain{
    [PIXNETSDK setConsumerKey:_testUser.consumerKey consumerSecret:_testUser.consumerSecret callbackURL:_testUser.callbaclURL];
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
            XCTFail(@"auth failed: %@", error);
        }

    }];
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if (!authed) {
        return;
    }
    [self getPublicUserInfos];
    //取得 MIB 資訊
    NSDictionary *mibInfos = [self getUserMib];
    BOOL isAppliedMIB = [mibInfos[@"applied"] boolValue];
    [self createMIB];
    if (isAppliedMIB) {
        NSArray *mibPositions = [self fetchPositions:mibInfos];
        [self getMibPositionsInfo:mibPositions];
        //TODO: 後台還沒完成
//        [self updateMibPositionsInfo:mibPositions];
        [self getAnalytics];
        int isPayable = [mibInfos[@"payable"] intValue];
        switch (isPayable) {
            case 0:     //無法請款
                NSLog(@"This account is not payable, so askAccountMIBPayWithCompletion not tested. 目前無法請款");
                break;
            case 1:     //可請款
                [self askPayRevenue];
                break;
            case 2:     //請款中
                NSLog(@"This account is asking pay, 此帳號已在請款過程中");
                break;
            default:
                XCTFail(@"payable value is undefined!!");
                break;
        }

    } else {
        //TODO: 新建 MIB 仍然有問題，用 Postman 測是可以的，但用這個 SDK 就是測不過....
//        [self createMIB];
    }

//    return;
}
-(void)createMIB{
    __block BOOL done = NO;
    [[PIXUser new] createAccountMIBWithRealName:@"測試者" idNumber:@"A128123123" idImageFront:[UIImage imageNamed:@"pixFox.jpg"] idImageBack:[UIImage imageNamed:@"pixFox.jpg"] email:@"test@pixnet.tw" cellPhone:@"0999999999" mailAddress:@"台北市忠孝南路200號" domicile:@"台北市中山西路999號" enableVideoAd:YES completion:^(BOOL succeed, id result, NSError *error) {
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
-(NSDictionary *)getPublicUserInfos{
    __block BOOL done = NO;
    __block NSDictionary *infos = nil;
    [[PIXUser new] getUserWithUserName:_testUser.userName completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"getUserWithUserName";
        if (succeed) {
            NSLog(@"%@, succeed: %li", methodName, [result count]);
            NSLog(@"user infos: %@", result);
            infos = result[@"user"];
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
-(void)getAnalytics{
    __block BOOL done = NO;
    [[PIXUser new] getAccountAnalyticsWithStaticDays:45 referDays:7 completion:^(BOOL succeed, id result, NSError *error) {
        NSString *methodName = @"getAccountAnalyticsWithStaticDays";
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
//- (void)testAccount
//{
//    PIXUser *user = [PIXUser new];
//    
//    // 故意不認證，應該會回傳 False
//    [user getAccountWithCompletion:^(BOOL succeed, id result, NSError *error){
//        NSLog(@"%s", __PRETTY_FUNCTION__);
//        NSLog(@"%@", error);
//        XCTAssertFalse(succeed);
//    }];
//
//}

@end
