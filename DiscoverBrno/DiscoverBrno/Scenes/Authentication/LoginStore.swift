//
//  LoginStore.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 06.01.2023.
//

import Foundation
import Combine

final class LoginStore: ObservableObject{
    @Published var state: State = .start
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var credentialsValid: Bool = false
    
    @Published var realmManager: RealmManager
    private let emailValidator: EmailValidator
    private var subscribtions = Set<AnyCancellable>()
    
    
    init(realmManager: RealmManager, emailValidator: EmailValidator){
        self.realmManager = realmManager
        self.emailValidator = emailValidator
        initializeSubs()
    }
    
    
    @MainActor
    func loginUser() async throws{
        self.state = .loading
        try await realmManager.loginEmailPassword(email: email, password: password)
    }
}

// MARK: State
extension LoginStore{
    enum State: Equatable{
        case start
        case idle
        case loading
    }
}

// MARK: Subs
extension LoginStore{
    private func initializeSubs(){
        $email
            .combineLatest($password){ [weak self] email, password in
                let emailValid = self?.emailValidator.validateEmailAddress(email: email)
                if let valid = emailValid,
                   valid == false {
                    self?.credentialsValid = false
                    return "Not a valid email address."
                }
                if password.count < 6{
                    self?.credentialsValid = false
                    return "Password must be at least 6 characters"
                }
                self?.credentialsValid = true
                return ""
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.errorMessage = value
            })
            .store(in: &subscribtions)
    }
}
