//
//  GetGameRepository.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Core
import Combine
import RealmSwift
import Foundation

public struct GetGameRepository<GetGameRemoteDataSource: DataSource>: Repository
where
    GetGameRemoteDataSource.Request == GetGameRequest,
    GetGameRemoteDataSource.Response == GameResponse
{
    
    public typealias Request = GetGameRequest
    public typealias Response = [GameModel]
    
    private let _remoteDataSource: GetGameRemoteDataSource
    
    public init(remoteDataSource: GetGameRemoteDataSource) {
        _remoteDataSource = remoteDataSource
    }
    
    
    
    public func execute(request: GetGameRequest?) -> AnyPublisher<[GameModel], Error> {
        return self._remoteDataSource.execute(request: request).map { result in
            
            var gameModel: [GameModel] = []
            
            if let res = result.results {
                gameModel = res.map { data in
                    
                    var fixedDate = "unknown"
                    
                    let formatterOne = DateFormatter()
                    formatterOne.dateFormat = "yyyy-mm-dd"

                    let formatterTwo = DateFormatter()
                    formatterTwo.dateFormat = "dd-mm-yyyy"

                    if let dateOne = formatterOne.date(from: data.released ?? "") {
                        fixedDate = formatterTwo.string(from: dateOne)
                    }
                    
                    return GameModel(
                        gameId: data.id ?? 0,
                        gameTitle: data.name ?? "",
                        gameRating: Float(data.rating ?? 0.0),
                        gameImage: data.backgroundImage ?? "",
                        gameReleasedDate: fixedDate,
                        gameDesc: ""
                    )
                }
            }
            
            return gameModel
            
        }.eraseToAnyPublisher()
    }
}
