//
//  GetGameDetailRemoteDataSource.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Core
import Combine
import Alamofire
import Foundation

public struct GetGameDetailRemoteDataSource: DataSource {
    
    public typealias Request = GetGameDetailRequest
    public typealias Response = GameDetailResponse
    
    private let _apiKey: String
    
    public init(apiKey: String ) {
        _apiKey = apiKey
    }
    
    public func execute(request: Request?) -> AnyPublisher<Response, Error> {
        
        return Future<GameDetailResponse, Error> { completion in
            
            guard let request = request else { return completion(.failure(URLError.invalidRequest) )}
            
            var component = URLComponents(string: "https://api.rawg.io/api/games/\(request.gameId)")!
            
            component.queryItems = [
                URLQueryItem(name: "key", value: _apiKey)
            ]
            
            let req = URLRequest(url: (component.url)!)
            
            AF.request(req.url!).validate().responseDecodable(of: GameDetailResponse.self) { response in
                
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure:
                    completion(.failure(URLError.invalidResponse))
                }
            }
        }.eraseToAnyPublisher()
    }
}
