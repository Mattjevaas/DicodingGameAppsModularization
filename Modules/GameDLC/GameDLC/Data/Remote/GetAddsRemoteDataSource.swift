//
//  GetAddsRemoteDataSource.swift
//  GameDLC
//
//  Created by admin on 26/09/23.
//

import Core
import Combine
import Alamofire

public struct GetAddsRemoteDataSource : DataSource {
    
    public typealias Request = String
    public typealias Response = GameAddsListResponse
    
    private let _apiKey: String
    
    public init(apiKey: String) {
        _apiKey = apiKey
    }
    
    public func execute(request: String?) -> AnyPublisher<GameAddsListResponse, Error> {
        
        return Future<GameAddsListResponse, Error> { completion in
            
            guard let request = request else { return completion(.failure(URLError.invalidRequest) )}
            
            
            var component = URLComponents(string: "https://api.rawg.io/api/games/\(request)/additions")!

            component.queryItems = [
              URLQueryItem(name: "key", value: _apiKey),
              URLQueryItem(name: "page", value: "1"),
              URLQueryItem(name: "page_size", value: "10")
            ]
              
            let req = URLRequest(url: (component.url)!)
            
            AF.request(req.url!)
              .validate()
              .responseDecodable(of: GameAddsListResponse.self) { response in
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


