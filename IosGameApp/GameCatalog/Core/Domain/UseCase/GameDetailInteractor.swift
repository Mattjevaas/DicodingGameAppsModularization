//
//  GameDetailInteractor.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation
import Combine

//protocol GameDetailUseCase {
//    func getGameDataDetail(idGame: Int) -> AnyPublisher<GameModel, Error>
//    func saveGameData(data: FavoriteGameModel) -> AnyPublisher<Bool, Error>
//    func deleteGameData(gameId: Int) -> AnyPublisher<Bool, Error>
//    func isDataExsit(gameId: Int) -> AnyPublisher<Bool, Error>
//}
//
//class GameDetailInteractor: GameDetailUseCase {
//    
//    private let repository: GameRepositoryProtocol
//    
//    init(repository: GameRepositoryProtocol) {
//        self.repository = repository
//    }
//    
//    func getGameDataDetail(idGame: Int) -> AnyPublisher<GameModel, Error> {
//        return repository.getGameDataDetail(idGame: idGame)
//    }
//    
//    func saveGameData(data: FavoriteGameModel) -> AnyPublisher<Bool, Error> {
//        return repository.saveGameData(data: data)
//    }
//    
//    func deleteGameData(gameId: Int) -> AnyPublisher<Bool, Error> {
//        return repository.deleteGameData(gameId: gameId)
//    }
//    
//    func isDataExsit(gameId: Int) -> AnyPublisher<Bool, Error> {
//        return repository.isDataExist(gameId: gameId)
//    }
//    
//}
