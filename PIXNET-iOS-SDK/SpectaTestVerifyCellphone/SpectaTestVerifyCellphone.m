#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import "PIXNETSDK.h"
#import "UserForTest.h"
#import "UIControl+Blocks.h"

SpecBegin(SomeBlogAPI)
__block UserForTest *userForTest = nil;
__block UITextField *codeField = nil;
__block UIButton *button = nil;
__block UIView *rootView;
        __block BOOL isVerified;
describe(@"These methods are auth needed", ^{
    beforeAll(^AsyncBlock {
        [PIXNETSDK logout];
        setAsyncSpecTimeout(60 * 60);
        userForTest = [[UserForTest alloc] init];
        [PIXNETSDK setConsumerKey:userForTest.consumerKey consumerSecret:userForTest.consumerSecret];
        id <UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
        rootView = appDelegate.window.rootViewController.view;
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
    it(@"get cellphone verification status", ^AsyncBlock{
        [[PIXNETSDK new] getCellphoneVerificationStatus:^(BOOL succeed, id result, NSError *error) {
            expect(succeed).to.beTruthy();
            isVerified = [result[@"cellphone_verified"] boolValue];
            done();
        }];
    });
    it(@"send verification code to cell phone", ^AsyncBlock{
        if (!isVerified) {
            [[PIXNETSDK new] verifyCellphone:userForTest.cellphone countryCode:@"+886" completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                if (succeed) {
                    NSLog(@"send phone number: %@%@\n%@", @"+886", userForTest.cellphone, result);
                } else {
                    NSLog(@"error: %@", error);
                }
                done();
            }];
        } else {
            done();
        }
    });

    it(@"send code to backend", ^AsyncBlock{
        if (!isVerified) {
            codeField = [[UITextField alloc] initWithFrame:CGRectMake(0, 30, 200, 40)];
            codeField.borderStyle = UITextBorderStyleRoundedRect;

            [rootView addSubview:codeField];
            button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(0, 80, 100, 40);
            [button setTitle:@"送出" forState:UIControlStateNormal];
            [rootView addSubview:button];
            setAsyncSpecTimeout(60 * 30);
            [button addActionForControlEvents:UIControlEventTouchUpInside usingBlock:^(UIControl *sender, UIEvent *event) {
                [[PIXNETSDK new] verifyCodeForCellphone:codeField.text completion:^(BOOL succeed, id result, NSError *error) {
                    expect(succeed).to.beTruthy();
                }];
                done();
            }];
        } else {
            done();
        }
    });
    afterAll(^{
        [PIXNETSDK logout];
        expect([PIXNETSDK isAuthed]).toNot.beTruthy();
    });
});
SpecEnd
