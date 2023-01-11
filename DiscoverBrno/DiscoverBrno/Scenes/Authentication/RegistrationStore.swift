//
//  RegistrationStore.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import Foundation
import Combine

final class RegistrationStore: ObservableObject{
    @Published var state: State = .start
    
    @Published var realmManager: RealmManager
    private let emailValidator: EmailValidator
    private var subscribtions = Set<AnyCancellable>()
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var credentialsValid: Bool = false
    
    init(realmManager: RealmManager, emailValidator: EmailValidator) {
        self.realmManager = realmManager
        self.emailValidator = emailValidator
        initializeSubs()
        
    }
    
    @MainActor
    func registerUser() async throws -> (email: String, password: String){
        self.state = .loading
        return try await realmManager.registerEmailPassword(email: email, password: password)
    }
    
    @MainActor
    func loginUser(email: String, password: String) async throws{
        self.state = .loading
        try await realmManager.loginEmailPassword(email: email, password: password)
        print("aaa")
    }
}

// MARK: State
extension RegistrationStore{
    enum State: Equatable{
        case start
        case idle
        case loading
    }
}



// MARK: Subs
extension RegistrationStore{
    func initializeSubs(){
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
