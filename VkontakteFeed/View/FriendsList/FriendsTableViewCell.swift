//
//  FriendsTableViewCell.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 13.09.21.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var isOnline: UILabel!
    
    static let reuseId = "friendsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        friendImage.contentMode = .scaleToFill
        friendImage.layer.cornerRadius = friendImage.frame.width/2
        friendImage.layer.masksToBounds = true
        backgroundColor = .backgroundColor
        nameLabel.textColor = .fontColor
        cityLabel.textColor = .fontColor
        isOnline.textColor = .fontColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with image: UIImage, name: String, city: String, onlineStatus: String) {
        friendImage.image = image
        nameLabel.text = name
        cityLabel.text = city
        isOnline.text = onlineStatus
    }
}
