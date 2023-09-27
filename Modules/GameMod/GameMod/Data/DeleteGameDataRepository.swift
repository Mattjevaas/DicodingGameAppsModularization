//
//  DeleteGameDataRepository.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Core
import Combine
import RealmSwift

public struct DeleteGameDataRepository<GameLocaleDataSource: LocaleDataSource>: Repository
where
    GameLocaleDataSource.Request == GameRealmEntity,
    GameLocaleDataSource.Response == [FavoriteGameModel]
{
    
    public typealias Request = String
    public typealias Response = Bool
    
    private let _localDataSource: GameLocaleDataSource
    
    public init(localDataSource: GameLocaleDataSource) {
        _localDataSource = localDataSource
    }
    
    
    public func execute(request: String?) -> AnyPublisher<Bool, Error> {
        guard let request = request else { fatalError("Request cannot be empty") }
    
        return self._localDataSource.deleteData(type: GameRealmEntity.self, predicate: NSPredicate(format: "gameId == \(request)")).eraseToAnyPublisher()
    }
}
