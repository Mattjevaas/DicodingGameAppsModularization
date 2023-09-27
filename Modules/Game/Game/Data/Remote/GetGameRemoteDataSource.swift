//
//  GetGameRemoteDataSource.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Core
import Combine
import Alamofire
import Foundation

public struct GetGameRemoteDataSource: DataSource {
    
    public typealias Request = GetGameRequest
    public typealias Response = GameResponse

    private let _apiKey: String
    
    public init(apiKey: String) {
        _apiKey = apiKey
    }
    
    public func execute(request: Request?) -> AnyPublisher<Response, Error> {
        
        return Future<GameResponse, Error> { completion in
            
            guard let request = request else { return completion(.failure(URLError.invalidRequest) )}
            
            var component = URLComponents(string: "https://api.rawg.io/api/games")!
            
            component.queryItems = [
                URLQueryItem(name: "key", value: _apiKey ),
                URLQueryItem(name: "page_size", value: String(request.pageSize) )
            
            ]
            
            let req = URLRequest(url: (component.url)!)
            
            AF.request(req.url!).validate().responseDecodable(of: GameResponse.self) { response in
                
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
