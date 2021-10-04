//
//  CityModel.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 4.10.21.
//

import Foundation

struct City: Decodable {
   
    enum CodingKeys: String, CodingKey {
        case title = "title"
    }

    let title: String
}
