//
//  FavoriteGameModel.swift
//  Game
//
//  Created by admin on 26/09/23.
//

public struct FavoriteGameModel {
    public let gameId: Int
    public let gameTitle: String
    public let gameRating: String
    public let gameImage: Data
    public let gameReleasedDate: String
    public let gameDesc: String
    
    public init(gameId: Int, gameTitle: String, gameRating: String, gameImage: Data, gameReleasedDate: String, gameDesc: String) {
        self.gameId = gameId
        self.gameTitle = gameTitle
        self.gameRating = gameRating
        self.gameImage = gameImage
        self.gameReleasedDate = gameReleasedDate
        self.gameDesc = gameDesc
    }
}
