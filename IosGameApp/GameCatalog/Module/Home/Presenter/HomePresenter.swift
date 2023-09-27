//
//  HomePresenter.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation
import Combine

//protocol HomeViewDelegateOld: AnyObject {
//    func beginCustomInitRefresh(isHiddenNeeded: Bool)
//    func endCustomInitRefresh(isHiddenNeeded: Bool)
//    func beginCustomRefresh()
//    func endCustomRefresh()
//    func reloadCustomDataTable()
//}
//
//class HomeViewPresenter {
//    
//    private var cancellables: Set<AnyCancellable> = []
//    private let useCase: HomeUseCase
//    private let router = HomeRouter()
//    
//    weak var delegate: HomeViewDelegate?
//    weak var errordelegate: ErrorDelegate?
//    
//    var gameData: [GameModel] = []
//    var gameDataFilter: [GameModel] = []
//    
//    var filterOn = false
//    var dataSize = 10
//    
//    init(useCase: HomeUseCase) {
//        self.useCase = useCase
//    }
//    
//    func refreshData() {
//        
////      addDummy()
//        
//        self.delegate?.beginCustomInitRefresh(isHiddenNeeded: true)
//        self.dataSize = 10
//        
//        useCase.getGameData(pageSize: dataSize)
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure:
//                    self.errordelegate?.showError(msg: String(describing: completion))
//                case .finished:
//                    
//                    self.delegate?.endCustomInitRefresh(isHiddenNeeded: true)
//                    self.delegate?.endCustomRefresh()
//                    self.delegate?.reloadCustomDataTable()
//                }
//            }, receiveValue: { result in
//                self.gameData.removeAll()
//                self.gameData.append(contentsOf: result)
//            }).store(in: &cancellables)
//    }
//    
//    func loadMoreData() {
//        if gameData.count + 10 >= dataSize + 10 {
//            
////          addDummy()
//            dataSize += 10
//            loadData()
//        } else {
//            print("Reach End of line")
//        }
//    }
//    
//    func loadData() {
//        
//        self.delegate?.beginCustomInitRefresh(isHiddenNeeded: false)
//        
//        useCase.getGameData(pageSize: dataSize)
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure:
//                    self.errordelegate?.showError(msg: String(describing: completion))
//                    self.delegate?.endCustomInitRefresh(isHiddenNeeded: false)
//                case .finished:
//                    self.delegate?.reloadCustomDataTable()
//                    self.delegate?.endCustomInitRefresh(isHiddenNeeded: false)
//                }
//            }, receiveValue: { result in
//                self.gameData = result
//            }).store(in: &cancellables)
//    }
//    
//    func addDummy() {
//        for _ in 0..<10 {
//            gameData.append(
//                GameModel(
//                    gameId: 0,
//                    gameTitle: "Game Title",
//                    gameRating: 0.0,
//                    gameImage: "",
//                    gameReleasedDate: "",
//                    gameDesc: ""
//                )
//            )
//        }
//
//        self.delegate?.reloadCustomDataTable()
//    }
//    
//    func makeGameDetailView(gameId: Int, gameTitle: String) -> GameDetailView {
//        
//        let gameDetailView = router.makeGameDetailView()
//        gameDetailView.presenter.gameId = gameId
//        gameDetailView.presenter.navTitle = gameTitle
//        
//        return gameDetailView
//    }
//}
