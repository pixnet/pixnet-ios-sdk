//
//  PhoneLogin.h
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/4/9.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneLogin : UIViewController <UITextFieldDelegate>
- (IBAction)removeKeyboard:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *idLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwdLabel;

@end
