//
//  SecondViewController.h
//  SipContact
//
//  Created by Tyurin Andrey on 16/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void) stateChange: (NSInteger) state index:(NSInteger) index;

@end

