//
//  GetListPresenter.swift
//  Core
//
//  Created by admin on 26/09/23.
//

import Foundation
import Combine

protocol GetListPresenterDelegate: AnyObject {
    
    func showAnimationLoading()
    func hideAnimationLoading()
    func showErrorMessage(msg: String)
    func loadData<Response>(list: Response)
}

public class GetListPresenter<Request, Response, Interactor: UseCase> where Interactor.Request == Request, Interactor.Response == [Response] {
    
    private var cancellables: Set<AnyCancellable> = []
    private let _useCase: Interactor

    weak var delegate: (any GetListPresenterDelegate)?
    
    public init(useCase: Interactor) {
        _useCase = useCase
    }
    
    public func getList(request: Request?) {
        self.delegate?.showAnimationLoading()
        
        _useCase.execute(request: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.delegate?.showErrorMessage(msg: error.localizedDescription)
                    self.delegate?.hideAnimationLoading()
                case .finished:
                    self.delegate?.hideAnimationLoading()
                }
            }, receiveValue: { list in
                self.delegate?.loadData(list: list)
            }).store(in: &cancellables)
    }
}
