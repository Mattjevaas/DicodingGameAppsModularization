//
//  FavoriteGamePresenter.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Foundation
import Combine
import Core
import UIKit

public class FavoriteGamePresenter<GetGameFromLocaluseCase: UseCase>
where
GetGameFromLocaluseCase.Request == Any,
GetGameFromLocaluseCase.Response == [FavoriteGameModel]{
    
    private var cancellables: Set<AnyCancellable> = []
    private let useCase: GetGameFromLocaluseCase
    
    public var delegate: ErrorDelegate?
    
    public var favGames: [FavoriteGameModel] = []
    public var tableView = UITableView()
    
    public init(useCase: GetGameFromLocaluseCase) {
        self.useCase = useCase
    }
    
    public func loadData() {
        
        useCase.execute(request: nil)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.delegate?.showError(msg: String(describing: completion))
                case .finished:
                    self.tableView.reloadData()
                }
                
            }, receiveValue: { result in
                self.favGames = result
            }).store(in: &cancellables)
    }
}

