//
//  FriendsCell.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 6.08.21.
//

import UIKit

class FriendsCell: UITableViewCell {
    
      let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        superview?.addSubview(nameLabel)
        superview?.addSubview(iconImageView)
        
        iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 26).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 12).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: 1).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:61).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 15).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 79).isActive = true

    }
    
    func launchCell() {
        
    }
}
