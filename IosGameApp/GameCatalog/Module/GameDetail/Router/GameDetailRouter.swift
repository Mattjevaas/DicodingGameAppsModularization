//
//  GameDetailRouter.swift
//  GameCatalog
//
//  Created by admin on 02/10/23.
//

import Foundation
import Core
import GameMod
import GameDLC

class GameDetailRouter {
    
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
        
        let gameDLCUseCase: Interactor<
            String,
            [GameDLCModel],
            GetAddsRepository<GetAddsRemoteDataSource>> = r.provideGetGameDLC()
        
        let gameDetailPresenter = GameDetailPresenter(
            gameDetailUseCase: gameDetailUseCase,
            dataExistUseCase: dataExistUseCase,
            saveGameUseCase: saveGameUseCase,
            deleteGameUseCase: deleteGameUseCase,
            gameDLCUseCase: gameDLCUseCase
        )

        
        return GameDetailView(presenter: gameDetailPresenter)
    }
}

