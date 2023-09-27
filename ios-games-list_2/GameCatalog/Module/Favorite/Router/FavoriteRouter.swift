//
//  FavoriteRouter.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation
import Core
import GameMod

class FavoriteRouter {
    
    func makeGameDetailView() -> GameDetailView {
        let r = Injection.sharedInstance
        
        let gameDetailUseCase: Interactor<
            GetGameDetailRequest,
            GameModel,
            GetGameDetailRepository<GetGameDetailRemoteDataSource>> = r.provideGameDetail()
        
        let dataExistUseCase: Interactor<
            String,
            Bool,
            DataExistRepository<GameLocaleDataSource>> = r.provideExistRepository()
        
        let saveGameUseCase: Interactor<
            GameRealmEntity,
            Bool,
            SaveGameDataRepository<GameLocaleDataSource>> = r.provideSaveGame()
        
        let deleteGameUseCase: Interactor<
            String,
            Bool,
            DeleteGameDataRepository<GameLocaleDataSource>> = r.provideDeleteGame()
        
        let gameDetailPresenter = GameDetailPresenter(
            gameDetailUseCase: gameDetailUseCase,
            dataExistUseCase: dataExistUseCase,
            saveGameUseCase: saveGameUseCase,
            deleteGameUseCase: deleteGameUseCase
        )
        
        return GameDetailView(presenter: gameDetailPresenter)
    }
}
