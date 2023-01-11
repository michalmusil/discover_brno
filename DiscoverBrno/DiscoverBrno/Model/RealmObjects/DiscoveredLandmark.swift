//
//  DiscoveredLandmark.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 10.01.2023.
//

import Foundation
import RealmSwift

class DiscoveredLandmark: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var ownerId: String = ""
    @Persisted var discovered: Date
    
    @Persisted var landmark: DiscoverableLandmark?
    
    convenience init(ownerId: String) {
        self.init()
        self.ownerId = ownerId
        self.discovered = Date()
    }
}
