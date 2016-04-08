//
//  FirstViewController.m
//  SipContact
//
//  Created by Tyurin Andrey on 16/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import "PhoneViewController.h"
#import "sipiosManager.h"

@interface PhoneViewController ()

@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PhoneClick:(id)sender {
    sipiosManager* man = [sipiosManager sharedManager];
    [man call:self.inputText.text fromView:self];
}

- (IBAction)onDigitalClick:(id)sender {
    NSString* s = [(UIButton*)sender currentTitle];
    NSLog(@"You digit:%@", s);
    NSString* st = self.inputText.text;
    if ([s isEqualToString:@"<"])
        if ([st length]>0)
            st = [st substringToIndex:[st length] - 1];
        else
            return ;
        else
            st = [st stringByAppendingString:s];
    if ([st length]>22)
        return;
    self.inputText.text = st;
    
    //const char* uri= [s UTF8String];
    //[[self delegate] OnPlaybackClick:uri];
    
    /*    SystemSoundID soundID;
     
     NSString *effectTitle = @"1";
     
     NSString *soundPath = [[NSBundle mainBundle] pathForResource:effectTitle ofType:@"ogg"];
     NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
     
     AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
     AudioServicesPlaySystemSound(soundID);*/
}

- (IBAction)answerViewClick:(id)sender {
}

@end
