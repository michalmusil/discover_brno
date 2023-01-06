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
    
    @Published var errorText: String = ""
    
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
                    self?.errorText = wrongEmail
                }
                if let result = value,
                   !result{
                    self?.errorText = wrongEmail
                }
            })
            .store(in: &subscribtions)
        
        $password
            .map{ passwordString in
                return passwordString.count >= 6
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                if !value{
                    self?.errorText = "Password must be at least 6 characters"
                }
            })
            .store(in: &subscribtions)
    }
    
    func validateEmailAddress(email: String) -> Bool {
        let regex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    func loginUser() async throws{
        state = .loading
        try await realmManager.loginEmailPassword(email: email, password: password)
    }
}
