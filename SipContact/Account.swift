import UIKit

class Account: sipiosAccountWrapper {
    private let AccountAccessTokenKey = "AccountAccessTokenKey"
    dynamic var accessToken: String? {
        get {
            let accessToken=""
            return accessToken
        }
        set {
        }
    }
    var chats = [Chat]()
    dynamic var email: String!
    dynamic var users = [User]()
    var user: User!
        
    func getMe(viewController: UIViewController) -> NSURLSessionDataTask {
        return NSURLSessionDataTask()
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
