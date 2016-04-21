//
//  sipiosManager.m
//  SipContact
//
//  Created by Tyurin Andrey on 18/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import "sipiosManager.h"
#include <string>
#include <map>
#include <vector>
#include "sipios.hpp"

class sipiosBuddy;

@interface sipiosManager() {
}


@end

@implementation sipiosManager {
}


#pragma mark Singleton Methods


+ (id)sharedManager {
    static sipiosManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


// implement 

-(void)start {
    /* Start pjsua app thread */
    [NSThread detachNewThreadSelector:@selector(pjsuaStart) toTarget:self withObject:nil];
}



static void displayMsg(const char *msg)
{
    printf("displayMsg: %s\n", msg);
    NSString *str = [NSString stringWithFormat:@"%s", msg];
    //dispatch_async(dispatch_get_main_queue(), ^{app.viewController.textLabel.text = str;});
}



- (int)pjsuaStart
{
    NSString *pathres = [[NSBundle mainBundle] resourcePath];
    const char* uri= [pathres UTF8String];
    sipios_set_path_resource(uri);
    //account = std::shared_ptr<sipiosAccount>(new sipiosAccount());
    //account->send_registration("sip", "rastel.dyndns-work.com", "2111", "qaz3");
    sipios_init();
    displayMsg("Created");
    return 0;
}






//****************
//JSON request API
//****************
- (void)json_post_request:(NSString*)data_request
               completion:(void (^)(NSString *data, NSError *error))completionBlock
{
    NSString *post = [NSString stringWithFormat:data_request];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString* postLength = [NSString stringWithFormat:@"%d",[postData length]];
    [request setURL:[NSURL URLWithString:@"http://rastel.dyndns-work.com:25069/SipContact"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"requestReply: %@", requestReply);
        NSError* err=nil;
        if ([requestReply isEqualToString:@"null"]) {
            err = [[NSError alloc] initWithDomain:@"null data"
                                             code:errno userInfo:nil];
        }
        completionBlock(requestReply, err);
    }] resume];
}

-(bool)contact_login :(NSString*)user_name :(NSString*)password completion:(void (^)(NSString *data, NSError *error))completionBlock {
    NSString* command = [NSString stringWithFormat: @"{\"method\":\"getUser\", \"usr_name\": \"%@\", \"usr_pwd\": \"%@\"}", user_name, password];
    [self json_post_request:command completion:^(NSString *data, NSError *error2) {
        NSData* json_data = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error3 = nil;
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingMutableContainers error:&error3];
        if (error3)
            NSLog(@"JSONObjectWithData error: %@", error3);
        NSMutableDictionary *obj0 = [array objectAtIndex:0];
        //user_id = [obj0 valueForKey:@"usr_id"];
        completionBlock(data, error2);
    }];
    return true;
}

-(bool)contact_get_contacts:(NSString*)user_id :(void (^)(NSString *data, NSError *error))completionBlock {
    NSString* command = [NSString stringWithFormat:@"{\"method\":\"getFavs\", \"usr_id\": \"%@\"}", user_id];
    
    [self json_post_request:command completion:completionBlock];
    
    return true;
}


@end

