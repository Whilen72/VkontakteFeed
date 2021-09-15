//
//  FeedModel.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 29.08.21.
//

import Foundation

struct FeedModel {
    let items:[Post]?
}

struct Post {
    let type: String
    let date: Int
    let text: String
    let likes: [Likes]
}

struct Likes {
    let count: Int
}
