//
//  sipios.c
//  rst_sipios
//
//  Created by Tyurin Andrey on 05/02/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//


/* $Id: simple_pjsua.c 3553 2011-05-05 06:14:19Z nanang $ */
/*
 * Copyright (C) 2008-2011 Teluu Inc. (http://www.teluu.com)
 * Copyright (C) 2003-2008 Benny Prijono <benny@prijono.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/**
 * simple_pjsua.c
 *
 * This is a very simple but fully featured SIP user agent, with the
 * following capabilities:
 *  - SIP registration
 *  - Making and receiving call
 *  - Audio/media to sound device.
 *
 * Usage:
 *  - To make outgoing call, start simple_pjsua with the URL of remote
 *    destination to contact.
 *    E.g.:
 *	 simpleua sip:user@remote
 *
 *  - Incoming calls will automatically be answered with 200.
 *
 * This program will quit once it has completed a single call.
 */

#include "sipios.hpp"
#include <pjsua2.hpp>
#include <pjsua-lib/pjsua.h>
//#include "pjsua_proxy.h"
#include <iostream>
#include <deque>
#define THIS_FILE "sipios_c"

pjsua_acc_id acc_id;
pj_status_t status;
bool isStarted=false;


using namespace pj;
Endpoint ep;
EpConfig ep_cfg;
TransportConfig tcfg;
bool call_need=false;
bool call_audio_need=false;
bool call_stop=false;
string call_uri;
string call_digit;
string pathResource;
bool call_digit_need=false;

class MyAccount;
 
enum sipiosEvent_t {
    evNull,
    evRegAccount,
    evCalling,
    evRemove,
    evAnswer,
    evHangup,
    evHangupAll,
    evBuddySubscribe
} ;

struct sipiosEvent {
    sipiosEvent_t _event_type;
    std::shared_ptr<MyAccount> _account;
    std::shared_ptr<MyCall> _call;
    std::shared_ptr<MyBuddy> _buddy;
    
    sipiosEvent(sipiosEvent_t type, std::shared_ptr<MyCall> call) :
    _account(0), _call(call), _event_type(type)
    {
        
    }
    
    sipiosEvent(sipiosEvent_t type, std::shared_ptr<MyAccount> account) :
    _account(account), _call(0), _event_type(type)
    {
        
    }
    
    sipiosEvent(sipiosEvent_t type, std::shared_ptr<MyBuddy> buddy, std::shared_ptr<MyAccount> account) :
    _buddy(buddy), _account(account), _call(0), _event_type(type)
    {
        
    }

};

struct sipiosQueue {
    std::deque<sipiosEvent*> events;
    std::mutex _mutex;
    
    
    void add(sipiosEvent* event) {
        events.push_back(event);
    }
    
    sipiosEvent* pop() {
        if (events.empty())
            return NULL;
        sipiosEvent* e=events.front();
        events.pop_front();
        return e;
    }
};

sipiosQueue events;

class MyCall : public Call
{
private:
    std::shared_ptr<MyAccount> myAcc;
    std::weak_ptr<CallDelegate> _delegate;
    friend class CallDelegate;
public:
    std::string _uri;

    MyCall(std::shared_ptr<MyAccount> acc, int call_id = PJSUA_INVALID_ID);
    
    ~MyCall() {
        std::cout << "~MyCall" << std::endl;
    }
    
    virtual void onCallState(OnCallStateParam &prm) 
    {
        CallInfo info = getInfo();
        std::cout << "call info: " << info.lastReason << std::endl << info.stateText << std::endl;
        auto ptr = _delegate.lock();
        if (ptr.get())
            ptr->onCallState((int)info.state);
        if (info.state == PJSIP_INV_STATE_DISCONNECTED) {
            //delete this;
            //call=NULL;
            call_stop = false;

        }
    }
    
    virtual void onCallMediaState(OnCallMediaStateParam &prm) {
        
        CallInfo ci = getInfo();
        // Iterate all the call medias
        for (unsigned i = 0; i < ci.media.size(); i++) {
            if (ci.media[i].type==PJMEDIA_TYPE_AUDIO && getMedia(i)) {
                AudioMedia *aud_med = (AudioMedia *)getMedia(i);
                
                // Connect the call audio media to sound device
                //Endpoint::instance()
                AudDevManager& mgr = ep.audDevManager();
                aud_med->startTransmit(mgr.getPlaybackDevMedia());
                mgr.getCaptureDevMedia().startTransmit(*aud_med);
            }
        }
   }
    
    
};

class MyAccount : public Account
{
public:
    std::auto_ptr<AccountConfig> _config;
    //std::vector<Call *> calls;
    std::weak_ptr<AccountDelegate> _delegate;
    friend class AccountDelegate;
    std::string _proto;
    std::string _domain;
public:
    MyAccount() :
                _config(new AccountConfig())
    {
    }

