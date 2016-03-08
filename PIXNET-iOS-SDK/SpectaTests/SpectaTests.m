#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import "PIXNETSDK.h"
#import "PIXBlog.h"
#import "UserForTest.h"
#import "Nocilla.h"

SpecBegin(SomeBlogAPI)
__block UserForTest *userForTest = nil;
__block NSArray *articles = nil;
__block NSDictionary *article = nil;
__block NSArray *notifications = nil;
__block NSMutableArray *comments = nil;
describe(@"These methods are auth needed", ^{
    beforeAll(^{
        setAsyncSpecTimeout(60 * 60 * 60);
        waitUntil(^(DoneCallback done) {
            userForTest = [[UserForTest alloc] init];
            [PIXNETSDK setConsumerKey:userForTest.consumerKey consumerSecret:userForTest.consumerSecret];
            [PIXNETSDK logout];
            
            comments = [NSMutableArray new];
            id <UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
            UIView *rootView = appDelegate.window.rootViewController.view;
            UIWebView *webView = [[UIWebView alloc] initWithFrame:rootView.bounds];
            [rootView addSubview:webView];
            [PIXNETSDK loginByOAuth2OpenIDOnlyWithLoginView:webView completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                if (succeed) {
                    setAsyncSpecTimeout(60);
                    expect([PIXNETSDK isAuthed]).to.beTruthy();
                    [webView removeFromSuperview];
                } else {
                    [PIXNETSDK logout];
                }
                done();
                
            }];
        });
    });
    it(@"get blog articles", ^{
        
        waitUntil(^(DoneCallback done) {
            [[PIXNETSDK new] getBlogAllArticlesWithUserName:userForTest.userName password:userForTest.userPassword page:1 thumbSize:0 completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                if (succeed) {
                    articles = result[@"articles"];
                    article = articles[1];
                } else {
                    NSLog(@"get blog articles failed: %@", error);
                }
                done();
                
            }];
        });
    });
    it(@"leave comment 1", ^{
        waitUntil(^(DoneCallback done) {
            expect(comments).toNot.beNil();
            [[PIXNETSDK new] createBlogCommentWithArticleID:article[@"id"] body:@"unit test message" userName:userForTest.userName author:userForTest.userPassword title:@"unit test title" url:nil isOpen:YES email:nil blogPassword:nil articlePassword:nil completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                if (succeed) {
                    [comments addObject:result[@"comment"][@"id"]];
                }
                done();
                
            }];
        });
        
    });
    it(@"leave comment 2",  ^{
        waitUntil(^(DoneCallback done) {
            [[PIXNETSDK new] createBlogCommentWithArticleID:article[@"id"] body:@"unit test message" userName:userForTest.userName author:nil title:@"unit test title" url:nil isOpen:NO email:nil blogPassword:nil articlePassword:nil completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                if (succeed) {
                    [comments addObject:result[@"comment"][@"id"]];
                }
                done();
                
            }];
        });
    });
    it(@"set comments as close",  ^{
        waitUntil(^(DoneCallback done) {
            expect(comments.count == 2).to.beTruthy();
            [[PIXBlog new] updateBlogCommentsOpenWithComments:comments isOpen:YES completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                done();
                
            }];
        });
    });
    it(@"set comments as open",  ^{
        
        waitUntil(^(DoneCallback done) {
            [[PIXNETSDK new] updateBlogCommentsOpenWithComments:comments isOpen:YES completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                done();
                
            }];
        });
    });
    it(@"set comments as spam",  ^{
        
        waitUntil(^(DoneCallback done) {
            [[PIXBlog new] updateBlogCommentsSpamWithComments:comments isSpam:YES completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                done();
                
            }];
        });
    });
    it(@"set comments as ham",  ^{
        
        waitUntil(^(DoneCallback done) {
            [[PIXNETSDK new] updateBlogCommentsSpamWithComments:comments isSpam:NO completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                done();
                
            }];
        });
    });
    it(@"delete comments", ^{
        
        waitUntil(^(DoneCallback done) {
            [[PIXNETSDK new] deleteBlogComments:comments completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                done();
                
            }];
        });
    });
    it(@"set users as block",  ^{
        
        waitUntil(^(DoneCallback done) {
            [[PIXNETSDK new] updateBlockWithUsers:userForTest.blockUsers isAddToBlock:YES completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                done();
                
            }];
        });
    });
    /*        it(@"set user1 as not block",  ^{
     
     waitUntil(^(DoneCallback done) {
     [[PIXNETSDK new] deleteBlockWithUserName:userForTest.blockUsers[0] completion:^(BOOL succeed, id result, NSError *error) {
     expect(succeed).to.beTruthy();
     done();
     
     }];
     });
     });
     it(@"set user2 as not block",  ^{
     
     waitUntil(^(DoneCallback done) {
     [[PIXNETSDK new] deleteBlockWithUserName:userForTest.blockUsers[1] completion:^(BOOL succeed, id result, NSError *error) {
     expect(succeed).to.beTruthy();
     done();
     
     }];
     });
     });*/
    it(@"set users as not block",  ^{
        
        waitUntil(^(DoneCallback done) {
            [[PIXNETSDK new] updateBlockWithUsers:userForTest.blockUsers isAddToBlock:NO completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %i, description: %@", error.code, error.localizedDescription]);
                }
                done();
            }];
        });
    });
    it(@"get notifications with default parameters",  ^{
        waitUntil(^(DoneCallback done) {
            [[PIXNETSDK new] getNotificationsWiothCompletion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                if (succeed) {
                    notifications = result[@"notifications"];
                }
                done();
                
            }];
        });
    });
    it(@"get notifications with custom parameters",  ^{
        
        waitUntil(^(DoneCallback done) {
            [[PIXUser new] getNotificationsWiothNotificationType:PIXUserNotificationTypeSystem limit:1 isSkipSetRead:YES completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                done();
                
            }];
        });
    });
    it(@"set one notification as read",  ^{
        if (notifications.count == 0) {
            return;
        }
        waitUntil(^(DoneCallback done) {
            [[PIXUser new] updateOneNotificationAsRead:notifications[0][@"id"] completion:^(BOOL succeed, id result, NSError *error) {
                if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                done();
            }];
        });
        afterAll(^{
            [PIXNETSDK logout];
            expect([PIXNETSDK isAuthed]).toNot.beTruthy();
        });
    });
#pragma mark 以下的 testing 是不需要 auth 的
    describe(@"these methods are login unnecessary", ^{
        it(@"should get categories", ^{
            
            waitUntil(^(DoneCallback done) {
                [[PIXBlog new] getSiteCategoriesForArticleWithGroups:YES isIncludeThumbs:NO completion:^(BOOL succeed, id result, NSError *error) {
                    if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                    done();
                    
                }];
            });
        });
        it(@"should get categories", ^{
            
            waitUntil(^(DoneCallback done) {
                [[PIXBlog new] getSiteCategoriesForBlogWithGroups:YES isIncludeThumbs:YES completion:^(BOOL succeed, id result, NSError *error) {
                    if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                    done();
                    
                }];
            });
        });
        it(@"get someone's suggested tags", ^{
            
            waitUntil(^(DoneCallback done) {
                [[PIXBlog new] getSuggestedTagsWithUser:userForTest.userName completion:^(BOOL succeed, id result, NSError *error) {
                    if (!succeed) {
                    failure([NSString stringWithFormat:@"error code: %li, description: %@", (long)error.code, error.localizedDescription]);
                }
                    if (!succeed) {
                        NSLog(@"error: %@", error);
                    }
                    done();
                    
                }];
            });
            
        });
    });
});
SpecEnd