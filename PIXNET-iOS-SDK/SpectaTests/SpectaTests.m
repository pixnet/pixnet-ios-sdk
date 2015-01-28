#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import "PIXNETSDK.h"
#import "UserForTest.h"

SpecBegin(SomeBlogAPI)
    __block UserForTest *userForTest = nil;
    __block NSArray *articles = nil;
    describe(@"Blog methods tests", ^{
        beforeAll(^AsyncBlock {
            [PIXNETSDK logout];
            setAsyncSpecTimeout(60 * 60);
            userForTest = [[UserForTest alloc] init];
            [PIXNETSDK setConsumerKey:userForTest.consumerKey consumerSecret:userForTest.consumerSecret];
            id <UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
            UIView *rootView = appDelegate.window.rootViewController.view;
            UIWebView *webView = [[UIWebView alloc] initWithFrame:rootView.bounds];
            [rootView addSubview:webView];
            [PIXNETSDK loginByOAuthLoginView:webView completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect([PIXNETSDK isAuthed]).to.beTruthy();
                if (succeed) {
                    [webView removeFromSuperview];
                } else {
                    [PIXNETSDK logout];
                }
                done();
            }];
        });
        it(@"get blog articles", ^AsyncBlock {
            expect([PIXNETSDK isAuthed]).to.beTruthy();
            [[PIXNETSDK new] getBlogAllArticlesWithUserName:userForTest.userName password:userForTest.userPassword page:1 perpage:10 completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                if (succeed) {
                    articles = result[@"articles"];
                }
                NSLog(@"articles: %@", articles);
                done();
            }];
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