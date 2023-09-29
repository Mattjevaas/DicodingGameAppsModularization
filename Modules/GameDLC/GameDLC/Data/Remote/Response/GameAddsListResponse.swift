//
//  GameAddsListResponse.swift
//  GameDLC
//
//  Created by admin on 26/09/23.
//

import Foundation

// MARK: - GameAddsListResponse
public struct GameAddsListResponse: Codable {
    let count: Int
    let next, previous: String?
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let name, released: String
    let backgroundImage: String?

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
    }
}

