import UIKit

let userPresenseNotificationKey = "userPresenseNotificationKey"


let favoritTableViewCellHeight: CGFloat = 68
let favoritTableViewCellInsetLeft = favoritTableViewCellHeight + 8

class FavoritTableViewCell: UITableViewCell {
    let userPictureImageView: UserPictureImageView
    let userNameLabel: UILabel
    let presenceLabel: UILabel
    let lastMessageTextLabel: UILabel
    let lastMessageSentDateLabel: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        userPictureImageView = UserPictureImageView(frame: CGRect(x: 8, y: (favoritTableViewCellHeight-64)/2, width: 64, height: 64))

        userNameLabel = UILabel(frame: CGRectZero)
        userNameLabel.backgroundColor = .whiteColor()
        userNameLabel.font = UIFont.systemFontOfSize(17)

        lastMessageTextLabel = UILabel(frame: CGRectZero)
        lastMessageTextLabel.backgroundColor = .whiteColor()
        lastMessageTextLabel.font = UIFont.systemFontOfSize(15)
        lastMessageTextLabel.numberOfLines = 2
        lastMessageTextLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)

        lastMessageSentDateLabel = UILabel(frame: CGRectZero)
        lastMessageSentDateLabel.autoresizingMask = .FlexibleLeftMargin
        lastMessageSentDateLabel.backgroundColor = .whiteColor()
        lastMessageSentDateLabel.font = UIFont.systemFontOfSize(15)
        lastMessageSentDateLabel.textColor = lastMessageTextLabel.textColor
        
        presenceLabel = UILabel(frame: CGRectZero)
        presenceLabel.textColor = .grayColor()
        presenceLabel.font = UIFont.systemFontOfSize(34)
        //presenceLabel.textAlignment = .Left
        presenceLabel.text = "."

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(presenceLabel)
        contentView.addSubview(userPictureImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(lastMessageTextLabel)
        contentView.addSubview(lastMessageSentDateLabel)
 

        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: userNameLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: favoritTableViewCellInsetLeft))
        contentView.addConstraint(NSLayoutConstraint(item: userNameLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 6))


        presenceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: presenceLabel, attribute: .Left, relatedBy: .Equal, toItem: userNameLabel, attribute: .Left, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: presenceLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 6))
        contentView.addConstraint(NSLayoutConstraint(item: presenceLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 10))
 
        lastMessageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: lastMessageTextLabel, attribute: .Left, relatedBy: .Equal, toItem: presenceLabel, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: lastMessageTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 28))
        contentView.addConstraint(NSLayoutConstraint(item: lastMessageTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -7))
        contentView.addConstraint(NSLayoutConstraint(item: lastMessageTextLabel, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -4))

        lastMessageSentDateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: lastMessageSentDateLabel, attribute: .Left, relatedBy: .Equal, toItem: userNameLabel, attribute: .Right, multiplier: 1, constant: 2))
        contentView.addConstraint(NSLayoutConstraint(item: lastMessageSentDateLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -7))
        contentView.addConstraint(NSLayoutConstraint(item: lastMessageSentDateLabel, attribute: .Baseline, relatedBy: .Equal, toItem: userNameLabel, attribute: .Baseline, multiplier: 1, constant: 0))
        

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWithUser(user: User) {
        userPictureImageView.configureWithUser(user)
        userNameLabel.text = user.name
        //presenceLabel.text = "."
        if user.presence == 1 {
            presenceLabel.textColor = .greenColor()
        }
        else {
            presenceLabel.textColor = .redColor()
        }
        lastMessageTextLabel.text = user.username
        //lastMessageTextLabel.text = chat.lastMessageText
        //lastMessageSentDateLabel.text = user.chat.lastMessageSentDateString
    }
}
