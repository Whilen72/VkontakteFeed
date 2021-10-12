//
//  HomeViewModel.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 19.08.21.
//

import Foundation

struct UserInfo: Decodable {
           
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case online
        case city
        case photo_max_orig = "photo_max_orig"
        case followersCount = "followers_count"
        case bdate
        
    }
    
    let firstName: String
    let id: Int
    let lastName: String
    let online: Int
    let city: City?
    let photo_max_orig: String
    let followersCount: Int
    let bdate: String
}

//struct City: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case id
//        case title
//    }
//
//    let id: Int
//    let title: String
//}
  
