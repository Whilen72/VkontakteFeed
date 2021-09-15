//
//  AuthModel.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 3.08.21.
//

import Foundation

struct authorizeUrl: Codable {
    var authorize_url = [loginModel]()
}

struct loginModel: Codable {
   var access_token: String
   var expires_in: String
   var user_id: String
}

