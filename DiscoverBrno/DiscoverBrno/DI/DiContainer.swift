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
    var contentStore: ContentStore{
        get{
            ContentStore(realmManager: realmManager)
        }
    }
    var loginStore: LoginStore{
        get{
            LoginStore(realmManager: realmManager, emailValidator: emailValidator)
        }
    }
    var registrationStore: RegistrationStore{
        get{
            RegistrationStore(realmManager: realmManager, emailValidator: emailValidator)
        }
    }
    var mapStore: MapStore {
        get{
            MapStore(realmManager: realmManager, locationManager: locationManager)
        }
    }
    var homeStore: HomeStore{
        get{
            HomeStore(realmManager: realmManager)
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
        
        self.emailValidator = EmailValidator()
        
    }
}
