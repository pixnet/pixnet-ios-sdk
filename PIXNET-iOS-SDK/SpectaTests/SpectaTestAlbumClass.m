#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import "PIXNETSDK.h"
#import "UserForTest.h"
#import "KWValue.h"

SpecBegin(TestAlbumAPIs)
__block UserForTest *userForTest = nil;
__block NSString *systemAlbum;
__block NSArray *albumsAndFolders;
describe(@"These methods are auth needed", ^{
    beforeAll( ^{
        
        setAsyncSpecTimeout(60 * 60);
        waitUntil(^(DoneCallback done) {
            userForTest = [[UserForTest alloc] init];
            [PIXNETSDK setConsumerKey:userForTest.consumerKey consumerSecret:userForTest.consumerSecret];
            [PIXNETSDK logout];
            
            id <UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
            UIView *rootView = appDelegate.window.rootViewController.view;
            UIWebView *webView = [[UIWebView alloc] initWithFrame:rootView.bounds];
            [rootView addSubview:webView];
            [PIXNETSDK loginByOAuth2OpenIDOnlyWithLoginView:webView completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                if (succeed) {
                    setAsyncSpecTimeout(60);
                    //Email or Phone
                    //Facebook Password
                    //好的, 允許
                    expect([PIXNETSDK isAuthed]).to.beTruthy();
                    [webView removeFromSuperview];
                } else {
                    [PIXNETSDK logout];
                }
                done();
            }];
        });
    });
    
    // 取得所有相簿
    it(@"get all album sets",  ^{
        
        waitUntil(^(DoneCallback done) {
            [[PIXNETSDK new] getAlbumSetsWithUserName:userForTest.userName page:1 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                if (succeed) {
                    albumsAndFolders = result[@"setfolders"];
                }
                done();
            }];
        });
    });
    // 取得主相簿及主系統相簿ID
    it(@"get main album",  ^{
        
        waitUntil(^(DoneCallback done) {
            [[PIXNETSDK new] getAlbumMainWithCompletion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                if (succeed) {
                    systemAlbum = result[@"system_albumset_id"];
                    XCTAssertNotNil(systemAlbum);
                }
                done();
            }];
        });
    });
    it(@"create element in system album",  ^{
        waitUntil(^(DoneCallback done) {
            expect(systemAlbum).notTo.beNil();
            UIImage *image = [UIImage imageNamed:@"pixFox.jpg"];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            [[PIXNETSDK new] createElementWithElementData:imageData setID:systemAlbum elementTitle:nil elementDescription:nil tags:nil location:kCLLocationCoordinate2DInvalid completion:^(BOOL succeed, id result, NSError *error) {
                XCTAssertTrue(succeed);
                if (!succeed) {
                    NSLog(@"create element failed: %@", error);
                }
                done();
            }];
        });
    });
    
    afterAll(^{
        [PIXNETSDK logout];
        expect([PIXNETSDK isAuthed]).toNot.beTruthy();
    });
});
SpecEnd
