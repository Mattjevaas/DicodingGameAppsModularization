//
//  ErrorProtocol.swift
//  Core
//
//  Created by admin on 26/09/23.
//

public protocol ErrorDelegate: AnyObject {
    func showError(msg: String)
}
