//
//  HomeViewModel.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 19.08.21.
//

import Foundation

struct MainScreen: Decodable {
    let response: [UserInfo]?
}


struct UserInfo: Decodable {
    let first_name: String
    let id: Int
    let last_name: String
    let online: Int
    let city: City
    let photo_400_orig: String
    let followers_count: Int
}


struct City: Decodable {
    let title: String
}
  
