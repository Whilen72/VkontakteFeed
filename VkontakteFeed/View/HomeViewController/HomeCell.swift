//
//  HomeCell.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 30.08.21.
//

import UIKit

class HomeCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    static let reuseId = "collectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = imageView.frame.width/1.9
        imageView.layer.masksToBounds = true
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
        
    }
}
