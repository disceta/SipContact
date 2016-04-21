import Foundation.NSString

class User : sipiosBuddyWrapper {
    let ID: UInt
    var username: String
    dynamic var firstName: String
    dynamic var lastName: String
    dynamic var presence: Int32
    var chat: Chat!
    
    var name: String {
        return firstName + " " + lastName
    }
    var initials: String? {
        var initials: String?
        for name in [firstName, lastName] {
            if name != "" {
            let initial = name.substringToIndex(name.startIndex.advancedBy(1))
            if initial.lengthOfBytesUsingEncoding(NSNEXTSTEPStringEncoding) > 0 {
                initials = initials == nil ? initial : initials! + initial
            }
            }
        }
        return initials
    }
    
    init(ID: UInt, username: String, firstName: String, lastName: String) {
        self.ID = ID
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.presence = 0
        super.init(account)
        chat = Chat(user: self, lastMessageText: "", lastMessageSentDate: NSDate())
    }
    
    func pictureName() -> String? {
        return ID > 0 ? nil : "User\(ID).jpg"
    }
    
    func subscribe() {
        super.subscribe(username);
    }
    
    override func onSubscribe(state:Int32) {
        NSLog("subscribe comming %@ state=%d", username, state)
        presence = state
        NSNotificationCenter.defaultCenter().postNotificationName(changePresenceNotityKey, object: self)
    }
}
