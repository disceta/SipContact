//
//  sipiosManager.h
//  SipContact
//
//  Created by Tyurin Andrey on 18/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sipiosWrapper.h"



@interface sipiosManager : NSObject {
}



+ (id)sharedManager;
- (void)start;

-(bool)contact_login:(NSString*)user_name :(NSString*)password completion:(void (^)(NSString *data, NSError *error))completionBlock;
-(bool)contact_get_contacts:(NSString*)user_id :(void (^)(NSString *data, NSError *error))completionBlock;

//@property (strong, nonatomic) ContactsViewController* contactsViewController;


@end
