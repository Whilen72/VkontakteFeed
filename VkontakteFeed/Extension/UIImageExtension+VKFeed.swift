//
//  File.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 3.09.21.
//

import UIKit

extension UIImage {
    
   static func loadImageFromUrl(url: URL, completion: @escaping (UIImage)->())  {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                completion(image)
            }
        }
    }
}
