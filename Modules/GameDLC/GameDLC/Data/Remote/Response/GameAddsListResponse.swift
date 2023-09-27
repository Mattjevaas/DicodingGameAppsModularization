//
//  GameAddsListResponse.swift
//  GameDLC
//
//  Created by admin on 26/09/23.
//

import Foundation

// MARK: - GameAddsListResponse
struct GameAddsListResponse: Codable {
    let count: Int
    let next, previous: String
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let slug, name, released: String
    let tba: Bool
    let backgroundImage: String
    let rating, ratingTop: Int
    let ratings: AddedByStatus
    let ratingsCount: Int
    let reviewsTextCount: String
    let added: Int
    let addedByStatus: AddedByStatus
    let metacritic, playtime, suggestionsCount: Int
    let updated: Date
    let esrbRating: EsrbRating
    let platforms: [Platform]

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case addedByStatus = "added_by_status"
        case metacritic, playtime
        case suggestionsCount = "suggestions_count"
        case updated
        case esrbRating = "esrb_rating"
        case platforms
    }
}

// MARK: - AddedByStatus
struct AddedByStatus: Codable {
}

// MARK: - EsrbRating
struct EsrbRating: Codable {
    let id: Int
    let slug, name: String
}

// MARK: - Platform
struct Platform: Codable {
    let platform: EsrbRating
    let releasedAt: String
    let requirements: Requirements

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirements
    }
}

// MARK: - Requirements
struct Requirements: Codable {
    let minimum, recommended: String
}

