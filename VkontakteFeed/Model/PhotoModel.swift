//
//  PhotoModel.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 24.08.21.
//

import Foundation

struct Photos: Decodable {
    let count: Int
    let items: [Album]?
}

struct Album: Decodable {
    let sizes: [SizeAndPhotoUrl]
    
    enum CodingKeys: String, CodingKey {
       case sizes
    }
}

struct SizeAndPhotoUrl: Decodable {
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
