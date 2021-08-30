//
//  HomeCell.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 30.08.21.
//

import UIKit

class HomeCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with image: UIImage) {
        imageView.image = image
    }
    
//    static func nib() -> UINib {
//        return UINib(nibName: "collectionViewCell", bundle: nil)
//    }

}
