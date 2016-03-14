PIXNET SDK for iOS
==============

[![Build Status](https://travis-ci.org/pixnet/pixnet-ios-sdk.svg?branch=travis-ci)](https://travis-ci.org/pixnet/pixnet-ios-sdk)

這個 SDK 可以讓你將 PIXNET 的相關資料快速整合進你的 iOS 專案中。
詳細 API 資訊請參考 [http://developer.pixnet.pro/](http://developer.pixnet.pro/)
 
This open-source library allows you to integrate PIXNET into your iOS APP.
Learn More detail at [http://developer.pixnet.pro/](http://developer.pixnet.pro/) 

##安裝 - Installation#
強烈建議使用 [CocoaPods](http://cocoapods.org/) 搜尋並安裝`pixnet-ios-sdk`

PIXNET iOS SDK 支援 Xcode 5.0，及 iOS 6.0 及之後的版本，且只支援[ARC](http://en.wikipedia.org/wiki/Automatic_Reference_Counting)

##使用 - Usage#
###在使用之前，請先至 PIXNET Developer 註冊新的 APP。
[http://developer.pixnet.pro/#!/apps](http://developer.pixnet.pro/#!/apps)

申請完成會拿到以下兩把鑰匙

 1. Consumer Key(client_id)
 2. Consumer Secret 

請使用以下的 code 把東西丟寫在您的專案中就可以開始使用了，一般會寫在```- application:didFinishLaunchingWithOptions:```裡

```objective-c
#import "PIXNETSDK.h"

[PIXNETSDK setConsumerKey:@"Consumer Key" consumerSecret:@"Consumer Secret"];
```

###初學使用者
請在安裝後在需要用到的 Class 中

```objective-c
#import "PIXNETSDK.h"
```

就可以開始使用簡易功能。每個 method 都用 block 的方式通知您 query 後的結果，只要 succed 為 YES，result 一定不為 nil，error 必為 nil；相反的，當 succeed 為 NO 時，result 一定是 nil，而 error 一定有東西。
### error 的處理
您可以直接使用 ```error.localizedDescription``` 告知使用者發生了什麼錯誤，或是您也可以根據```error.code```來客製化您的錯誤訊息呈現方式。 [error code 的完整說明在這](https://pixnet.gitbooks.io/api-error-codes/content/)。

###進階使用者
這個 SDK 總共分成三層，

* 最外層的是 PIXNETSDK.h，這裡包含了所有的 method，但 method 裡的參數是簡化過的，方便開發者快速開發大多數的功能。
* 第二層是 PIXNET 所有開放出來的功能(例如部落格(PIXBlog.h)、相簿(PIXAlbum.h))，裡面的每個 method 都有完整的參數。
* 第三層是 PIXApiHandler.h，這裡提供的是將 OAuth1 及 OAuth2 包裝過後的各項網路連線功能。 
* 每個 method 的說明裡都會放 Restful API 的說明網頁連結，方便您比對及尋找 API 及 method 之間的關係。

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
UIWebView *webView = [[UIWebView alloc] initWithFrame:rootView.bounds];
[self.view addSubview:webView];
[PIXNETSDK loginByOAuth2OpenIDOnlyWithLoginView:webView completion:^(BOOL succeed, id result, NSError *error) {
    if (succeed) {
    	// 使用者登入成功了, 接下來您可以呼叫需要認證才能使用的 method 了
		[webView removeFromSuperview];
    } else {
    	// 使用者未登入成功
    }
    done();
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

