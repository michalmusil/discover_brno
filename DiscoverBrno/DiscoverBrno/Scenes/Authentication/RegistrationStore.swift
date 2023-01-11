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
    
    init(realmManager: RealmManager, emailValidator: EmailValidator) {
        self.realmManager = realmManager
        self.emailValidator = emailValidator
        
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
                    return "Not a valid email address."
                }
                if password.count < 6{
                    return "Password must be at least 6 characters"
                }
                return ""
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.errorMessage = value
            })
            .store(in: &subscribtions)
    }
}
