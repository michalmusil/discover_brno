//
//  RealmManager.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 06.01.2023.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject{
    static let shared = RealmManager()

    let app: App
    @Published var realm: Realm?
    
    @Published var user: User?
    @Published var configuration: Realm.Configuration?
    
    private init(){
        self.app = App(id: "discoverbrno-zrxgr")
    }
    
    @MainActor
    func loginEmailPassword(email: String, password: String) async throws{
        let credentials = Credentials.emailPassword(email: email, password: password)
        
        self.user = try await app.login(credentials: credentials)
        
        let userId = self.user?.id
        
        /*
        self.configuration = user?.flexibleSyncConfiguration(initialSubscriptions: {subs in
            if subs.first(named: "all_todos") != nil{
                return
            } else {
                subs.append(QuerySubscription<Todo>(name: "all_todos") {
                    $0.ownerId == userId!
                })
            }
        }, rerunOnOpen: true)
        
        self.realm = try await Realm(configuration: self.configuration!, downloadBeforeOpen: .always)
         */
    }
    
    @MainActor
    func registerEmailPassword(email: String, password: String) async throws{
        let credentials = Credentials.emailPassword(email: email, password: password)
        
        try await app.emailPasswordAuth.registerUser(email: email, password: password)
    }
    
    @MainActor
    func logOut() async throws {
        try await self.user?.logOut()
        self.user = nil
        self.configuration = nil
        self.realm = nil
    }
}
