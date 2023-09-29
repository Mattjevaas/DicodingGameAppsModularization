//
//  GamePresenter.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Foundation
import Combine
import Core
import GameDLC

public protocol GameDetailDelegate: AnyObject {
    
    func loadDataFromResult(result: GameModel)
    func loadDLCDataFromResult(result: [GameDLCModel])
    func changeButton(buttonName: String)
    func showCustomAnimation()
    func hideCustomAnimation()
}

public class GameDetailPresenter<
    GameDetailUseCase: UseCase,
    DataExistUseCase: UseCase,
    SaveGameUseCase: UseCase,
    DeleteGameUseCase: UseCase,
    GameDLCUseCase: UseCase
>
where
GameDetailUseCase.Request == GetGameDetailRequest,
GameDetailUseCase.Response == GameModel,
DataExistUseCase.Request == String,
DataExistUseCase.Response == Bool,
SaveGameUseCase.Request == GameRealmEntity,
SaveGameUseCase.Response == Bool,
DeleteGameUseCase.Request == String,
DeleteGameUseCase.Response == Bool,
GameDLCUseCase.Request == String,
GameDLCUseCase.Response == [GameDLCModel] {
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    private let gameDetailUseCase: GameDetailUseCase
    private let dataExistUseCase: DataExistUseCase
    private let saveGameUseCase: SaveGameUseCase
    private let deleteGameUseCase: DeleteGameUseCase
    private let gameDLCUseCase: GameDLCUseCase
    
    public weak var delegate: GameDetailDelegate?
    public weak var errordelegate: ErrorDelegate?
    
    public var gameId: Int?
    public var navTitle: String?
    public var isFavorite: Bool = false
    
    public init(
        gameDetailUseCase: GameDetailUseCase,
        dataExistUseCase: DataExistUseCase,
        saveGameUseCase: SaveGameUseCase,
        deleteGameUseCase: DeleteGameUseCase,
        gameDLCUseCase: GameDLCUseCase
    ) {
        self.gameDetailUseCase = gameDetailUseCase
        self.dataExistUseCase = dataExistUseCase
        self.saveGameUseCase = saveGameUseCase
        self.deleteGameUseCase = deleteGameUseCase
        self.gameDLCUseCase = gameDLCUseCase
    }
    
    public func loadData(id: Int) {
        
        self.delegate?.showCustomAnimation()
        
        let req = GetGameDetailRequest(gameId: id)

        gameDetailUseCase.execute(request: req)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errordelegate?.showError(msg: String(describing: completion))
                case .finished:
                    self.delegate?.hideCustomAnimation()
                }
            }, receiveValue: { result in
                self.delegate?.loadDataFromResult(result: result)
            }).store(in: &cancellables)
    }
    
    public func loadGameDLC(id: String) {
        gameDLCUseCase.execute(request: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errordelegate?.showError(msg: String(describing: completion))
                case .finished:
                    break
                }
            }, receiveValue: { result in
                self.delegate?.loadDLCDataFromResult(result: result)
            }).store(in: &cancellables)
    }
    
    public func initFavoriteButton() {
        
        dataExistUseCase.execute(request: String(gameId!))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errordelegate?.showError(msg: String(describing: completion))
                case .finished:
                    break
                }
            }, receiveValue: { result in
                var buttonName = ""
                
                if result {
                    buttonName = "heart.fill"
                    self.isFavorite = true
                } else {
                    buttonName = "heart"
                }
                
                self.delegate?.changeButton(buttonName: buttonName)
            }).store(in: &cancellables)
    }
    
    public func saveGameData(gameData: GameRealmEntity) {
        
        saveGameUseCase.execute(request: gameData)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errordelegate?.showError(msg: String(describing: completion))
                case .finished:
                    break
                }
            }, receiveValue: { result in
                if result {
                    self.isFavorite = !self.isFavorite
                    
                    self.delegate?.changeButton(buttonName: self.isFavorite ? "heart.fill" : "heart")
                }
            }).store(in: &cancellables)
    }
    
    public func deleteGameData() {
        
        deleteGameUseCase.execute(request: String(gameId!))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errordelegate?.showError(msg: String(describing: completion))
                case .finished:
                    break
                }
            }, receiveValue: { result in
                if result {
                    self.isFavorite = !self.isFavorite
                    
                    self.delegate?.changeButton(buttonName: self.isFavorite ? "heart.fill" : "heart")
                }
            }).store(in: &cancellables)
    }
}
