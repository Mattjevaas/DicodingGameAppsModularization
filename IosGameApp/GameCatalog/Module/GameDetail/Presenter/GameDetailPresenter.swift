//
//  GameDetailPresenter.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Kingfisher
import Combine

//protocol GameDetailDelegateOld: AnyObject {
//    
//    func loadDataFromResult(result: GameModel)
//    func changeButton(buttonName: String)
//    func showCustomAnimation()
//    func hideCustomAnimation()
//}
//
//class GameDetailPresenterOld: ObservableObject {
//    
//    private var cancellables: Set<AnyCancellable> = []
//    private let useCase: GameDetailUseCase
//    
//    weak var delegate: GameDetailDelegate?
//    weak var errordelegate: ErrorDelegate?
//    
//    var gameId: Int?
//    var navTitle: String?
//    var isFavorite: Bool = false
//    
//    init(useCase: GameDetailUseCase) {
//        self.useCase = useCase
//    }
//    
//    func loadData(id: Int) {
//        
//        self.delegate?.showCustomAnimation()
//
//        useCase.getGameDataDetail(idGame: id)
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure:
//                    self.errordelegate?.showError(msg: String(describing: completion))
//                case .finished:
//                    self.delegate?.hideCustomAnimation()
//                }
//            }, receiveValue: { result in
//                self.delegate?.loadDataFromResult(result: result)
//            }).store(in: &cancellables)
//    }
//    
//    func initFavoriteButton() {
//        
//        useCase.isDataExsit(gameId: gameId!)
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure:
//                    self.errordelegate?.showError(msg: String(describing: completion))
//                case .finished:
//                    break
//                }
//            }, receiveValue: { result in
//                var buttonName = ""
//                
//                if result {
//                    buttonName = "heart.fill"
//                    self.isFavorite = true
//                } else {
//                    buttonName = "heart"
//                }
//                
//                self.delegate?.changeButton(buttonName: buttonName)
//            }).store(in: &cancellables)
//    }
//    
//    func saveGameData(gameData: FavoriteGameModel) {
//        
//        useCase.saveGameData(data: gameData)
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure:
//                    self.errordelegate?.showError(msg: String(describing: completion))
//                case .finished:
//                    break
//                }
//            }, receiveValue: { result in
//                if result {
//                    self.isFavorite = !self.isFavorite
//                    
//                    self.delegate?.changeButton(buttonName: self.isFavorite ? "heart.fill" : "heart")
//                }
//            }).store(in: &cancellables)
//    }
//    
//    func deleteGameData() {
//        useCase.deleteGameData(gameId: gameId!)
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure:
//                    self.errordelegate?.showError(msg: String(describing: completion))
//                case .finished:
//                    break
//                }
//            }, receiveValue: { result in
//                if result {
//                    self.isFavorite = !self.isFavorite
//                    
//                    self.delegate?.changeButton(buttonName: self.isFavorite ? "heart.fill" : "heart")
//                }
//            }).store(in: &cancellables)
//    }
//    
//}
