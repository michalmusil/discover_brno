//
//  LoginStore.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 06.01.2023.
//

import Foundation

final class LoginStore: ObservableObject{
    enum State: Equatable{
        case start
        case idle
        case loading
    }
    @Published var state: State = .start
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var errorText: String = ""
    
    @Injected var realmManager: RealmManager
    
    func loginUser(){
        state = .loading
        Task{
            do{
                try await realmManager.loginEmailPassword(email: email, password: password)
            } catch {
                errorText = "Could not log in"
                state = .idle
            }
        }
    }
}
