//
//  DiscoverableLandmark.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 10.01.2023.
//

import Foundation
import RealmSwift

class DiscoverableLandmark: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var hint: String = ""
    @Persisted var titleImageUrl: String = ""
    @Persisted var landmarkDescription: String = ""
    
    @Persisted var rewardKey: String = ""
    
    @Persisted var longitude: Double
    @Persisted var latitude: Double
    
    convenience init(name: String, hint: String, titleImageUrl: String, landmarkDescription: String, rewardKey: String, longitude: Double, latitude: Double) {
        self.init()
        self.name = name
        self.hint = hint
        self.titleImageUrl = titleImageUrl
        self.landmarkDescription = landmarkDescription
        self.rewardKey = rewardKey
        self.longitude = longitude
        self.latitude = latitude
    }
    
}
