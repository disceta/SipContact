//
//  pjsua_proxy.cpp
//  rst_sipios
//
//  Created by Tyurin Andrey on 10/02/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#include "pjsua_proxy.h"

#include <pjsua2.hpp>

#define THIS_FILE "pjsua_proxy.cpp"

using namespace pj;
Endpoint ep;
EpConfig ep_cfg;
TransportConfig tcfg;



AccountConfig acc_cfg;

int pjsuaprx_init() {
    ep.libCreate();
    return 0;
}

int pjsuaprx_start() {
    // Init library
    ep_cfg.logConfig.level = 4;
    ep.libInit( ep_cfg );

    // Transport
    tcfg.port = 5060;
    ep.transportCreate(PJSIP_TRANSPORT_UDP, tcfg);

    // Start library
    ep.libStart();
    //std::cout << "*** PJSUA2 STARTED ***" << std::endl;

    // Add account
    acc_cfg.idUri = "sip:2111@rastel.dyndns-work.com";
    acc_cfg.regConfig.registrarUri = "sip:rastel.dyndns-work.com";
    acc_cfg.sipConfig.authCreds.push_back( AuthCredInfo("digest", "*",
                                                        "2111", 0, "test1") );
    pj_thread_sleep(2000);
    
    // Make outgoing call
    CallOpParam prm(true);
    prm.opt.audioCount = 1;
    prm.opt.videoCount = 0;
    //call->makeCall("sip:test1@pjsip.org", prm);
    
    // Hangup all calls
    pj_thread_sleep(8000);
    ep.hangupAllCalls();
    pj_thread_sleep(4000);
    
    // Destroy library
    //std::cout << "*** PJSUA2 SHUTTING DOWN ***" << std::endl;
    return 0;
}
