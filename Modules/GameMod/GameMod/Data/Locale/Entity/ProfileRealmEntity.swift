//
//  ProfileRealmEntity.swift
//  Game
//
//  Created by admin on 26/09/23.
//

import Foundation
import RealmSwift

class ProfileRealmEntity: Object {
    @Persisted var userImage: Data
    @Persisted var userName: String
    @Persisted var userDesc: String
}
