//
//  PhtosCollectionViewCell.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 16.10.21.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "PhotosCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = imageView.frame.width/1.9
        imageView.layer.masksToBounds = true
    }
}