    virtual ~MyAccount()
    {
        //std::cout << "*** Account is being deleted: No of calls="
        //          << calls.size() << std::endl;
    }
    
    void send_registration(const std::string& proto, const std::string& domain, const std::string& user, const std::string& password) {
        _domain = domain;
        _proto = proto;
        _config->idUri = proto+":"+user+"@"+domain;
        _config->regConfig.registrarUri = proto+":"+domain;
        _config->sipConfig.authCreds.push_back( AuthCredInfo("digest", "*", user, 0, password) );
        _config->callConfig.timerMinSESec=100;
        _config->callConfig.timerSessExpiresSec=110;
    }
    
    void create() {
        Account::create(*_config.get());
    };
    
    void removeCall(Call *call)
    {
        /*for (std::vector<Call *>::iterator it = calls.begin();
             it != calls.end(); ++it)
        {
            if (*it == call) {
                calls.erase(it);
                break;
            }
        }*/
    }

    virtual void onRegState(OnRegStateParam &prm)
    {
        AccountInfo ai = getInfo();
        std::cout << (ai.regIsActive? "*** Register: code=" : "*** Unregister: code=")
            << prm.code << std::endl;
        auto ptr = _delegate.lock();
        ptr->onRegister(prm.code);
    }
    
    virtual void onIncomingCall(OnIncomingCallParam &iprm)
    {
        auto ptr = _delegate.lock();
        if (ptr.get()) {
            std::shared_ptr<CallDelegate> call;
            ptr->onIncomingCall(call, iprm.callId);
        }
    }
    
    void onIncomingSubscribe(OnIncomingSubscribeParam &prm)
    {
        auto ptr = _delegate.lock();
        if (ptr.get()) {
            std::cout << "income subscribe from uri " << prm.fromUri << std::endl;
            ptr->onIncomingSubscribe(prm.fromUri);
        }
    }
    
    void onInstantMessage(OnInstantMessageParam &prm)
    {
        auto ptr = _delegate.lock();
        if (ptr.get()) {
            std::cout << "receive message " << prm.fromUri <<" body="<< prm.msgBody << std::endl;
            ptr->onInstantMessage(prm.fromUri, prm.msgBody);
        }
    }
    
    void onInstantMessageStatus(OnInstantMessageStatusParam &prm)
    { PJ_UNUSED_ARG(prm); }
    
    void onTypingIndication(OnTypingIndicationParam &prm)
    { PJ_UNUSED_ARG(prm); }

    
};

/**
* Superclass Buddy PJSIP
*/
class MyBuddy : public Buddy
{
private:
    std::shared_ptr<MyAccount> _account;
    std::weak_ptr<BuddyDelegate> _delegate;
    friend class BuddyDelegate;
public:
    std::string _uri;

    MyBuddy(std::shared_ptr<MyAccount> account) :
    _account(account)
    {
    }
    
    /**
     delete Buddy in PJSIP
     */
    ~MyBuddy() {
    }
    
    void onBuddyState()  {
        std::cout << "onBuddyState:";
        auto ptr = _delegate.lock();
        if (ptr.get()) {
            std::shared_ptr<CallDelegate> call;
            const BuddyInfo& bi = getInfo();
            std::cout << "uri=" << bi.uri << ", presence=" << bi.presStatus.status << ", status=" << bi.presStatus.status;
            size_t i = bi.uri.find(std::string(":"));
            std::string str = "";
            if (i!=bi.uri.npos) {
                size_t r = bi.uri.find("@", i);
                if (r != bi.uri.npos)
                    str = bi.uri.substr(i+1, r-i-1);
            }
            ptr->onBuddyState(bi.presStatus.status, str);
        }
        std::cout << std::endl;
    };
};


MyCall::MyCall(std::shared_ptr<MyAccount> acc, int call_id)
: Call(*acc.get(), call_id), myAcc(acc)
{
}



AccountDelegate::AccountDelegate()
    : _account(new MyAccount())
{
}

AccountDelegate::~AccountDelegate() {
    events.add(new sipiosEvent(evRemove, _account));
}

void AccountDelegate::send_registration(const std::string& proto, const std::string& domain, const std::string& user, const std::string& password)
{
    _account->_delegate = shared_from_this();
    _account->send_registration(proto, domain, user, password);
    events.add(new sipiosEvent(evRegAccount, _account));
}

void AccountDelegate::hangup_all() {
    events.add(new sipiosEvent(evHangupAll, _account));
}

CallDelegate::CallDelegate(std::shared_ptr<AccountDelegate> account, int callId)
    : _account(account), _call(new MyCall(_account->_account, callId))
{
    if (callId!=-1) {
        CallInfo info = _call->getInfo();
        _aon = info.remoteUri;
    }
};

CallDelegate::~CallDelegate() {
    std::cout << "~CallDelegate" << std::endl;
    events.add(new sipiosEvent(evRemove, _call));
};

