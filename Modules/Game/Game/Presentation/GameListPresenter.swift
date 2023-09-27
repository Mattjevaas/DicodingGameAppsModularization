//
//  GamePresenter.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Foundation
import Combine
import Core

public protocol HomeViewDelegate: AnyObject {
    func beginCustomInitRefresh(isHiddenNeeded: Bool)
    func endCustomInitRefresh(isHiddenNeeded: Bool)
    func beginCustomRefresh()
    func endCustomRefresh()
    func reloadCustomDataTable()
}

public class GameListPresenter<GameListUseCase: UseCase>
where 
GameListUseCase.Request == GetGameRequest,
GameListUseCase.Response == [GameModel] {
    
    private var cancellables: Set<AnyCancellable> = []
    private let useCase: GameListUseCase
    
    public weak var delegate: HomeViewDelegate?
    public weak var errordelegate: ErrorDelegate?
    
    public var gameData: [GameModel] = []
    public var gameDataFilter: [GameModel] = []
    
    public var filterOn = false
    public var dataSize = 10
    
    public init(useCase: GameListUseCase) {
        self.useCase = useCase
    }
    
    public func refreshData() {
        
//      addDummy()
        
        self.delegate?.beginCustomInitRefresh(isHiddenNeeded: true)
        
        self.dataSize = 10
        let req = GetGameRequest(pageSize: dataSize)
        
        useCase.execute(request: req)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errordelegate?.showError(msg: String(describing: completion))
                case .finished:
                    
                    self.delegate?.endCustomInitRefresh(isHiddenNeeded: true)
                    self.delegate?.endCustomRefresh()
                    self.delegate?.reloadCustomDataTable()
                }
            }, receiveValue: { result in
                self.gameData.removeAll()
                self.gameData.append(contentsOf: result)
            }).store(in: &cancellables)
    }
    
    public func loadMoreData() {
        if gameData.count + 10 >= dataSize + 10 {
            
//          addDummy()
            dataSize += 10
            loadData()
        } else {
            print("Reach End of line")
        }
    }
    
    public func loadData() {
        
        self.delegate?.beginCustomInitRefresh(isHiddenNeeded: false)
        
        let req = GetGameRequest(pageSize: dataSize)
        
        useCase.execute(request: req)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errordelegate?.showError(msg: String(describing: completion))
                    self.delegate?.endCustomInitRefresh(isHiddenNeeded: false)
                case .finished:
                    self.delegate?.reloadCustomDataTable()
                    self.delegate?.endCustomInitRefresh(isHiddenNeeded: false)
                }
            }, receiveValue: { result in
                self.gameData = result
            }).store(in: &cancellables)
    }
    
    public func addDummy() {
        for _ in 0..<10 {
            gameData.append(
                GameModel(
                    gameId: 0,
                    gameTitle: "Game Title",
                    gameRating: 0.0,
                    gameImage: "",
                    gameReleasedDate: "",
                    gameDesc: ""
                )
            )
        }

        self.delegate?.reloadCustomDataTable()
    }
}

