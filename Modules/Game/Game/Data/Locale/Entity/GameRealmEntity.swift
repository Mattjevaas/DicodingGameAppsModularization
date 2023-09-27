//
//  GameRealmEntity.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Foundation
import RealmSwift

public class GameRealmEntity: Object {
    @Persisted var gameId: Int
    @Persisted var gameTitle: String
    @Persisted var gameRating: String
    @Persisted var gameImage: Data
    @Persisted var gameReleasedDate: String
    @Persisted var gameDesc: String
    
    public init(gameId: Int, gameTitle: String, gameRating: String, gameImage: Data, gameReleasedDate: String, gameDesc: String) {
        self.gameId = gameId
        self.gameTitle = gameTitle
        self.gameRating = gameRating
        self.gameImage = gameImage
        self.gameReleasedDate = gameReleasedDate
        self.gameDesc = gameDesc
    }
}
