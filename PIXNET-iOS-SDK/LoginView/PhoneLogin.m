//
//  PhoneLogin.m
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/4/9.
//  Copyright (c) 2014年 Dolphin Su. All rights reserved.
//

#import "PhoneLogin.h"

@interface PhoneLogin ()

@end

@implementation PhoneLogin

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)removeKeyboard:(id)sender {
    [self.idLabel resignFirstResponder];
    [self.passwdLabel resignFirstResponder];
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"textfield is : %i", textField.tag);
    if (textField.tag == 1) {
        [self.passwdLabel becomeFirstResponder];
        return YES;
    }else{
        [self.passwdLabel resignFirstResponder];
        return YES;
    }
}
@end
