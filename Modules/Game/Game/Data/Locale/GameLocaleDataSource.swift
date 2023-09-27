//
//  GameLocalDataSource.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Core
import RealmSwift
import Foundation
import Combine

public final class GameLocaleDataSource: LocaleDataSource {
    
    public typealias Request = GameRealmEntity
    public typealias Response = [FavoriteGameModel]
    
    private var realm: Realm?
    
    public init(realm: Realm?) {
        self.realm = realm
    }
    
    public func saveData(object: GameRealmEntity) -> AnyPublisher<Bool, Error> {
        
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(object)
                        
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    public func deleteData(type: Object.Type, predicate: NSPredicate) -> AnyPublisher<Bool, Error> {
        
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    
                    let data = realm.objects(type).filter(predicate).first
                    
                    try realm.write {
                        realm.delete(data!)
                        
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    public func fetchData(type: GameRealmEntity.Type) -> AnyPublisher<[FavoriteGameModel], Error> {
        
        return Future<[FavoriteGameModel], Error> { completion in
            if let realm = self.realm {
                
                let data = realm.objects(type)
                let arr = data.map { data in
                    return FavoriteGameModel(
                        gameId: data.gameId,
                        gameTitle: data.gameTitle,
                        gameRating: data.gameRating,
                        gameImage: data.gameImage,
                        gameReleasedDate: data.gameReleasedDate,
                        gameDesc: data.gameDesc
                    )
                }
        
                completion(.success(Array(arr)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    public func isDataExist(type: Object.Type, predicate: NSPredicate) -> AnyPublisher<Bool, Error> {
        
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                
                let data = realm.objects(type).filter(predicate).first
                
                if data != nil {
                    completion(.success(true))
                }
                
                completion(.success(false))
                
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
}
