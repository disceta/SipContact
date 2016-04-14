//
//  AnswerViewController.swift
//  SipContact
//
//  Created by Tyurin Andrey on 14/04/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

import UIKit

class HangupViewController: UIViewController {
    /*let numberLabel: UILabel
    let call: Call
    let timerLabel: UILabel*/
    var statusLabel: UILabel!
    var call: Call!
    var callingTo: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hangup"
        
        let hangupButton = UIButton(type: .System)
        hangupButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        hangupButton.setTitle("Hangup", forState: .Normal)
        hangupButton.frame = CGRectMake(40, 60, 100, 24)
        hangupButton.center = self.view.center
        hangupButton.backgroundColor = UIColor.redColor()
       
        //hangupButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), forState: .Disabled)
        //hangupButton.setTitleColor(UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1), forState: .Normal)
        //hangupButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        hangupButton.addTarget(self, action: #selector(HangupViewController.hangupClick), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(hangupButton)
        
        statusLabel = UILabel(frame: CGRectMake(0.0, 0.0, 100, 20))
        statusLabel.center = self.view.center;
        statusLabel.text = "...";
        statusLabel.center.y -= 100;
        self.view.addSubview(statusLabel)
        
    }
    
    func callingTo(number:String, call:Call) {
        self.call = call
        self.callingTo = number
    }
    
    func hangupClick() {
        NSLog("hangup button click")
        self.call.hangup();
    }

    func setStatus(text:String) {
        self.statusLabel.text = text;
    }
}
