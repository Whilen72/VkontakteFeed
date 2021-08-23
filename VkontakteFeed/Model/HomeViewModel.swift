//
//  HomeViewModel.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 19.08.21.
//

import Foundation

struct UserInfo: Decodable {
           
    enum CodingKeys: String, CodingKey {
        case first_name
        case id
        case last_name
        case online
        case city
        case photo_400_orig
        case followers_count
        case bdate
    }
    
    let first_name: String
    let id: Int
    let last_name: String
    let online: Int
    let city: [City]
    let photo_400_orig: String
    let followers_count: Int
    let bdate: String
}

struct City: Decodable {
    let title: String
}
  
