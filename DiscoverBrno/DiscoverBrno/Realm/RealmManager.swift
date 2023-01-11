//
//  RealmManager.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 06.01.2023.
//

import Foundation
import RealmSwift
import Combine

class RealmManager: ObservableObject{
    static let shared = RealmManager()

    let app: App
    @Published var realm: Realm?
    @Published var user: User?
    @Published var configuration: Realm.Configuration?
    
    
    private var subscribtions = Set<AnyCancellable>()
    @Published var userLoggedIn: Bool = false
    
    
    private init(){
        self.app = App(id: "discoverbrno-zrxgr")
        initializeSubs()
    }
    
    
    
    
}

// MARK: Methods
extension RealmManager{
    @MainActor
    func loginEmailPassword(email: String, password: String) async throws{
        do{
            let credentials = Credentials.emailPassword(email: email, password: password)
            
            self.user = try await app.login(credentials: credentials)
            
            let userId = self.user?.id
            
            self.configuration = user?.flexibleSyncConfiguration(initialSubscriptions: {subs in
                if subs.first(named: "discoverable_landmarks") == nil{
                    subs.append(QuerySubscription<DiscoverableLandmark>(name: "discoverable_landmarks"))
                }
                if subs.first(named: "discovered_landmarks") == nil{
                    subs.append(QuerySubscription<DiscoveredLandmark>(name: "discovered_landmarks"){
                        $0.ownerId == userId!
                    })
                }
            }, rerunOnOpen: true)
            
            self.realm = try await Realm(configuration: self.configuration!, downloadBeforeOpen: .always)
        }
        catch{
            throw AuthenticationError.loginFailed
        }
    }
    
    @MainActor
    func registerEmailPassword(email: String, password: String) async throws -> (email: String, password: String){
        do{
            try await app.emailPasswordAuth.registerUser(email: email, password: password)
            return (email, password)
        }
        catch{
            throw AuthenticationError.registrationFailed
        }
    }
    
    @MainActor
    func logOut() async throws {
        do{
            try await self.user?.logOut()
            self.user = nil
            self.configuration = nil
            self.realm = nil
        }
        catch{
            throw AuthenticationError.logoutFailed
        }
    }
}




// MARK: Subs
extension RealmManager{
    
    private func initializeSubs(){
        // Publishing to user logged in variable
        $realm
            .combineLatest($user, $configuration){ realm, user, config in
                realm != nil && user != nil && config != nil
            }
            .receive(on: DispatchQueue.main)
            .sink{[weak self] receivedValue in
                self?.userLoggedIn = receivedValue
            }
            .store(in: &subscribtions)
    }
}
