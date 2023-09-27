//
//  Injection.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import RealmSwift
import Swinject
import Core
import GameMod

final class Injection: NSObject {
    private let container = Container()
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
    
    private override init() {}
    
    static let sharedInstance: Injection = Injection()
    
//    func registerAll() {
//        container.register(RemoteDataSourceProtocol.self) { _ in
//            RemoteDataSource()
//        }.inObjectScope(.container)
//        
//        container.register(LocaleDataSourceProtocol.self) { _ in
//            let realm = try? Realm()
//            return LocaleDataSource(realm: realm)
//        }.inObjectScope(.container)
//        
//        container.register(GameRepositoryProtocol.self) { r in
//            GameRepository(locale: r.resolve(LocaleDataSourceProtocol.self)!, remote: r.resolve(RemoteDataSourceProtocol.self)!)
//        }.inObjectScope(.container)
//        
//        container.register(HomeUseCase.self) { r in
//            HomeInteractor(repository: r.resolve(GameRepositoryProtocol.self)!)
//        }
//        
//        container.register(GameDetailUseCase.self) { r in
//            GameDetailInteractor(repository: r.resolve(GameRepositoryProtocol.self)!)
//        }
//        
//        container.register(FavoriteUseCase.self) { r in
//            FavoriteInteractor(repository: r.resolve(GameRepositoryProtocol.self)!)
//        }
//    }
//    
//    func provideFavoriteUC() -> FavoriteUseCase {
//        let favUC = container.resolve(FavoriteUseCase.self)
//        return favUC!
//    }
//    
//    func provideHomeUC() -> HomeUseCase {
//        let homeUC = container.resolve(HomeUseCase.self)
//        return homeUC!
//    }
//    
//    func provideGameDetailUC() -> GameDetailUseCase {
//        let gameDetailUC = container.resolve(GameDetailUseCase.self)
//        return gameDetailUC!
//    }
    
    func provideGameList<U: UseCase>() -> U 
    where U.Request == GetGameRequest, U.Response == [GameModel] {
        
        container.register(GetGameRemoteDataSource.self) { _ in
            GetGameRemoteDataSource(apiKey: self.apiKey)
        }.inObjectScope(.container)
        
        container.register(GetGameRepository<GetGameRemoteDataSource>.self) { r in
            GetGameRepository(remoteDataSource: r.resolve(GetGameRemoteDataSource.self)!)
        }.inObjectScope(.container)
        
        return Interactor(repository: container.resolve(GetGameRepository<GetGameRemoteDataSource>.self)!) as! U
    }
    
    func provideGameDetail<U: UseCase>() -> U
    where U.Request == GetGameDetailRequest, U.Response == GameModel {
        
        container.register(GetGameDetailRemoteDataSource.self) { _ in
            GetGameDetailRemoteDataSource(apiKey: self.apiKey)
        }.inObjectScope(.container)
        
        container.register(GetGameDetailRepository<GetGameDetailRemoteDataSource>.self) { r in
            GetGameDetailRepository(remoteDataSource: r.resolve(GetGameDetailRemoteDataSource.self)!)
        }.inObjectScope(.container)
        
        return Interactor(repository: container.resolve(GetGameDetailRepository<GetGameDetailRemoteDataSource>.self)!) as! U
    }
    
    func provideSaveGame<U: UseCase>() -> U
    where U.Request == GameRealmEntity, U.Response == Bool {
        
        container.register(GameLocaleDataSource.self) { _ in
            let realm = try? Realm()
            return GameLocaleDataSource(realm: realm)
            
        }.inObjectScope(.container)
        
        container.register(SaveGameDataRepository<GameLocaleDataSource>.self) { r in
            SaveGameDataRepository(localDataSource: r.resolve(GameLocaleDataSource.self)!)
        }.inObjectScope(.container)
        
        return Interactor(repository: container.resolve(SaveGameDataRepository<GameLocaleDataSource>.self)!) as! U
    }
    
    func provideDeleteGame<U: UseCase>() -> U
    where U.Request == String, U.Response == Bool {
        
        container.register(GameLocaleDataSource.self) { _ in
            let realm = try? Realm()
            return GameLocaleDataSource(realm: realm)
            
        }.inObjectScope(.container)
        
        container.register(DeleteGameDataRepository<GameLocaleDataSource>.self) { r in
            DeleteGameDataRepository(localDataSource: r.resolve(GameLocaleDataSource.self)!)
        }.inObjectScope(.container)
        
        return Interactor(repository: container.resolve(DeleteGameDataRepository<GameLocaleDataSource>.self)!) as! U
    }
    
    func provideExistRepository<U: UseCase>() -> U
    where U.Request == String, U.Response == Bool {
        
        container.register(GameLocaleDataSource.self) { _ in
            let realm = try? Realm()
            return GameLocaleDataSource(realm: realm)
            
        }.inObjectScope(.container)
        
        container.register(DataExistRepository<GameLocaleDataSource>.self) { r in
            DataExistRepository(localDataSource: r.resolve(GameLocaleDataSource.self)!)
        }.inObjectScope(.container)
        
        return Interactor(repository: container.resolve(DataExistRepository<GameLocaleDataSource>.self)!) as! U
    }
    
    func provideGetGameFromLocal<U: UseCase>() -> U
    where U.Request == Any, U.Response == [FavoriteGameModel] {
        
        container.register(GameLocaleDataSource.self) { _ in
            let realm = try? Realm()
            return GameLocaleDataSource(realm: realm)
            
        }.inObjectScope(.container)
        
        container.register(GetGameDataFromLocalRepository<GameLocaleDataSource>.self) { r in
            GetGameDataFromLocalRepository(localDataSource: r.resolve(GameLocaleDataSource.self)!)
        }.inObjectScope(.container)
        
        return Interactor(repository: container.resolve(GetGameDataFromLocalRepository<GameLocaleDataSource>.self)!) as! U
    }
}
