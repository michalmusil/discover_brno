//
//  DiscoverBrnoDefaults.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 19.01.2023.
//

import Foundation


final class DiscoverBrnoDefaults {
    private let userDefaults = UserDefaults.standard
    
    private let credentialsValidator: CredentialsValidator
    
    init(credentialsValidator: CredentialsValidator){
        self.credentialsValidator = credentialsValidator
    }
    
    
    func saveEmailAndPassword(email: String, password: String) throws{
        guard credentialsValidator.validateEmailAddress(email: email) else {
            throw DefaultsError.invalidEmail
        }
        guard credentialsValidator.validatePassword(password: password) else {
            throw DefaultsError.invalidPassword
        }
        userDefaults.set(email, forKey: StoredValues.email.rawValue)
        userDefaults.set(password, forKey: StoredValues.password.rawValue)
    }
    
    func getSavedEmailAndPassword() -> (email: String, password: String)?{
        guard let storedEmail = userDefaults.string(forKey: StoredValues.email.rawValue) else {
            return nil
        }
        guard let storedPassword = userDefaults.string(forKey: StoredValues.password.rawValue) else {
            return nil
        }
        return (storedEmail, storedPassword)
    }
    
    func clearEmailAndPassword(){
        userDefaults.removeObject(forKey: StoredValues.email.rawValue)
        userDefaults.removeObject(forKey: StoredValues.password.rawValue)
    }
}



// MARK: Types of stored values
extension DiscoverBrnoDefaults{
    enum StoredValues: String{
        case email = "email"
        case password = "password"
    }
}

// MARK: Possible errors
extension DiscoverBrnoDefaults{
    enum DefaultsError: Error {
        case invalidEmail
        case invalidPassword
    }
}
