import UIKit

class WelcomeViewController: UIViewController {
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()

        let logoLabel = UILabel(frame: CGRect(x: 0, y: 44, width: view.frame.width, height: 60))
        logoLabel.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin, .FlexibleBottomMargin]
        logoLabel.font = UIFont.boldSystemFontOfSize(36)
        logoLabel.text = "SipContact"
        logoLabel.textAlignment = .Center
        //logoLabel.textColor = .whiteColor()
        view.addSubview(logoLabel)

        let taglineLabel = UITextView(frame: CGRect(x: 0, y: 150, width: view.frame.width, height: 90))
        taglineLabel.autoresizingMask = logoLabel.autoresizingMask
        taglineLabel.font = UIFont.boldSystemFontOfSize(18)
        taglineLabel.text = "Вас приветствует система связи для корпоративных клиентов!"
        taglineLabel.textAlignment = .Center
        //taglineLabel.textColor = .whiteColor()
        view.addSubview(taglineLabel)

        
        let logInButton = UIButton(type: .Custom)
        logInButton.tag = 1
        logInButton.autoresizingMask = [.FlexibleTopMargin, .FlexibleWidth]
        logInButton.setBackgroundColor(.blueColor(), forState: .Normal)
        logInButton.frame = CGRect(x: 0, y: view.frame.height-64, width: view.frame.width, height: 64)
        logInButton.titleLabel?.font = UIFont.boldSystemFontOfSize(32)
        logInButton.setTitle("Log In", forState: .Normal)
        logInButton.addTarget(self, action: #selector(WelcomeViewController.signUpLogInAction(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(logInButton)

        let continueAsGuestButton = UIButton(type: .Custom)
        continueAsGuestButton.addTarget(account, action: #selector(Account.continueAsGuest), forControlEvents: .TouchUpInside)
        continueAsGuestButton.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin]
        continueAsGuestButton.frame = CGRect(x: (view.frame.width-184)/2, y: view.frame.height-188, width: 184, height: 44)
        continueAsGuestButton.setTitleColor(.blueColor(), forState: .Normal)
        continueAsGuestButton.setTitleColor(.darkGrayColor(), forState: .Highlighted)
        continueAsGuestButton.setTitle("Войти как гость? >>>", forState: .Normal)
        continueAsGuestButton.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        view.addSubview(continueAsGuestButton)
        
        if account.issaved {
            account.getMe(self)
        }

    }

    // MARK: - Actions

    func signUpLogInAction(button: UIButton) {
        let tableViewController = LogInTableViewController()
        let navigationController = UINavigationController(rootViewController: tableViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    
    }
}
