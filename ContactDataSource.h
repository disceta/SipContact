//
//  ContactDataSource.h
//  SipContact
//
//  Created by Tyurin Andrey on 24/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactDataSource : UITableViewController {
    CGSize cellSize;
}

-(id)initWith:(UITableView*)table;
//- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@property(nonatomic, assign) CGSize cellSize;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)stateChange: (NSInteger) state index:(NSUInteger)cell;

@end
