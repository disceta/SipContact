//
//  LoginViewController.m
//  SipContact
//
//  Created by Tyurin Andrey on 23/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import "LoginViewController.h"
#import "sipiosManager.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //only for debug and programming
    _loginTextView.text = @"2011";
    _passwordTextView.text = @"qaz3";
    [self loginClick:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginClick:(id)sender {
    sipiosManager * man=[sipiosManager sharedManager];
    if (![man contact_login:[_loginTextView text] :[_passwordTextView text] completion:^(NSString *data, NSError * error) {
        if (error)
            return;
        dispatch_async(dispatch_get_main_queue(), ^{[self showMainWindow];});
    }]) {
        NSLog(@"error: call handler wrong!");
    }
}

-(void)showMainWindow {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:appDelegate.tabBarController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
