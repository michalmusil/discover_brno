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
    private let credentialsValidator: CredentialsValidator
    private let defaults: DiscoverBrnoDefaults
    private var subscribtions = Set<AnyCancellable>()
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var credentialsValid: Bool = false
    
    init(realmManager: RealmManager, credentialsValidator: CredentialsValidator, defaults: DiscoverBrnoDefaults) {
        self.realmManager = realmManager
        self.credentialsValidator = credentialsValidator
        self.defaults = defaults
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
        self.state = .start
        
        try? self.saveCredentialsToDefaults(email: email, password: password)
    }
    
    private func saveCredentialsToDefaults(email: String, password: String) throws {
        try defaults.saveEmailAndPassword(email: email, password: password)
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
            .receive(on: DispatchQueue.main)
            .combineLatest($password){ [weak self] email, password in
                let emailValid = self?.credentialsValidator.validateEmailAddress(email: email)
                if let valid = emailValid,
                   valid == false {
                    self?.credentialsValid = false
                    return String(localized: "invalidEmail")
                }
                let passwordValid = self?.credentialsValidator.validatePassword(password: password)
                if let passValid = passwordValid,
                   passValid == false{
                    self?.credentialsValid = false
                    return String(localized: "passwordTooShort")
                }
                self?.credentialsValid = true
                return ""
            }
            .sink(receiveValue: { [weak self] value in
                self?.errorMessage = value
            })
            .store(in: &subscribtions)
    }
}
