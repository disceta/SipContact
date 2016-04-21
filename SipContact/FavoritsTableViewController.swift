import UIKit

let changePresenceNotityKey = "changPresenceNotiyKey"

class FavoritsTableViewController: UITableViewController {
    var users: [User] { return account.users }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    convenience init() {
        self.init(style: .Plain)
        title = "Favorits"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(FavoritsTableViewController.newMessageAction))
        
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem() // TODO: KVO
        tableView.backgroundColor = .whiteColor()
        tableView.rowHeight = favoritTableViewCellHeight
        tableView.separatorInset.left = favoritTableViewCellInsetLeft
        
        tableView.registerClass(FavoritTableViewCell.self, forCellReuseIdentifier: "FavoritCell")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FavoritsTableViewController.accountDidSendMessage(_:)), name: AccountDidSendMessageNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector (FavoritsTableViewController.updatePresenceNotify(_:)), name: changePresenceNotityKey, object: nil)
      getUsers()
    }

    func getUsers() -> NSURLSessionDataTask {
        sipios_api.contact_get_contacts(account.accessToken, { data, error in
            if error != nil {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), {
                do {
                    let json_data = data.dataUsingEncoding(NSUTF8StringEncoding);
                    //var users = (User)[]
                    if let boardsDictionary = try NSJSONSerialization.JSONObjectWithData(json_data!, options: [NSJSONReadingOptions.MutableContainers]) as? Array<NSDictionary> {
                        for item in boardsDictionary as! Array<Dictionary<String, AnyObject> > {
                            let tel = item["nick"] as! String
                            NSLog("data = %@", tel)
                            let name = item["name"] as! String
                            let uri = item["nick"] as! String
                            let ID = UInt(item["id"] as! String)!
                            
                            if ID == account.user.ID {
                                //accountUserName = (name, "")
                            } else {
                                let user = User(ID: ID, username: uri, firstName: name, lastName: "")
                                account.users.append(user)
                                //if account.users.indexOf(user) < 3
                                //{
                                    user.subscribe()
                                //}
                            }
                            //[[sipiosManager sharedManager] subscribe:tel];
                        }
                        self.tableView.reloadData()
                    }
                    else {
                        NSLog("JSONObjectWithData error: not json data")
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            });
            
        })
        return NSURLSessionDataTask()
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoritCell", forIndexPath: indexPath) as! FavoritTableViewCell
        cell.configureWithUser(users[indexPath.row])
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            account.chats.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if users.count == 0 {
                navigationItem.leftBarButtonItem = nil  // TODO: KVO
            }
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let chat = users[indexPath.row].chat {
            let chatViewController = ChatViewController(chat: chat)
            navigationController?.pushViewController(chatViewController, animated: true)
        }
    }
    
    // MARK: - Notification
    /** notify
    */
    func updatePresenceNotify(notification: NSNotification) {
        let user = notification.object as! User
        NSLog("notify presence %@ %d", user.username, user.presence)
        //let idx = users.indexOf(user)
        //let path = NSIndexPath(forItem: idx!, inSection: 0)
        //self.tableView(self.tableView, cellForRowAtIndexPath: path)
        self.tableView.reloadData()
    }

    // MARK: - Actions

    
    func newMessageAction() {
        /*let navigationController = UINavigationController(rootViewController: NewMessageTableViewController(user: nil))
        presentViewController(navigationController, animated: true, completion: nil)
    */
    }

    // MARK: - AccountDidSendMessageNotification

    // Move the note I just commented on to the top
    func accountDidSendMessage(notification: NSNotification) {
        let indexPath0 = NSIndexPath(forRow: 0, inSection: 0)

        let chat = notification.object as! Chat
        let row = users.indexOf { $0 === chat }!
        if row == 0 {
            if users.count > tableView.numberOfRowsInSection(0) {
                return tableView.insertRowsAtIndexPaths([indexPath0], withRowAnimation: .None)
            }
        } else {
            account.chats.removeAtIndex(row)
            account.chats.insert(chat, atIndex: 0)
            let fromIndexPath = NSIndexPath(forRow: row, inSection: 0)
            tableView.moveRowAtIndexPath(fromIndexPath, toIndexPath: indexPath0)
        }

        tableView.reloadRowsAtIndexPaths([indexPath0], withRowAnimation: .None)
    }
}
