//
//  HangupViewController.m
//  sipios
//
//  Created by Tyurin Andrey on 16/02/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import "HangupViewController.h"
#import "sipiosManager.h"

@interface HangupViewController ()

@end

@implementation HangupViewController

@synthesize parent_call;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.numberLabel.text = self.toCallNumber;
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    // Set up an observer for proximity changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(IBAction)OnHangupButton:(id)sender {
    NSLog(@"onHangup button");
    sipiosManager* man=[sipiosManager sharedManager];
    [man hangup_all];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

- (IBAction)onDigitClick:(id)sender {
    NSString* s = [(UIButton*)sender currentTitle];
    NSLog(@"You digit:%@", s);
    sipiosManager* man=[sipiosManager sharedManager];
    //[man digits:s fromView:self];
    //self.digitLabel.text = [self.digitLabel.text stringByAppendingString:s];
}

- (void)sensorStateChange:(NSNotificationCenter *)notification
{
    if ([[UIDevice currentDevice] proximityState] == YES)
        NSLog(@"Device is close to user.");
    else
        NSLog(@"Device is ~not~ closer to user.");
}

-(void) callingTo: (NSString*) number call:(sipiosCall*)call {
    self.toCallNumber = number;
    self.numberLabel.text = self.toCallNumber;
    self.parent_call = call;
}

@end
