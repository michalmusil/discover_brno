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
    private let credentialsValidator: CredentialsValidator
    private let defaults: DiscoverBrnoDefaults
    private var subscribtions = Set<AnyCancellable>()
    
    
    init(realmManager: RealmManager, credentialsValidator: CredentialsValidator, defaults: DiscoverBrnoDefaults){
        self.realmManager = realmManager
        self.credentialsValidator = credentialsValidator
        self.defaults = defaults
        initializeSubs()
    }
    
    
    @MainActor
    func loginUser(email: String, password: String) async throws{
        self.state = .loading
        try await realmManager.loginEmailPassword(email: email, password: password)
        self.state = .start
        
        try? saveCredentialsToDefaults(email: email, password: password)
    }
    
    func tryToLogInFromMemory(){
        guard let credentials = defaults.getSavedEmailAndPassword() else {
            return
        }
        Task{
            try? await loginUser(email: credentials.email, password: credentials.password)
        }
    }
    
    private func saveCredentialsToDefaults(email: String, password: String) throws {
        try defaults.saveEmailAndPassword(email: email, password: password)
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
