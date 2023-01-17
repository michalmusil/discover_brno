//
//  ContentStore.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 06.01.2023.
//

import Foundation
import SwiftUI
import Combine

class ContentStore: ObservableObject{
    @Published var state: State = .login
    @Published var realmManager: RealmManager
    @Published var userLoggedIn: Bool = false
    
    private var subscribtions = Set<AnyCancellable>()
    
    init(realmManager: RealmManager) {
        self.realmManager = realmManager
        initializeSubs()
    }
}

// MARK: State
extension ContentStore{
    enum State: Equatable{
        case login
        case registration
    }
}

// MARK: Combine
extension ContentStore{
    private func initializeSubs(){
        realmManager.$userLoggedIn
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] receivedValue in
                self?.userLoggedIn = receivedValue
            }
            .store(in: &subscribtions)
    }
}


