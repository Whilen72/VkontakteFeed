//
//  CurrentUserModel.swift
//  VkontakteFeed
//
//  Created by Daniil Lobanov on 16.08.21.
//

import Foundation

struct  CurrentUser: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
    }
    let id: String
}



