//
//  LocaleDataSource.swift
//  Core
//
//  Created by admin on 26/09/23.
//

import Foundation
import Combine
import RealmSwift

public protocol LocaleDataSource {
    associatedtype Request
    associatedtype Response
    
    func saveData(object: Request) -> AnyPublisher<Bool, Error>
    func deleteData(type: Object.Type, predicate: NSPredicate) -> AnyPublisher<Bool, Error>
    func fetchData(type: Request.Type) -> AnyPublisher<Response, Error>
    func isDataExist(type: Object.Type, predicate: NSPredicate) -> AnyPublisher<Bool, Error>
}

