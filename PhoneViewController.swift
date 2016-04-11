//
//  File.swift
//  SipContact
//
//  Created by Tyurin Andrey on 11/04/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

import Foundation

class PhoneViewCell : UITableViewCell {
    let button1: UIButton;
    let button2: UIButton;
    let button3: UIButton;
    static let heightButton: CGFloat = 50.0
    static let distanceBetweenButton: CGFloat = 10.0;
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let rect = CGRectMake(0.0, 0.0, PhoneViewCell.heightButton, PhoneViewCell.heightButton)
        button1 = UIButton(frame: rect)
        button1.backgroundColor = UIColor.grayColor()
        button2 = UIButton(frame: rect)
        button2.backgroundColor = UIColor.grayColor()
        button3 = UIButton(frame: rect)
        button3.backgroundColor = UIColor.grayColor()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //button1.frame = CGRectOffset(self.frame, 10, 10);
        //button2.frame = CGRectOffset(self.frame, 10, 10);
        //button3.frame = CGRectOffset(self.frame, 10, 10);
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.addSubview(button1)
        self.addSubview(button2)
        self.addSubview(button3)
    }
    
    override func layoutSubviews() {
        let coord = CGPointMake(self.contentView.center.x, self.contentView.center.y)
        self.button2.center = coord;
        
        let coord1 = CGPointMake(coord.x - PhoneViewCell.distanceBetweenButton - PhoneViewCell.heightButton, coord.y)
        self.button1.center = coord1
        
        let coord3 = CGPointMake(coord.x + PhoneViewCell.distanceBetweenButton + PhoneViewCell.heightButton, coord.y)
        self.button3.center = coord3
        
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class LabelViewCellButton: UITableViewCell {
    
    let label: UILabel;
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let rect = CGRectMake(0.0, 0.0, PhoneViewCell.heightButton*3+PhoneViewCell.distanceBetweenButton*2, PhoneViewCell.heightButton)
        label = UILabel(frame: rect)
        label.backgroundColor = UIColor.grayColor()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.addSubview(label)
    }
    
    override func layoutSubviews() {
        let coord = CGPointMake(self.contentView.center.x, self.contentView.center.y)
        self.label.center = coord;
        
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CallViewCellButton: UITableViewCell {
    
    let button: UIButton;
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let rect = CGRectMake(0.0, 0.0, PhoneViewCell.heightButton*3+PhoneViewCell.distanceBetweenButton*2, PhoneViewCell.heightButton)
        button = UIButton(frame: rect)
        button.backgroundColor = UIColor.grayColor()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.addSubview(button)
    }
    
    override func layoutSubviews() {
        let coord = CGPointMake(self.contentView.center.x, self.contentView.center.y)
        self.button.center = coord;
        
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhoneViewController: UITableViewController {

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = editButtonItem() // TODO: KVO
        tableView.backgroundColor = .whiteColor()
        self.tableView.separatorColor = .clearColor();
        //tableView.rowHeight = chatTableViewCellHeight
        tableView.separatorInset.left = chatTableViewCellInsetLeft
        tableView.registerClass(PhoneViewCell.self, forCellReuseIdentifier: "PhoneCell")
        tableView.registerClass(LabelViewCellButton.self, forCellReuseIdentifier: "LabelCell")
        tableView.registerClass(CallViewCellButton.self, forCellReuseIdentifier: "CallButtonCell")
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatsTableViewController.accountDidSendMessage(_:)), name: AccountDidSendMessageNotification, object: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PhoneViewCell.heightButton + PhoneViewCell.distanceBetweenButton
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Set style & identifier based on section
        let section = indexPath.section
        let style: UITableViewCellStyle = .Default
        let cellIdentifier = "PhoneCell"
        
        let cell: UITableViewCell
        
        if section == 0 {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as! LabelViewCellButton
            cell1.label.text = "Number"
            cell = cell1
        }
        else
        if section < 5 {
            // Dequeue or create cell with style & identifier
            let cell1 = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PhoneViewCell
            if section==4 {
                cell1.button1.setTitle("*", forState: UIControlState.Normal)
                cell1.button2.setTitle("0", forState: UIControlState.Normal)
                cell1.button3.setTitle("#", forState: UIControlState.Normal)
            }
            else {
                cell1.button1.setTitle(String(section*3-2), forState: UIControlState.Normal)
                cell1.button2.setTitle(String(section*3-1), forState: UIControlState.Normal)
                cell1.button3.setTitle(String(section*3), forState: UIControlState.Normal)
            }
            cell = cell1
        }
        else {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("CallButtonCell", forIndexPath: indexPath) as! CallViewCellButton
            cell1.button.setTitle("Call", forState: UIControlState.Normal)
            cell = cell1
        }
        
       return cell
    }


}
