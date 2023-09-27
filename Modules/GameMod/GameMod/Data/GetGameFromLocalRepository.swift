//
//  GetGameFromLocalRepository.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Core
import Combine
import RealmSwift

public struct GetGameDataFromLocalRepository<GameLocaleDataSource: LocaleDataSource>: Repository
where
    GameLocaleDataSource.Request == GameRealmEntity,
    GameLocaleDataSource.Response == [FavoriteGameModel]
{
    
    public typealias Request = Any
    public typealias Response = [FavoriteGameModel]
    
    private let _localDataSource: GameLocaleDataSource
    
    public init(localDataSource: GameLocaleDataSource) {
        _localDataSource = localDataSource
    }
    
    
    public func execute(request: Any?) -> AnyPublisher<[FavoriteGameModel], Error> {
    
        return self._localDataSource.fetchData(type: GameRealmEntity.self).map { result in
            
            var gameArr: [FavoriteGameModel] = []
            
            result.forEach { data in
                
                let favGameModel = FavoriteGameModel(
                    gameId: data.gameId,
                    gameTitle: data.gameTitle,
                    gameRating: data.gameRating,
                    gameImage: data.gameImage,
                    gameReleasedDate: data.gameReleasedDate,
                    gameDesc: data.gameDesc
                )
                
                gameArr.append(favGameModel)
            }
            
            return gameArr
        }.eraseToAnyPublisher()
    }
}

