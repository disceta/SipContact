//
//  AnswerViewController.m
//  SipContact
//
//  Created by Tyurin Andrey on 28/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import "AnswerViewController.h"
#import "sipiosManager.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController {
    NSString* _number;
}

@synthesize parent_call;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _numberLabel.text = _number;
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

-(void) callingTo:(NSString*)number call:(sipiosCall*)call {
    _number = number;
    parent_call = call;
}

- (IBAction)AnswerClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[sipiosManager sharedManager] answer:parent_call];
    //[self BackClick:sender];
    
}

- (IBAction)BackClick:(id)sender {
    [[sipiosManager sharedManager] hangup:parent_call];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}
@end
