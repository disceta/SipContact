import UIKit

let account = Account()
let sipios_api = sipiosManager()
var api = API(baseURL: NSURL(string: "http://rastel.dyndns-work.com:25069/SipContact")!) // production

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        account.accessToken = nil
        account.addObserver(self, forKeyPath: "accessToken", options: NSKeyValueObservingOptions(rawValue: 0), context: nil) // always
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = .whiteColor()
        updateRootViewController()
        window!.makeKeyAndVisible()
        account.issaved = false
        
        return true
    }

    // MARK: - NSKeyValueObserving

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        updateRootViewController()
    }

    func updateRootViewController() {
        if account.accessToken == nil {
            window!.rootViewController = WelcomeViewController(nibName: nil, bundle: nil)
        } else {
            account.registration()
            let tabBarController = createTabBarController()
            window!.rootViewController = tabBarController
            if account.accessToken == "guest_access_token" { return }
        }
    }

    // MARK: - Helpers

    func createTabBarController() -> UITabBarController {
        let usersCollectionViewController = ContactsViewController()
        usersCollectionViewController.tabBarItem.image = UIImage(named: "Users")
        let usersNavigationController = UINavigationController(rootViewController: usersCollectionViewController)

        let phoneViewController = PhoneViewController()
        phoneViewController.tabBarItem.image = UIImage(named: "Phone")
        let phoneNavigationController = UINavigationController(rootViewController: phoneViewController)

        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .Search, tag: 1)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)

        let favoritsTableViewController = FavoritsTableViewController()
        favoritsTableViewController.tabBarItem.image = UIImage(named: "Chats")
        let favoritsNavigationController = UINavigationController(rootViewController: favoritsTableViewController)

        let settingsTableViewController = SettingsTableViewController()
        settingsTableViewController.tabBarItem.image = UIImage(named: "Settings")
        let settingsNavigationController = UINavigationController(rootViewController: settingsTableViewController)

        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.viewControllers = [ favoritsNavigationController, phoneNavigationController,   searchNavigationController, settingsNavigationController]
        
        sipios_api.start()
        
        return tabBarController
    }
}
