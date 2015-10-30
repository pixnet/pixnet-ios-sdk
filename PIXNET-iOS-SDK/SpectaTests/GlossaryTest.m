//
//  GlossaryTest.m
//  PIXNET-iOS-SDK
//
//  Created by dennis on 2015/10/30.
//  Copyright © 2015年 Dolphin Su. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import "PIXGlossary.h"
#import "PIXNETSDK.h"

SpecBegin(Glossary)
describe(@"test glossary api", ^{
    
    it(@"test zip code", ^{
        waitUntil(^(DoneCallback done) {
            
            [[PIXGlossary new] getTWZipCodeWithVersioin:@"0" isFetch:YES completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                expect(error).to.beNil();
                done();
            }];
        });
    });
    it(@"test zip code by sdk", ^{
        waitUntil(^(DoneCallback done) {
            
            [[PIXNETSDK new] getTWZipCodeWithVersioin:@"0" isFetch:YES completion:^(BOOL succeed, id result, NSError *error) {
                expect(succeed).to.beTruthy();
                expect(result).notTo.beNil();
                expect(error).to.beNil();
                done();
            }];
        });
    });
    it(@"end", ^{
        
    });
});

SpecEnd
