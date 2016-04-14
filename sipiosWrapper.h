//
//  sipiosAccount.h
//  SipContact
//
//  Created by Tyurin Andrey on 14/04/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface sipiosAccountWrapper : NSObject

@end

@interface sipiosCallWrapper : NSObject

- (id)initWith:(sipiosAccountWrapper*)account_wrap call_id:(int)call_id;

- (id)initWith:(sipiosAccountWrapper*)account_wrap;



-(void)callingTo:(NSString*)number;

-(void)onCallState:(int)state;

-(void)hangup;

@end
