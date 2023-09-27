//
//  SaveGameDataRepository.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Core
import Combine
import RealmSwift

public struct SaveGameDataRepository<GameLocaleDataSource: LocaleDataSource>: Repository
where
    GameLocaleDataSource.Request == GameRealmEntity,
    GameLocaleDataSource.Response == [FavoriteGameModel]
{
    
    public typealias Request = GameRealmEntity
    public typealias Response = Bool
    
    private let _localDataSource: GameLocaleDataSource
    
    public init(localDataSource: GameLocaleDataSource) {
        _localDataSource = localDataSource
    }
    
    
    public func execute(request: GameRealmEntity?) -> AnyPublisher<Bool, Error> {
        guard let request = request else { fatalError("Request cannot be empty") }
    
        let gameData = GameRealmEntity()
        
        gameData.gameId = request.gameId
        gameData.gameTitle = request.gameTitle
        gameData.gameRating = request.gameRating
        gameData.gameDesc = request.gameDesc
        gameData.gameReleasedDate = request.gameReleasedDate
        gameData.gameImage = request.gameImage
        
        return self._localDataSource.saveData(object: gameData).eraseToAnyPublisher()
    }
}
