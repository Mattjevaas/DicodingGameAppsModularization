//
//  UseCase.swift
//  Core
//
//  Created by admin on 26/09/23.
//

import Foundation
import Combine

public protocol UseCase {
    associatedtype Request
    associatedtype Response
    
    func execute(request: Request?) -> AnyPublisher<Response, Error>
}
