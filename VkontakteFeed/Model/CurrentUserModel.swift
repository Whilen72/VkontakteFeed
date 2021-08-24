//
//  CurrentUserModel.swift
//  VkontakteFeed
//
//  Created by Daniil Lobanov on 16.08.21.
//

import Foundation

struct  CurrentUser: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case id
    }
    let firstName: String
    let id: Int
    let lastName: String
}



