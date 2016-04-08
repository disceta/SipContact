//
//  HangupViewController.h
//  SipContact
//
//  Created by Tyurin Andrey on 21/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sipiosManager.h"

@interface HangupViewController : UIViewController

@property (nonatomic, weak) NSString* toCallNumber;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (strong, nonatomic) sipiosCall* parent_call;

-(void) callingTo:(NSString*)number call:(sipiosCall*)call;

@end
