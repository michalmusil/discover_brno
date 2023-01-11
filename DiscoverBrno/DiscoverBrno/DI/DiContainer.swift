//
//  DiContainer.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 10.01.2023.
//

import Foundation

final class DiContainer{
    // Realm
    let realmManager: RealmManager
    
    // Utils
    let emailValidator: EmailValidator
    
    // Stores
    let contentStore: ContentStore
    let loginStore: LoginStore
    let registrationStore: RegistrationStore
    
    init(){
        self.realmManager = RealmManager.shared
        
        self.emailValidator = EmailValidator()
        
        self.contentStore = ContentStore(realmManager: realmManager)
        self.loginStore = LoginStore(realmManager: realmManager, emailValidator: emailValidator)
        self.registrationStore = RegistrationStore(realmManager: realmManager, emailValidator: emailValidator)
    }
}
