//
//  FriandsListModel.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 6.08.21.
//

import Foundation

struct FreindsList: Codable {
    let count: Int?
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let firstName: String?
    let id: Int?
    let lastName: String?
    let canAccessClosed, isClosed: Bool?
    let trackCode: String?

}