void CallDelegate::make_call(const std::string& uri) {
    _call->_delegate = shared_from_this();
    _call->_uri = uri;
    events.add(new sipiosEvent(evCalling, _call));
    _duration = 0;
};

void CallDelegate::answer() {
    _call->_delegate = shared_from_this();
    events.add(new sipiosEvent(evAnswer, _call));
    _duration = 0;
}

void CallDelegate::hangup() {
    _call->_delegate = shared_from_this();
    events.add(new sipiosEvent(evHangup, _call));
}

std::string CallDelegate::get_aon() {
    return _aon;
}

BuddyDelegate::BuddyDelegate(std::shared_ptr<AccountDelegate> account)
:_buddy(new MyBuddy(account->_account))
{
    
}

void BuddyDelegate::subscribe(const std::string &name) {
    _contact = name;
    _buddy->_delegate = shared_from_this();
    _buddy->_uri = _buddy->_account->_proto+":"+name+"@"+_buddy->_account->_domain;
    events.add(new sipiosEvent(evBuddySubscribe, _buddy, _buddy->_account));
}

int pjsuaprx_start() {
    // Init library
    ep.libCreate();
    ep_cfg.medConfig.noVad=true;
    ep_cfg.logConfig.level = 3;
    ep.libInit( ep_cfg );
    
    // Transport
    tcfg.port = 15060;
    ep.transportCreate(PJSIP_TRANSPORT_UDP, tcfg);
    
    // Start library
    ep.libStart();
    //std::cout << "*** PJSUA2 STARTED ***" << std::endl;
    
    // Add account
    
    pj_thread_sleep(1000);
    
    // Hangup all calls
    isStarted=true;
    while(isStarted) {
        pj_thread_sleep(100);
        try {
            sipiosEvent* event=events.pop();
            if (!event)
                continue;
            if (event->_event_type==evRegAccount) {
                event->_account->create();
            }
            else if (event->_event_type==evCalling) {
                CallOpParam prm(true);
                prm.opt.audioCount = 1;
                prm.opt.videoCount = 0;
                string dest_uri="sip:";
                dest_uri+=event->_call->_uri;
                dest_uri+="@rastel.dyndns-work.com";
                event->_call->makeCall(dest_uri, prm);

            }
            else if (event->_event_type==evAnswer) {
                CallOpParam prm;
                //PJSIP_SC_DECLINE;
                prm.statusCode = (pjsip_status_code)200;
                event->_call->answer(prm);
            }
            else if (event->_event_type==evHangup) {
                CallOpParam prm;
                //PJSIP_SC_DECLINE;
                prm.statusCode = (pjsip_status_code)600;
                event->_call->hangup(prm);
            }
            else if (event->_event_type==evHangupAll) {
                ep.hangupAllCalls();
            }
            else if (event->_event_type==evBuddySubscribe) {
                BuddyConfig cfg;
                cfg.uri = event->_buddy->_uri;
                event->_buddy->create(*event->_account.get(), cfg);
                event->_buddy->subscribePresence(true);
            }
            delete event;

            if (call_audio_need) {
                call_audio_need=false;
                AudioMediaPlayer player;
                AudioMedia& play_med = ep.audDevManager().getPlaybackDevMedia();//CaptureDevMedia();//getPlaybackDevMedia();
                try {
                    player.createPlayer(pathResource+"/1.wav", PJMEDIA_FILE_NO_LOOP);
                    player.startTransmit(play_med);
                } catch(Error& err) {
                }
            }
        /*if (call && call->isActive()) {
            CallInfo inf = call->getInfo();
            if (inf.state==PJSIP_INV_STATE_CONFIRMED) {
            if (call_delegate) {
                if (duration<inf.totalDuration.sec) {
                    duration=inf.totalDuration.sec;
                    call_delegate->onCallDuration(duration);
                }
            }
            if (call_digit_need) {
                call_digit_need = false;
                call->dialDtmf(call_digit);
            }
            }
        }*/
        if (call_stop) {
            call_stop=false;
            ep.hangupAllCalls();
        }
        }
        catch (pj::Error& e) {
            std::cout << e.reason << std::endl;
        }
        
    }
    // Destroy library
    std::cout << "*** PJSUA2 SHUTTING DOWN ***" << std::endl;
    return 0;
}

int sipios_init()
{
    pjsuaprx_start();
    
    return 0;
    
}

void sipios_destroy() {
    isStarted=false;
    /* Destroy pjsua */
    pjsua_destroy();
    
}

void sipios_digit(const char* uri) {
    call_digit = uri;
    call_digit_need = true;
}

void sipios_playback_audio(const char* uri) {
    //call_need = uri;
    call_audio_need = true;
}


void sipios_hangup() {
    call_stop=true;
}

void sipios_set_path_resource(const char* path) {
    pathResource = path;
    std::cout << path << std::endl;
}