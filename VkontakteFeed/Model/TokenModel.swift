//
//  TokenModel.swift
//  VkontakteFeed
//
//  Created by Daniil Lobanov on 16.08.21.
//

import Foundation

struct TokenModel {
    let token: [Token]
}

struct Token {
    var accessToken: String
    var userId: String
    var expiresIn: String
}
