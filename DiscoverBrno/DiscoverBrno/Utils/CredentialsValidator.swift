//
//  CredentialsValidator.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import Foundation

class CredentialsValidator{
    
    func validateEmailAddress(email: String) -> Bool {
        let regex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    func validatePassword(password: String) -> Bool {
        return password.count>=6
    }
    
}
