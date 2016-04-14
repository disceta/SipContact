//
//  sipios.h
//  rst_sipios
//
//  Created by Tyurin Andrey on 05/02/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#ifndef siprtp_h
#define siprtp_h

#include <string>
#include <memory>

class MyAccount;
class MyCall;
class MyBuddy;
class AccountDelegate;
class MyBuddy;
class CallDelegate;
class BuddyDelegate;

typedef std::shared_ptr<AccountDelegate> account_api_ptr_t;
typedef std::shared_ptr<CallDelegate> call_api_ptr_t;
typedef std::shared_ptr<BuddyDelegate> buddy_api_ptr_t;

class CallDelegate : public std::enable_shared_from_this<CallDelegate>{
private:
    account_api_ptr_t _account;
    std::shared_ptr<MyCall> _call;
    int _duration;
    std::string _aon;
public:
    CallDelegate(account_api_ptr_t account, int call_id = -1);
    virtual ~CallDelegate();
    void make_call(const std::string&);
    void answer();
    void hangup();
    void send_digits(const std::string&);
    std::string get_aon();
    virtual void onCallState(int status)=0;
    virtual void onCallDuration(int secods)=0;
    
    account_api_ptr_t& account() { return _account; }
};

class AccountDelegate : public std::enable_shared_from_this<AccountDelegate>{
private:
    std::shared_ptr<MyAccount> _account;
    friend class CallDelegate;
    friend class BuddyDelegate;
public:
    AccountDelegate();
    virtual ~AccountDelegate();
    void send_registration(const std::string& proto, const std::string& domain, const std::string& user, const std::string& password);
    void hangup_all();
    virtual void onRegister(int status)=0;
    virtual void onIncomingCall(call_api_ptr_t& call, int callId)=0;
    virtual void onIncomingSubscribe(const std::string& uri) = 0;
    virtual void onInstantMessage(const std::string& uri, const std::string& msg) = 0;
};

class BuddyDelegate : public std::enable_shared_from_this<BuddyDelegate> {
private:
    std::shared_ptr<MyBuddy> _buddy;
    friend class AccountDelegate;
protected:
    std::string _contact;
public:
    BuddyDelegate(account_api_ptr_t account);
    void subscribe(const std::string& name);
    virtual void onBuddyState(int state, const std::string&) = 0;
};

extern int sipios_init();
extern void sipios_destroy();
extern void sipios_digit(const char*);
//extern void sipios_set_delegate(CallDelegate*);

extern void sipios_set_path_resource(const char* path);

extern void sipios_playback_audio(const char*);


#endif /* siprtp_h */
