//
//  Call.swift
//  SipContact
//
//  Created by Tyurin Andrey on 14/04/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

import UIKit

class Call: sipiosCallWrapper {
    //private let api: sipiosCallWrapper
    private var hangupViewController: HangupViewController!;

    init(account: Account, call_id: Int32) {
        
        //self.api = sipiosCallWrapper(account.api);
        super.init(account, call_id: call_id)
    }
    
    func callingTo(number: String, view: UIViewController) {
        callingTo(number)
        hangupViewController = HangupViewController()
        hangupViewController?.callingTo(number, call:self)
        view.presentViewController(hangupViewController!, animated:true, completion:nil);
    }
    
     override func onCallState(state: Int32) {
        var st_text: String!;
        switch state {
        case 1:
            st_text = "Набор номера..."
        case 2:
            st_text = "Набор номера..."
        case 3:
            st_text = "Вызов..."
        case 4:
            st_text = "Соединение..."
        case 5:
            st_text = "00:00:00"
        case 6:
            st_text = "Завершен..."
        default:
            st_text = "---"
        }
        hangupViewController.setStatus(st_text)
    }
    
    override func hangup() {
        hangupViewController.dismissViewControllerAnimated(true, completion: nil);
        super.hangup();
    }
}
