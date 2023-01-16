//
//  DiContainer.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 10.01.2023.
//

import Foundation
import CoreML

final class DiContainer{
    // Realm
    let realmManager: RealmManager
    
    // Location
    let locationManager: CustomLocationManager
    
    // Machine learning
    let mlModel: DiscoverBrno
    
    // Utils
    let emailValidator: EmailValidator
    
    // Stores
    let contentStore: ContentStore
    let loginStore: LoginStore
    let registrationStore: RegistrationStore
    let mapStore: MapStore
    let imageRecognitionStore: ImageRecognitionStore
    let discoveredDetailStore: DiscoveredDetailStore
    let discoveryListStore: DiscoveryListStore
    
    init(){
        self.realmManager = RealmManager.shared
        
        self.locationManager = CustomLocationManager()
        
        self.mlModel = (try? DiscoverBrno(configuration: MLModelConfiguration())) ?? DiscoverBrno()
        
        self.emailValidator = EmailValidator()
        
        self.contentStore = ContentStore(realmManager: realmManager)
        self.loginStore = LoginStore(realmManager: realmManager, emailValidator: emailValidator)
        self.registrationStore = RegistrationStore(realmManager: realmManager, emailValidator: emailValidator)
        self.mapStore = MapStore(realmManager: realmManager, locationManager: locationManager)
        self.imageRecognitionStore = ImageRecognitionStore(realmManager: realmManager, mlModel: mlModel)
        self.discoveredDetailStore = DiscoveredDetailStore()
        self.discoveryListStore = DiscoveryListStore(realmManager: realmManager)
    }
}
