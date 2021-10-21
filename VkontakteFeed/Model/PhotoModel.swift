//
//  PhotoModel.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 24.08.21.
//

import Foundation

struct PhotosResponse: Decodable {
    let count: Int
    let items: [Album]?
}

struct Album: Decodable {
    let sizes: [PhotoModel]
    
    enum CodingKeys: String, CodingKey {
       case sizes
    }
    
    func getUrlM() -> String? {
        var urlString: String?
        self.sizes.forEach { photoModel in
            if photoModel.type == "m" {
                urlString = photoModel.url
            }
        }
        return urlString
    }
    
    func getUrlFullScreen() -> String? {
        var urlString: String?
        self.sizes.forEach { photoModel in
            if photoModel.type == "y" {
                urlString = photoModel.url
            }
        }
        if urlString == nil {
            self.sizes.forEach { photoModel in
                if photoModel.type == "x" {
                    urlString = photoModel.url
                }
            }
        }
        return urlString
    }
}
struct PhotoModel: Decodable {
    let height: Int
    let url: String
    let type: String
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case height
        case url
        case type
        case width
    }
    
    
}
