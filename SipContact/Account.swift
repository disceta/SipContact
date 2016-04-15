import UIKit
import NetworkExtension

class Account: sipiosAccountWrapper {
    private let AccessTokenKey = "AccessTokenKey"
    private let UserNameTokenKey = "UserNameTokenKey"
    private let PasswordTokenKey = "PasswordTokenKey"
    private let IsSavedTokenKey = "IsSavedTokenKey"
    private var _accessToken: String!
    private var _username: String!
    private var _password: String!
    private var _issaved: Bool!
    
    dynamic var accessToken: String? {
        get {
            guard let accessToken = _accessToken else {
                _accessToken = NSUserDefaults.standardUserDefaults().stringForKey(AccessTokenKey)
                return _accessToken
            }
            return accessToken
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: AccessTokenKey)
            _accessToken = newValue
        }
    }
    dynamic var username: String? {
        get {
            guard let username = _username else {
                _username = NSUserDefaults.standardUserDefaults().stringForKey(UserNameTokenKey)
                return _username
            }
            return username
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: UserNameTokenKey)
            _username = newValue
        }
    }
    dynamic var password: String? {
        get {
            guard let password = _password else {
                _password = NSUserDefaults.standardUserDefaults().stringForKey(PasswordTokenKey)
                return _password
            }
            return password
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: PasswordTokenKey)
            _password = newValue
        }
    }
    dynamic var issaved: Bool {
        get {
            guard let issaved = _issaved else {
                _issaved = NSUserDefaults.standardUserDefaults().boolForKey(IsSavedTokenKey)
                return _issaved
            }
            return issaved
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: IsSavedTokenKey)
            _issaved = newValue
        }
    }

    var chats = [Chat]()
    dynamic var email: String!
    dynamic var users = [User]()
    var user: User!
        
    func continueAsGuest() {
        let minute: NSTimeInterval = 60, hour = minute * 60, day = hour * 24
        chats = [
            Chat(user: User(ID: 1, username: "mattdipasquale", firstName: "Matt", lastName: "Di Pasquale"), lastMessageText: "Thanks for checking out Chats! :-)", lastMessageSentDate: NSDate()),
            Chat(user: User(ID: 2, username: "samihah", firstName: "Angel", lastName: "Rao"), lastMessageText: "6 sounds good :-)", lastMessageSentDate: NSDate(timeIntervalSinceNow: -5))
       ]
        
        chats[1].loadedMessages = [
            [
                Message(incoming: true, text: "I really enjoyed programming with you! :-)", sentDate: NSDate(timeIntervalSinceNow: -60*60*24*2-60*60)),
                Message(incoming: false, text: "Thanks! Me too! :-)", sentDate: NSDate(timeIntervalSinceNow: -60*60*24*2))
            ]
        ]
        
        for chat in chats {
            users.append(chat.user)
            chat.loadedMessages.append([Message(incoming: true, text: chat.lastMessageText, sentDate: chat.lastMessageSentDate)])
        }
        
        email = "guest@example.com"
        //user = ServerUser(ID: 0, username: "guest", firstName: "Guest", lastName: "User")
        //accessToken = "3"
    }

    func getMe(viewController: UIViewController) {
         sipios_api.contact_login(username, password, completion:{ data, error in
         if error != nil {
            return;
         }
         dispatch_async(dispatch_get_main_queue(), {
         do {
            let json_data = data.dataUsingEncoding(NSUTF8StringEncoding);
            //NSLog("me jsob data: %s", json_data)
             //var users = (User)[]
             if let boardsDictionary = try NSJSONSerialization.JSONObjectWithData(json_data!, options: [NSJSONReadingOptions.MutableContainers]) as? Array<NSDictionary> {
                let dictionary = boardsDictionary[0]
                self.accessToken = dictionary["usr_id"] as! String
                //self.user.serverFirstName = name["first"]!
                //self.user.serverLastName = name["last"]!
                //self.email = dictionary["email"]! as! String
            }
            
         } catch let error as NSError {
            print(error.localizedDescription)
         }
         });
         
         })
     }
    
    func registration() {
        super.registration(self.username, self.password)
    }
    
    override func onRegister(state: Int32) {
        NSLog("register coming state=%d", state);
    }

    func patchMe(viewController: UIViewController, firstName: String, lastName: String) -> NSURLSessionDataTask {
        return NSURLSessionDataTask()
    }

    func changeEmail(viewController: UIViewController, newEmail: String) -> NSURLSessionDataTask {
       return NSURLSessionDataTask()
    }

    func logOut(viewController: UIViewController) -> NSURLSessionDataTask {
        return NSURLSessionDataTask()
    }

    func deleteAccount(viewController: UIViewController) -> NSURLSessionDataTask {
         return NSURLSessionDataTask()
    }

    func setUserWithAccessToken(accessToken: String, firstName: String, lastName: String) {
        let userIDString = "FF"//accessToken.substringToIndex(accessToken.endIndex.advancedBy(-33))
        let userID = UInt(100) //UInt(Int(userIDString)!)
        user = User(ID: userID, username: "", firstName: firstName, lastName: lastName)
    }

    func reset() {
        //accessToken = nil
        chats = []
        email = nil
        user = nil
        users = []
    }

}

let AccountDidSendMessageNotification = "AccountDidSendMessageNotification"
