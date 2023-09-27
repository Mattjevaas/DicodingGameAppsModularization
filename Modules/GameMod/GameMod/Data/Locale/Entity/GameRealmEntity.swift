//
//  GameRealmEntity.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Foundation
import RealmSwift

public class GameRealmEntity: Object {
    @Persisted public var gameId: Int
    @Persisted public var gameTitle: String
    @Persisted public var gameRating: String
    @Persisted public var gameImage: Data
    @Persisted public var gameReleasedDate: String
    @Persisted public var gameDesc: String
    
//    public init(gameId: Int, gameTitle: String, gameRating: String, gameImage: Data, gameReleasedDate: String, gameDesc: String) {
//        self.gameId = gameId
//        self.gameTitle = gameTitle
//        self.gameRating = gameRating
//        self.gameImage = gameImage
//        self.gameReleasedDate = gameReleasedDate
//        self.gameDesc = gameDesc
//    }
//    
//    public override init() {
//        <#code#>
//    }
}
