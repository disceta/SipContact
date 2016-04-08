//
//  sipiosManager.h
//  SipContact
//
//  Created by Tyurin Andrey on 18/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContactsViewController.h"

@interface sipiosCall : NSObject {
    
}
@end

@interface sipiosManager : NSObject {
}



+ (id)sharedManager;
- (void)start;
-(void)call:(NSString*)uri fromView:(UIViewController*)view;

-(void)hangup_all;
-(void)hangup:(sipiosCall*)call;
-(void)digit:(NSString*)digits;
-(void)answer:(sipiosCall*)call;
-(void)subscribe:(NSString*)number;

-(bool)contact_login:(NSString*)user_name :(NSString*)password completion:(void (^)(NSString *data, NSError *error))completionBlock;
-(bool)contact_get_contacts:(void (^)(NSString *data, NSError *error))completionBlock;

@property (strong, nonatomic) ContactsViewController* contactsViewController;


@end
