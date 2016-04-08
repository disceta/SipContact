//
//  SecondViewController.m
//  SipContact
//
//  Created by Tyurin Andrey on 16/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import "ContactsViewController.h"
#import "sipiosManager.h"
#import "ContactDataSource.h"

@interface ContactsViewController () {
    ContactDataSource  *dataSource;
}
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dataSource = [[ContactDataSource alloc] initWith:self.tableView];
    sipiosManager* man = [sipiosManager sharedManager];
    man.contactsViewController=self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}


- (IBAction)itemCallClick:(id)sender {
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:_tableView]; // maintable --> replace your tableview name
    NSIndexPath *clickedButtonIndexPath = [_tableView indexPathForRowAtPoint:touchPoint];
    UITableViewCell* cell = [dataSource tableView:_tableView cellForRowAtIndexPath: clickedButtonIndexPath];
    NSLog(@"rows:%@", cell.textLabel.text);
    sipiosManager* man = [sipiosManager sharedManager];
    [man call:cell.detailTextLabel.text fromView:self];
    //[[self tableView] reloadData];
    

}

-(void) stateChange: (NSInteger) state index:(NSInteger) index {
    [dataSource stateChange: state index:index];
    NSIndexPath* pt = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell* cell =
    [dataSource tableView:_tableView cellForRowAtIndexPath: pt];
    //cell.detailTextLabel.backgroundColor = [UIColor greenColor];
}


@end


