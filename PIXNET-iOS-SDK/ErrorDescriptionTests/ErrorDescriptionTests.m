#import <Expecta/Expecta.h>
#import "Expecta.h"
#import "Specta.h"
#import "Nocilla.h"
#import "PIXNETSDK.h"

SpecBegin(ErrorDescription)
        beforeAll(^{
            [[LSNocilla sharedInstance] start];
        });
        afterEach(^{
            [[LSNocilla sharedInstance] clearStubs];
        });
        afterAll(^{
            [[LSNocilla sharedInstance] stop];
        });
        describe(@"test1", ^{
            /*取出 Localizable.strings 裡的內容：http://stackoverflow.com/questions/6310487/iphone-ios-how-can-i-get-a-list-of-localized-strings-in-all-the-languages-my-ap*/
            NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"Localizable" withExtension:@"strings"];
            NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:fileURL];
            NSArray *allKeys = dictionary.allKeys;

            for (NSString *key in allKeys) {
                it(@"should return error", ^AsyncBlock{
                    NSString *bodyString = [NSString stringWithFormat:@"{\"code\":\"%@\"}", key];
                    stubRequest(@"GET", @"https://emma.pixnet.cc/mainpage/blog/categories/hot/0?page=1&count=10&format=json").
                            andReturn(401).
                            // Do any additional setup after loading the view.
                            withBody(bodyString);

                    [[PIXNETSDK new] getMainpageBlogCategoriesWithCategoryID:@"0" articleType:PIXMainpageTypeHot page:1 perPage:10 completion:^(BOOL succeed, id result, NSError *error) {
                        NSString *string = error.userInfo[@"NSLocalizedDescription"];
                        NSDictionary *errorDictionary = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                        // 用 PIXErrorWithServerResponse 產生 error 物件，確定該物件有正確的用 code 產生中文化的錯誤訊息
                        NSError *transferedError = [NSError PIXErrorWithServerResponse:errorDictionary];
                        NSString *errorMessage = transferedError.localizedDescription;
                        /*判斷這個 error message 是不是中文：http://stackoverflow.com/questions/6325073/detect-language-of-nsstring*/
                        NSString *languageString = (__bridge NSString *) CFStringTokenizerCopyBestStringLanguage(( __bridge CFStringRef) errorMessage, CFRangeMake(0, (CFIndex) errorMessage.length));
                        EXP_expect(languageString).to.equal(@"zh_Hant");
                        done();
                    }];

                });
            }
        });

SpecEnd