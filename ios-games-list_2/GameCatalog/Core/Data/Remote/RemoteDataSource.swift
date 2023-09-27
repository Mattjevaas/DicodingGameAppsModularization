//
//  RemoteDataSource.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import UIKit
import Alamofire
import Combine

protocol RemoteDataSourceProtocol: AnyObject {
    func getGameData(pageSize: Int) -> AnyPublisher<GameResponse, Error>
    func getGameDataDetail(idGame: Int) -> AnyPublisher<GameDetailResponse, Error>
}

final class RemoteDataSource: RemoteDataSourceProtocol {

    private var apiKey: String {
        get {
          
            guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
              return ""
            }

            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                return ""
            }
              
            return value
        }
    }
    
    private let session = URLSession(configuration: .default)
    
    func getGameData(pageSize: Int) -> AnyPublisher<GameResponse, Error> {
        
        return Future<GameResponse, Error> { completion in
            var component = URLComponents(string: "https://api.rawg.io/api/games")!
            
            component.queryItems = [
                URLQueryItem(name: "key", value: self.apiKey),
                URLQueryItem(name: "page_size", value: String(pageSize))
            
            ]
            
            let request = URLRequest(url: (component.url)!)
            
            AF.request(request.url!).validate().responseDecodable(of: GameResponse.self) { response in
                
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure:
                    completion(.failure(URLError.invalidResponse))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getGameDataDetail(idGame: Int) -> AnyPublisher<GameDetailResponse, Error> {
        
        return Future<GameDetailResponse, Error> { completion in
            var component = URLComponents(string: "https://api.rawg.io/api/games/\(idGame)")!
            
            component.queryItems = [
                URLQueryItem(name: "key", value: self.apiKey)
            ]
            
            let request = URLRequest(url: (component.url)!)
            
            AF.request(request.url!).validate().responseDecodable(of: GameDetailResponse.self) { response in
                
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
