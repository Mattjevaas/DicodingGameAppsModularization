//
//  GetAddsRepository.swift
//  GameDLC
//
//  Created by admin on 26/09/23.
//

import Core
import Combine

struct GetAddsRepository<RemoteDataSource: DataSource>: Repository where RemoteDataSource.Response == GameAddsListResponse {
    
    
    public typealias Request = Any
    public typealias Response = [GameDLCModel]
    
    private let _remoteDataSource: RemoteDataSource
    
    public init(remoteDataSource: RemoteDataSource) {
        _remoteDataSource = remoteDataSource
    }
    
    public func execute(request: Request?) -> AnyPublisher<[GameDLCModel], Error> {
        return _remoteDataSource.execute(request: nil)
            .map { value in
                value.results.map { result in
                    return GameDLCModel(
                        gameId: result.id,
                        gameTitle: result.name,
                        gameImage: result.backgroundImage
                    )
                }
            }.eraseToAnyPublisher()
    }
}
