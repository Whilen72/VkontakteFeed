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
        cityLabel.font = cityLabel.font.withSize(12)
        isOnline.textColor = .green
        isOnline.font = isOnline.font.withSize(12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with imageURL: URL, name: String, city: String, onlineStatus: String) {
        nameLabel.text = name
        cityLabel.text = "City: \(city)"
        isOnline.text = onlineStatus
        
        DispatchQueue.main.async {
            UIImage.loadImageFromUrl(url: imageURL) { [weak self] image in
                guard let self = self else { return }
                self.friendImage.image = image
            }
        }
    }
}
