//
//  FriandsListModel.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 6.08.21.
//

import Foundation

struct FriendsList: Decodable {
    let count: Int
    let items: [Item]?
}

// MARK: - Item
struct Item: Decodable {
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case trackCode = "track_code"
        case photo_50
        case isClosed = "is_closed"
    }

    let firstName: String?
    let id: Int
    let lastName: String?
    let canAccessClosed: Bool?
    let isClosed: Bool?
    let trackCode: String
    let photo_50: String?
}









