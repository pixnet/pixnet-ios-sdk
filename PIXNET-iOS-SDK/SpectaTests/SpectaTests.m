#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import "PIXNETSDK.h"
#import "UserForTest.h"

SpecBegin(SomeBlogAPI)
    describe(@"Blog methods tests", ^{
        beforeAll(^AsyncBlock {
            setAsyncSpecTimeout(60 * 60);
            UserForTest *userForTest = [[UserForTest alloc] init];
            [PIXNETSDK setConsumerKey:userForTest.consumerKey consumerSecret:userForTest.consumerSecret];
            id <UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
            UIView *rootView = appDelegate.window.rootViewController.view;
            UIWebView *webView = [[UIWebView alloc] initWithFrame:rootView.bounds];
            [rootView addSubview:webView];
            [PIXNETSDK loginByOAuthLoginView:webView completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect([PIXNETSDK isAuthed]).to.beTruthy();
                done();
            }];
        });
        it(@"", ^{
            NSLog(@"here!");
        });
        afterAll(^{
           [PIXNETSDK logout];
            expect([PIXNETSDK isAuthed]).toNot.beTruthy();
        });
    });
    describe(@"get site categories for article", ^{
        it(@"should get categories", ^AsyncBlock {
            [[PIXBlog new] getSiteCategoriesForArticleWithGroups:YES isIncludeThumbs:YES completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                done();
            }];
        });
    });
    describe(@"get site categories for blog", ^{
        it(@"should get categories", ^AsyncBlock{
            [[PIXBlog new] getSiteCategoriesForBlogWithGroups:YES isIncludeThumbs:YES completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                done();
            }];
        });
    });
SpecEnd