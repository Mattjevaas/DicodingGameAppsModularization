//
//  LocaleDataSource.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import RealmSwift
import Combine

protocol LocaleDataSourceProtocol: AnyObject {
    func saveData(object: Object) -> AnyPublisher<Bool, Error>
    func deleteData(type: Object.Type, predicate: NSPredicate) -> AnyPublisher<Bool, Error>
    func fetchData<T>(type: T.Type) -> AnyPublisher<[T], Error> where T: Object
    func isDataExist(type: Object.Type, predicate: NSPredicate) -> AnyPublisher<Bool, Error>
}

final class LocaleDataSource: LocaleDataSourceProtocol {
    
    private var realm: Realm?
    
    init(realm: Realm?) {
        self.realm = realm
    }
    
    func saveData(object: Object) -> AnyPublisher<Bool, Error> {
        
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
    
    func deleteData(type: Object.Type, predicate: NSPredicate) -> AnyPublisher<Bool, Error> {
        
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
    
    func fetchData<T>(type: T.Type) -> AnyPublisher<[T], Error> where T: Object {
        
        return Future<[T], Error> { completion in
            if let realm = self.realm {
                
                let data = realm.objects(type)
        
                completion(.success(Array(data)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    func isDataExist(type: Object.Type, predicate: NSPredicate) -> AnyPublisher<Bool, Error> {
        
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
