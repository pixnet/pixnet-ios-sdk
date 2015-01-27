#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import "PIXBlog.h"


SpecBegin(SomeBlogAPI)
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