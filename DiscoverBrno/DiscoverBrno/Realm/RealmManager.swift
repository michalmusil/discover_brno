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


// MARK: CRUD methods
extension RealmManager{
    
    func addDiscoveredLandmark(discovered: DiscoveredLandmark, parent: DiscoverableLandmark) throws{
        guard let realm = self.realm else {
            throw DataError.realmInstanceNil
        }
        
        guard let observed = realm.object(ofType: DiscoverableLandmark.self, forPrimaryKey: parent._id) else {
            throw DataError.dataProcessingFailed
        }
        
        guard let user = self.user else {
            throw DataError.userInstanceNil
        }
        
        do{
            discovered.discovered = Date()
            discovered.ownerId = user.id
            try realm.write{
                    discovered.landmark = observed
                    realm.add(discovered)
                }
        }
        catch{
            throw DataError.dataProcessingFailed
        }
    }
    
}

// MARK: Get methods
extension RealmManager{
    
    func getDiscoveredLandmarks() throws -> [DiscoveredLandmark]{
        guard let realmInstance = self.realm else {
            throw DataError.realmInstanceNil
        }
        
        let landmarks = realmInstance.objects(DiscoveredLandmark.self)
        
        return landmarks.reversed()
    }
    
    func getDiscoverableLandmarks() throws -> [DiscoverableLandmark]{
        guard let realmInstance = self.realm else {
            throw DataError.realmInstanceNil
        }
        
        let landmarks = realmInstance.objects(DiscoverableLandmark.self)
        
        return landmarks.reversed()
    }
    
    func getDiscoverableLandmarkByName(name: String) -> DiscoverableLandmark?{
        guard let realmInstance = self.realm else {
            return nil
        }
        
        let landmarks = realmInstance.objects(DiscoverableLandmark.self)
        
        return landmarks.first(where: { $0.name == name })
    }
    
    func getDiscoveredLandmarkByName(name: String) -> DiscoveredLandmark?{
        guard let realmInstance = self.realm else {
            return nil
        }
        
        let landmarks = realmInstance.objects(DiscoveredLandmark.self)
        
        return landmarks.first(where: { $0.landmark?.name.lowercased() == name.lowercased() })
    }
}


// MARK: Authentication methods
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
