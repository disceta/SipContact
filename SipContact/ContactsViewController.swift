import UIKit

class ContactsViewController: UICollectionViewController {
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: userCollectionViewCellHeight, height: userCollectionViewCellHeight)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
        self.init(collectionViewLayout: layout)
        title = "Users"
    }

    deinit {
        if isViewLoaded() {
            account.removeObserver(self, forKeyPath: "users")
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.alwaysBounceVertical = true
        collectionView!.backgroundColor = .whiteColor()
        collectionView!.registerClass(UserCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UserCollectionViewCell))
        account.addObserver(self, forKeyPath: "users", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        if account.accessToken == "guest_access_token" { return }
        getUsers()
    }
    
    func getUsers() -> NSURLSessionDataTask {
        sipios_api.contact_get_contacts("", { data, error in
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
                        let ID = UInt(item["id"] as! String)!
                        
                        if ID == account.user.ID {
                            //accountUserName = (name, "")
                        } else {
                            let user = User(ID: ID, username: name, firstName: name, lastName: "")
                            account.users.append(user)
                        }
                        //[[sipiosManager sharedManager] subscribe:tel];
                    }
                    //[self.tableView reloadData];
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

    // MARK: - NSKeyValueObserving

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        collectionView!.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return account.users.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(UserCollectionViewCell), forIndexPath: indexPath) as! UserCollectionViewCell
        let user = account.users[indexPath.item]
        cell.nameLabel.text = user.name
        if let pictureName = user.pictureName() {
            (cell.backgroundView as! UIImageView).image = UIImage(named: pictureName)
        } else {
            (cell.backgroundView as! UIImageView).image = nil
        }
        return cell
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let user = account.users[indexPath.item]
        navigationController?.pushViewController(ChatViewController(chat: account.chats[0]), animated: true)
    }
}
