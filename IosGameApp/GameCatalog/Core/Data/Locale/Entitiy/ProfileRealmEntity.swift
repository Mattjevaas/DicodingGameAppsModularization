//
//  ProfileRealmEntity.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import RealmSwift

class ProfileRealmEntityOld: Object {
    @Persisted var userImage: Data
    @Persisted var userName: String
    @Persisted var userDesc: String
}
