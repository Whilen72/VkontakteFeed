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
