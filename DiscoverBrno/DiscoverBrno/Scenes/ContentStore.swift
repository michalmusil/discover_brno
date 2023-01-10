//
//  ContentStore.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 06.01.2023.
//

import Foundation

class ContentStore: ObservableObject{
    enum State: Equatable{
        case login
        case registration
        case loggedIn
    }
    @Published var state: State = .login
    @Injected var realmManager: RealmManager
    
    init() {
        
    }
}


