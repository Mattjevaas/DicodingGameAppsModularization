//
//  GameCatalogTests.swift
//  GameCatalogTests
//
//  Created by admin on 07/11/22.
//

import XCTest
import Combine

@testable import GameCatalog
final class GameCatalogTests: XCTestCase {

    let injection = Injection.sharedInstance
    
    func testInjection() {
        injection.registerAll()
        XCTAssert(true)
    }
    
    func testProvideHomeUseCase() {
        let homeUC = injection.provideHomeUC()
        let state = homeUC is HomeUseCase
        
        XCTAssertEqual(true, state, "Failed to provide Home UseCase")
    }
    
    func testProvideGameDetailUseCase() {
        let gameDetailUC = injection.provideGameDetailUC()
        let state = gameDetailUC is GameDetailUseCase
        
        XCTAssertEqual(true, state, "Failed to provide GameDetail UseCase")
    }
    
    func testProvideFavoriteDetailUseCase() {
        let favUC = injection.provideFavoriteUC()
        let state = favUC is FavoriteUseCase
        
        XCTAssertEqual(true, state, "Failed to provide Favorite UseCase")
    }
    
    func testHomeUseCase() {
        
        var cancellables: Set<AnyCancellable> = []
        
        var data: [GameModel] = []
        let homeUC = injection.provideHomeUC()
        
        homeUC.getGameData(pageSize: 10)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTAssertThrowsError(completion)
                case .finished:
                    XCTAssertEqual(data.count, 10, "Failed to get game data")
                }
            }, receiveValue: { result in
                data.append(contentsOf: result)
            }).store(in: &cancellables)
    }
    
    func testGameDetailUseCase() {
        var cancellables: Set<AnyCancellable> = []
        
        var data: GameModel?
        let gameUC = injection.provideGameDetailUC()
        
        gameUC.getGameDataDetail(idGame: 3498)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTAssertThrowsError(completion)
                case .finished:
                    XCTAssertEqual(data?.gameId, 3498, "Failed to get game detail data")
                }
            }, receiveValue: { result in
                data = result
            }).store(in: &cancellables)
        
        let gameData: FavoriteGameModel = FavoriteGameModel(gameId: 3498, gameTitle: "test", gameRating: "test", gameImage: Data(), gameReleasedDate: "test", gameDesc: "test")
        
        gameUC.saveGameData(data: gameData)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTAssertThrowsError(completion)
                case .finished:
                    break
                }
            }, receiveValue: { result in
                XCTAssertEqual(result, true, "Failed to save game detail data")
            }).store(in: &cancellables)
        
        gameUC.isDataExsit(gameId: 3498)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTAssertThrowsError(completion)
                case .finished:
                    break
                }
            }, receiveValue: { result in
                XCTAssertEqual(result, true, "Failed to get game detail data")
            }).store(in: &cancellables)
        
        gameUC.getGameDataDetail(idGame: 3498)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTAssertThrowsError(completion)
                case .finished:
                    break
                }
            }, receiveValue: { result in
                XCTAssertEqual(result.gameId, 3498, "Failed to get game detail data")
            }).store(in: &cancellables)
        
        gameUC.deleteGameData(gameId: 3498)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTAssertThrowsError(completion)
                case .finished:
                    break
                }
            }, receiveValue: { result in
                XCTAssertEqual(result, true, "Failed to delete game detail data")
            }).store(in: &cancellables)
        
        gameUC.isDataExsit(gameId: 3498)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTAssertThrowsError(completion)
                case .finished:
                    break
                }
            }, receiveValue: { result in
                XCTAssertEqual(result, false, "Failed to get game detail data")
            }).store(in: &cancellables)
    }
}
