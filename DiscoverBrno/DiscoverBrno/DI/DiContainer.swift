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
    let credentialsValidator: CredentialsValidator
    let discoverBrnoDefaults: DiscoverBrnoDefaults
    
    
    
    // Stores
    var contentStore: ContentStore{
        get{
            ContentStore(realmManager: realmManager)
        }
    }
    var loginStore: LoginStore{
        get{
            LoginStore(realmManager: realmManager, credentialsValidator: credentialsValidator, defaults: discoverBrnoDefaults)
        }
    }
    var registrationStore: RegistrationStore{
        get{
            RegistrationStore(realmManager: realmManager, credentialsValidator: credentialsValidator, defaults: discoverBrnoDefaults)
        }
    }
    var mapStore: MapStore {
        get{
            MapStore(realmManager: realmManager, locationManager: locationManager)
        }
    }
    var homeStore: HomeStore{
        get{
            HomeStore(realmManager: realmManager, defaults: discoverBrnoDefaults)
        }
    }
    var imageRecognitionStore: ImageRecognitionStore{
        get{
            ImageRecognitionStore(realmManager: realmManager, mlModel: mlModel)
        }
    }
    var discoveredDetailStore: DiscoveredDetailStore{
        get{
            DiscoveredDetailStore()
        }
    }
    var discoveryListStore: DiscoveryListStore{
        get{
            DiscoveryListStore(realmManager: realmManager)
        }
    }
    
    init(){
        self.realmManager = RealmManager.shared
        
        self.locationManager = CustomLocationManager()
        
        self.mlModel = (try? DiscoverBrno(configuration: MLModelConfiguration())) ?? DiscoverBrno()
        
        self.credentialsValidator = CredentialsValidator()
        self.discoverBrnoDefaults = DiscoverBrnoDefaults(credentialsValidator: credentialsValidator)
        
    }
}
