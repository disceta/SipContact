//
//  ContactDataSource.m
//  SipContact
//
//  Created by Tyurin Andrey on 24/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import "ContactDataSource.h"
#import "sipiosManager.h"
#import "SipContact-Swift.h"
#import "AppDelegate.h"

@implementation ContactDataSource
{
    NSArray *tableData;
}

@synthesize cellSize;
-(id)initWith:(UITableView*)table {
    
    self = [super init];
    self.tableView = table;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if ( self != nil ) {
        [[sipiosManager sharedManager] contact_get_contacts:
         ^(NSString* data, NSError* error) {
            if (error)
                return;
            dispatch_async(dispatch_get_main_queue(), ^{[self loadData:data];});
            
        }];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    //NSMutableDictionary *obj0 = [tableData objectAtIndex:0];
    
    cell.textLabel.text = [[tableData objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.detailTextLabel.text = [[tableData objectAtIndex:indexPath.row] valueForKey:@"nick"];
    NSString* st = [[tableData objectAtIndex:indexPath.row] valueForKey:@"state"];
    cell.detailTextLabel.backgroundColor = [UIColor whiteColor];
    if (st!=nil && [st isEqualToString: @"1"])
        cell.detailTextLabel.backgroundColor = [UIColor greenColor];
    
    //cell.imageView.image = @"second";
    
    //[cell setNeedsLayout];
    
    //[cell layoutSubviews];
    
    //CGRect frame = cell.detailTextLabel.frame;
    //NSLog(@"detailTextLabel x=%f y=%f width=%f height=%f",
          //frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    
    return cell;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:[self tableView] cellForRowAtIndexPath: indexPath];
}

-(void)loadData:(NSString*) data {
    NSData* json_data = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingMutableContainers error:&error];
    if (error)
        NSLog(@"JSONObjectWithData error: %@", error);
    tableData = array;
    for (NSData* item in tableData) {
        NSString* tel = [item valueForKey:@"nick"];
        NSLog(@"data = %@", tel);
        [[sipiosManager sharedManager] subscribe:tel];
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display Alert Message
    [messageAlert show];*/
    
    //[self.tableView];
    
    Chat* ch = [[Chat alloc] initWithUser:[[User alloc] initWithID:1 username:@"A" firstName:@"B" lastName:@"C"] lastMessageText:@"xxx" lastMessageSentDate:[NSDate date]];
    
    ChatViewController* chat = [[ChatViewController alloc] initWithChat:ch];
    //auto hangupViewController = [[HangupViewController alloc] initWithNibName:nil bundle:nil];
    //[chat callingTo:sender call:scall];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate presentViewControllerFromVisibleViewController:chat];
    
}

-(void)stateChange: (NSInteger) state index:(NSUInteger)cell {
    NSMutableArray *array = (NSMutableArray*)tableData;
    NSData* item = [array objectAtIndex:cell];
    [item setValue:[NSString stringWithFormat:@"%d", state] forKey:@"state"];
    //[self.tableView reloadData];
}

@end
