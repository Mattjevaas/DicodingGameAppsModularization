//
//  FavoritePresenter.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import UIKit
import Combine

//class FavoritePresenter {
//    
//    private var cancellables: Set<AnyCancellable> = []
//    private let useCase: FavoriteUseCase
//    
//    private let router = FavoriteRouter()
//    
//    var delegate: ErrorDelegate?
//    
//    var favGames: [FavoriteGameModel] = []
//    var tableView = UITableView()
//    
//    init(useCase: FavoriteUseCase) {
//        self.useCase = useCase
//    }
//    
//    func loadData() {
//        
//        useCase.fetchData()
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure:
//                    self.delegate?.showError(msg: String(describing: completion))
//                case .finished:
//                    self.tableView.reloadData()
//                }
//                
//            }, receiveValue: { result in
//                self.favGames = result
//            }).store(in: &cancellables)
//    }
//    
//    func goToGameDetail(gameId: Int, gameTitle: String) -> GameDetailView {
//        let gameDetailView = router.makeGameDetailView()
//        gameDetailView.presenter.gameId = gameId
//        gameDetailView.presenter.navTitle = gameTitle
//        
//        return gameDetailView
//    }
//}
