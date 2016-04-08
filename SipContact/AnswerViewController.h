//
//  AnswerViewController.h
//  SipContact
//
//  Created by Tyurin Andrey on 28/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sipiosManager.h"

@interface AnswerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (strong, nonatomic) sipiosCall* parent_call;

-(void) callingTo:(NSString*)number call:(sipiosCall*)call;

@end
