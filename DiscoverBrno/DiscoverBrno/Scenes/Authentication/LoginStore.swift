//
//  LoginStore.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 06.01.2023.
//

import Foundation
import Combine

final class LoginStore: ObservableObject{
    enum State: Equatable{
        case start
        case idle
        case loading
    }
    @Published var state: State = .start
    private var subscribtions = Set<AnyCancellable>()
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var emailError: String = ""
    @Published var passwordError: String = ""
    
    @Injected var realmManager: RealmManager
    
    init(){
        initializeSubs()
    }
    
    func initializeSubs(){
        $email
            .map{ [weak self] emailString in
                return self?.validateEmailAddress(email: emailString)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                let wrongEmail = "Not a valid email address."
                if value == nil{
                    self?.emailError = wrongEmail
                    return
                }
                if let result = value,
                   !result{
                    self?.emailError = wrongEmail
                    return
                }
                self?.emailError = ""
            })
            .store(in: &subscribtions)
        
        $password
            .map{ passwordString in
                return passwordString.count >= 6
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                if !value{
                    self?.passwordError = "Password must be at least 6 characters"
                    return
                }
                self?.passwordError = ""
            })
            .store(in: &subscribtions)
    }
    
    private func validateEmailAddress(email: String) -> Bool {
        let regex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    @MainActor
    func loginUser() async throws{
        self.state = .loading
        try await realmManager.loginEmailPassword(email: email, password: password)
        print("aaa")
    }
}
