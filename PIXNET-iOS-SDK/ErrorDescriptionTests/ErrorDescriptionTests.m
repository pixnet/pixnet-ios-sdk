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
    [PIXNETSDK setConsumerKey:@"0" consumerSecret:@"00000"];
    for (NSString *key in allKeys) {
        it(@"should return error", ^{
            
            waitUntil(^(DoneCallback done) {
                NSString *bodyString = [NSString stringWithFormat:@"{\"code\":\"%@\"}", key];
                stubRequest(@"GET", @"https://emma.pixnet.cc/mainpage/blog/categories/hot/0?per_page=10&client_id=0&page=1&format=json").andReturn(401).withBody(bodyString);
                [[PIXNETSDK new] getMainpageBlogCategoriesWithCategoryID:@"0" articleType:PIXMainpageTypeHot page:1 perPage:10 hasSpam:NO completion:^(BOOL succeed, id result, NSError *error) {
                    NSString *string = error.userInfo[@"NSLocalizedDescription"];
                    NSDictionary *errorDictionary = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                    // 用 PIXErrorWithServerResponse 產生 error 物件，確定該物件有正確的用 code 產生中文化的錯誤訊息
                    NSError *transferedError = [NSError PIXErrorWithServerResponse:errorDictionary];
                    NSString *errorMessage = transferedError.localizedDescription;
                    /*判斷這個 error message 是不是中文：http://stackoverflow.com/questions/6325073/detect-language-of-nsstring*/
                    //告訴 tagger，我們想要它判斷哪些東西
                    NSArray *tagsSchemes = @[NSLinguisticTagSchemeLanguage];
                    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:tagsSchemes options:0];
                    //告訴 tagger，我們要它判斷哪句話
                    [tagger setString:errorMessage];
                    NSRange range = NSMakeRange(0, errorMessage.length - 1);
                    //告訴 tagger，我們要它判斷的那句話會是哪種語言，不然它可能會判斷成日文或簡中
                    NSOrthography *orthography = [NSOrthography orthographyWithDominantScript:@"Hant" languageMap:@{@"Hant":@[@"zh-Hant"]}];
                    [tagger setOrthography:orthography range:range];

                    NSArray <NSString *>*stringArray = [tagger tagsInRange:range scheme:NSLinguisticTagSchemeLanguage options:NSLinguisticTaggerJoinNames tokenRanges:nil];
                    if (!([stringArray containsObject:@"zh-Hant"])) {
                        failure([NSString stringWithFormat:@"%@ is not Chinese, it's: %@", key, stringArray]);
                    }
                    done();
                }];
                
            });
        });
    }
});

SpecEnd