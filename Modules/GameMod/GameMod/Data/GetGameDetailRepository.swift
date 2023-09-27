//
//  GetGameDetailRepository.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Core
import Combine
import RealmSwift

public struct GetGameDetailRepository<GetGameDetailRemoteDataSource: DataSource>: Repository
where
    GetGameDetailRemoteDataSource.Request == GetGameDetailRequest,
    GetGameDetailRemoteDataSource.Response == GameDetailResponse
{
    
    public typealias Request = GetGameDetailRequest
    public typealias Response = GameModel
    
    private let _remoteDataSource: GetGameDetailRemoteDataSource
    
    public init(remoteDataSource: GetGameDetailRemoteDataSource) {
        _remoteDataSource = remoteDataSource
    }
    
    public func execute(request: GetGameDetailRequest?) -> AnyPublisher<GameModel, Error> {
        return self._remoteDataSource.execute(request: request).map { result in
            var fixedDate = "unknown"
                    
            let formatterOne = DateFormatter()
            formatterOne.dateFormat = "yyyy-mm-dd"

            let formatterTwo = DateFormatter()
            formatterTwo.dateFormat = "dd-mm-yyyy"

            if let dateOne = formatterOne.date(from: result.released ?? "") {
                fixedDate = formatterTwo.string(from: dateOne)
            }
            
            return GameModel(
                gameId: result.id ?? 0,
                gameTitle: result.nameOriginal ?? "",
                gameRating: Float(result.rating ?? 0.0),
                gameImage: result.backgroundImage ?? "",
                gameReleasedDate: fixedDate,
                gameDesc: result.descriptionRaw ?? ""
            )
        }.eraseToAnyPublisher()
    }
}
