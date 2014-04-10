//
//  AppDelegate.m
//  PIXNET-iOS-SDK
//
//  Created by Dolphin Su on 3/14/14.
//  Copyright (c) 2014 Dolphin Su. All rights reserved.
//

#import "AppDelegate.h"
#import "PIXNETSDK.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[PIXNETSDK new] getUserWithUserName:@"cloud" completion:
     ^(BOOL succeed, id result, NSString *errorMessage) {
         if (succeed) {
             //做要做的東西
         }else{
             [[[UIAlertView alloc] initWithTitle:@"Ooops!"
                                         message:errorMessage
                                        delegate:self
                               cancelButtonTitle:@"確定"
                               otherButtonTitles:nil, nil] show];
         }
     }];
    
    [PIXNETSDK setConsumerKey:@"Consumer Key" consumerSecret:@"Consumer Secret"];
    [PIXNETSDK authByXauthWithUserName:@"UserName" userPassword:@"Password" requestCompletion:^(BOOL succeed, id result, NSString *errorMessage) {
        if (succeed) {
            [[[UIAlertView alloc] initWithTitle:@"登入成功"
                                        message:@"已登入PIXNET"
                                       delegate:self
                              cancelButtonTitle:@"確定"
                              otherButtonTitles:nil, nil] show];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"登入失敗"
                                        message:errorMessage
                                       delegate:self
                              cancelButtonTitle:@"確定"
                              otherButtonTitles:nil, nil] show];
        }
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
