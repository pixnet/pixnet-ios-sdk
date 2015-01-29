#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import "PIXNETSDK.h"
#import "UserForTest.h"

SpecBegin(SomeBlogAPI)
    __block UserForTest *userForTest = nil;
    __block NSArray *articles = nil;
    __block NSDictionary *article = nil;
    __block NSMutableArray *comments = nil;
    describe(@"Blog methods tests", ^{
        beforeAll(^AsyncBlock {
            [PIXNETSDK logout];
            setAsyncSpecTimeout(60 * 60);
            userForTest = [[UserForTest alloc] init];
            comments = [NSMutableArray new];
            [PIXNETSDK setConsumerKey:userForTest.consumerKey consumerSecret:userForTest.consumerSecret];
            id <UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
            UIView *rootView = appDelegate.window.rootViewController.view;
            UIWebView *webView = [[UIWebView alloc] initWithFrame:rootView.bounds];
            [rootView addSubview:webView];
            [PIXNETSDK loginByOAuthLoginView:webView completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect([PIXNETSDK isAuthed]).to.beTruthy();
                if (succeed) {
                    setAsyncSpecTimeout(10);
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
                    article = articles[1];
                }
                done();
            }];
        });
        it(@"leave comment 1", ^AsyncBlock {
            expect(comments).toNot.beNil();
            [[PIXNETSDK new] createBlogCommentWithArticleID:article[@"id"] body:@"unit test message" userName:userForTest.userName author:userForTest.userPassword title:@"unit test title" url:nil isOpen:YES email:nil blogPassword:nil articlePassword:nil completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                if (succeed) {
                    [comments addObject:result[@"comment"][@"id"]];
                }
                done();
            }];

        });
        it(@"leave comment 2", ^AsyncBlock{
            [[PIXNETSDK new] createBlogCommentWithArticleID:article[@"id"] body:@"unit test message" userName:userForTest.userName author:nil title:@"unit test title" url:nil isOpen:NO email:nil blogPassword:nil articlePassword:nil completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                if (succeed) {
                    [comments addObject:result[@"comment"][@"id"]];
                }
                done();
            }];
        });
        it(@"set comments as close", ^AsyncBlock{
            expect(comments.count == 2).to.beTruthy();
            [[PIXBlog new] updateBlogCommentsOpenWithComments:comments isOpen:YES completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                done();
            }];
        });
        it(@"set comments as open", ^AsyncBlock{
            [[PIXNETSDK new] updateBlogCommentsOpenWithComments:comments isOpen:YES completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                done();
            }];
        });
        it(@"delete comments", ^AsyncBlock {
            [[PIXNETSDK new] deleteBlogComments:comments completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
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