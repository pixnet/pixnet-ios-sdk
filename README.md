PIXNET SDK for iOS
==============

[![Build Status](https://travis-ci.org/pixnet/pixnet-ios-sdk.svg?branch=travis-ci)](https://travis-ci.org/pixnet/pixnet-ios-sdk)

這個 SDK 可以讓你將 PIXNET 的相關資料快速整合進你的 iOS 專案中。
詳細 API 資訊請參考 [http://developer.pixnet.pro/](http://developer.pixnet.pro/)
 
This open-source library allows you to integrate PIXNET into your iOS APP.
Learn More detail at [http://developer.pixnet.pro/](http://developer.pixnet.pro/) 

##安裝 - Installation#
強烈建議使用 [CocoaPods](http://cocoapods.org/) 搜尋並安裝`pixnet-ios-sdk`

PIXNET iOS SDK 支援 Xcode 5.0，及 iOS 7.0 及之後的版本，且只支援[ARC](http://en.wikipedia.org/wiki/Automatic_Reference_Counting)

##使用 - Usage#
###在使用之前，請先至 PIXNET Developer 註冊新的 APP。
[http://developer.pixnet.pro/#!/apps](http://developer.pixnet.pro/#!/apps)

申請完成會拿到以下兩把鑰匙

 1. Consumer Key(client_id)
 2. Consumer Secret 

請使用以下的 code 把東西丟進 SDK 中就可以開始使用了
```objective-c
#import <PIXNETSDK.h>

[PIXNETSDK setConsumerKey:@"Consumer Key" consumerSecret:@"Consumer Secret"];
```

###初學使用者
請在安裝後在需要用到的 Class 中

```objective-c
#import <PIXNETSDK.h>
```

就可以開始使用簡易功能。


###進階使用者
可依各種不同需求 import 你所需要的各種不同功能，目前開放：

 1. `PIXBlog.h`
 2. `PIXAlbum.h`
 3. `PIXUser.h`

三隻不同的 Class 讓開發者使用並取得資料。

###範例 - Sample Code
####不需認證的情況下
取得使用者個人資料：
```Objective-C
    [[PIXNETSDK new] getUserWithUserName:@"UserName" completion:
     ^(BOOL succeed, id result, NSError *error) {
         if (succeed) {
             //做要做的東西
         }else{
             [[[UIAlertView alloc] initWithTitle:@"Ooops!"
                                         message:error.localizedDescription
                                        delegate:self
                               cancelButtonTitle:@"確定"
                               otherButtonTitles:nil, nil] show];
         }
     }];
```
####認證/登入
```Objective-C
    [PIXNETSDK authByXauthWithUserName:@"UserName" userPassword:@"Password" requestCompletion:^(BOOL succeed, id result, NSError *error) {
        if (succeed) {
            [[[UIAlertView alloc] initWithTitle:@"登入成功"
                                        message:@"已登入PIXNET"
                                       delegate:self
                              cancelButtonTitle:@"確定"
                              otherButtonTitles:nil, nil] show];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"登入失敗"
                                        message:error.localizedDescription
                                       delegate:self
                              cancelButtonTitle:@"確定"
                              otherButtonTitles:nil, nil] show];
        }
    }];
```
登入後即可使用需認證後才可使用的 Method。

####登出
```Objective-C
    [PIXNETSDK logout];
```
即可登出。

####詳細說明文件
請參考 [CocoaDocs PIXNET-iOS-SDK](http://cocoadocs.org/docsets/PIXNET-iOS-SDK/0.2/index.html) 說明文件

## 聯絡我們

Email: pixnetapi@pixnet.tw
Twitter: @pixnetapi


## License
PIXNET SDK is BSD-licensed. We also provide an additional patent grant.

