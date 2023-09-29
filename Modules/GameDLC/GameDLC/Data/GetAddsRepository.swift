//
//  GetAddsRepository.swift
//  GameDLC
//
//  Created by admin on 26/09/23.
//

import Core
import Combine

public struct GetAddsRepository<RemoteDataSource: DataSource>: Repository
where
RemoteDataSource.Response == GameAddsListResponse,
RemoteDataSource.Request == String {
    
    
    public typealias Request = String
    public typealias Response = [GameDLCModel]
    
    private let _remoteDataSource: RemoteDataSource
    
    public init(remoteDataSource: RemoteDataSource) {
        _remoteDataSource = remoteDataSource
    }
    
    public func execute(request: String?) -> AnyPublisher<[GameDLCModel], Error> {
        return _remoteDataSource.execute(request: request)
            .map { value in
                value.results.map { result in
                    return GameDLCModel(
                        gameId: result.id,
                        gameTitle: result.name,
                        gameImage: result.backgroundImage ?? ""
                    )
                }
            }.eraseToAnyPublisher()
    }
}
