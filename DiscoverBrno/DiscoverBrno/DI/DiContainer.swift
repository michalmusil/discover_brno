//
//  DiContainer.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 10.01.2023.
//

import Foundation

final class DiContainer{
    // Realm
    let realmManager: RealmManager
    
    // Stores
    let contentStore: ContentStore
    let loginStore: LoginStore
    
    init(){
        self.realmManager = RealmManager.shared
        
        self.contentStore = ContentStore(realmManager: self.realmManager)
        self.loginStore = LoginStore(realmManager: self.realmManager)
    }
}
