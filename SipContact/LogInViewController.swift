import UIKit
import Alerts
import TextFieldTableViewCell
//import Validator

class LogInTableViewController: UITableViewController, UITextFieldDelegate {
    convenience init() {
        self.init(style: .Grouped)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(LogInTableViewController.cancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(LogInTableViewController.doneAction))
        title = "Log In"
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(TextFieldTableViewCell.self, forCellReuseIdentifier: "TextFieldCell")
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell", forIndexPath: indexPath) as! TextFieldTableViewCell
        let textField = cell.textField
        textField.autocapitalizationType = .None
        textField.autocorrectionType = .No
        textField.clearButtonMode = .WhileEditing
        textField.delegate = self
        if indexPath.row == 0 {
            textField.placeholder = "Phone"
            textField.keyboardType = .PhonePad
            if account.issaved {
                textField.text = account.username
            }
        }
        if indexPath.row == 1 {
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            textField.keyboardType = .Default
            if account.issaved {
                textField.text = account.password
            }
        }
        textField.returnKeyType = .Done
        textField.becomeFirstResponder()
        return cell
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        doneAction()
        return true
    }
    
    // MARK: - Actions
    
    func cancelAction() {
        tableView.textFieldForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneAction() {
        let username = tableView.textFieldForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))!.text!
        let password = tableView.textFieldForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))!.text!
        NSLog("%@ %@", username, password)
        account.username = username
        account.password = password
        account.issaved = true
        account.getMe(self)
    }
}
