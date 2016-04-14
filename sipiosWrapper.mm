//
//  sipiosAccount.m
//  SipContact
//
//  Created by Tyurin Andrey on 14/04/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import "sipiosWrapper.h"
#include <string>
#include <map>
#include <vector>
#include "sipios.hpp"
#import "SipContact-Swift.h"
#import "AnswerViewController.h"



@implementation sipiosAccountWrapper {
    @public
    account_api_ptr_t _api;
}

class sipiosAccount: public AccountDelegate {
    sipiosAccountWrapper* _wrapper;
public:

    sipiosAccount(sipiosAccountWrapper* Wrapper) : _wrapper(Wrapper), AccountDelegate() {};
    
    void onRegister(int status) {
        NSLog(@"register status=%d", status);
    };
    
    void onIncomingCall(call_api_ptr_t& delegate, int callId) {
        //auto ncall=std::shared_ptr<sipiosCall>(new sipiosCall(shared_from_this(), callId));
        //delegate = ncall;
        sipiosCallWrapper* call = [[sipiosCallWrapper alloc] initWith:_wrapper];
        //call->_call = ncall;
        dispatch_async(dispatch_get_main_queue(), ^ {
            NSString* sd = @"";//[[NSString alloc] initWithUTF8String:call.get_aon().c_str()];
            NSLog(@"incoming call info=%@", sd);
            
            auto answerViewController = [[AnswerViewController alloc] initWithNibName:nil bundle:nil];
            [answerViewController callingTo:sd call:call];
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            
            UIViewController *vc = delegate.window.rootViewController;
            [vc presentViewController:answerViewController animated:YES completion:nil];
            
        });
        
    };
    
    void onIncomingSubscribe(const std::string& uri) {
        
    }
    
    void onInstantMessage(const std::string& uri, const std::string& msg) {
        
    };
};

- (id)init {
    if (self = [super init]) {
        _api = account_api_ptr_t(new sipiosAccount(self));
     }
    return self;
}

@end

@implementation sipiosCallWrapper {
    call_api_ptr_t _call;
    sipiosAccountWrapper* _account;
}

class sipiosCall: public CallDelegate {
private:
    sipiosCallWrapper* _parent;
 public:
    
    sipiosCall(sipiosCallWrapper* Wrapper, int call_id = -1) : _parent(Wrapper), CallDelegate(Wrapper->_account->_api, call_id) {
        NSLog(@"sipiosCall");
    };

    ~sipiosCall() {
        NSLog(@"~sipiosCall");
    }
    
    void onCallState(int state) {
        NSLog(@"onCallProcess:%d", state);
        
        dispatch_async(dispatch_get_main_queue(), ^{ [_parent onCallState:state]; });
        
    }
    
    void onCallDuration(int duration) {
        NSString* text_duration=[NSString stringWithFormat:@"%02u:%02u:%02u", duration/3600, duration/60, duration%60];
        //dispatch_async(dispatch_get_main_queue(), ^{hangupViewController.timeLabel.text = text_duration;});
    }
    
    
};

- (id)initWith:(sipiosAccountWrapper*)account_wrap call_id:(int)call_id {
    if (self = [super init]) {
        _account = account_wrap;
        _call = call_api_ptr_t(new sipiosCall(self, call_id));
    }
    return self;
}

- (id)initWith:(sipiosAccountWrapper*)account_wrap {
    return [self initWith:account_wrap call_id:-1];
}


-(void)callingTo:(NSString*)number {
    NSLog(@"wrapper call calling to:%@", number);
    const char* uri = [number UTF8String];
    _call->make_call(uri);
}

-(void)onCallState:(int)state {
    
}

-(void)hangup {
    _call->hangup();
}

@end



