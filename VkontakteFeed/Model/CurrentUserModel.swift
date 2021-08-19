//
//  CurrentUserModel.swift
//  VkontakteFeed
//
//  Created by Daniil Lobanov on 16.08.21.
//

import Foundation

struct Response: Decodable {
    var response: [CurrentUser]?
}

struct  CurrentUser: Decodable {
    let firstName: String
    let id: Int
    let lastName: String
}



