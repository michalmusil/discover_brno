//
//  Location.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import Foundation
import MapKit

struct BrnoLocation: Identifiable{
    let id = UUID().uuidString
    var coordinate: CLLocationCoordinate2D
    var discoverable: DiscoverableLandmark?
    var discovered: DiscoveredLandmark?
    
    init(coordinate: CLLocationCoordinate2D, discoverable: DiscoverableLandmark) {
        self.coordinate = coordinate
        self.discoverable = discoverable
        self.discovered = nil
    }
    
    init(coordinate: CLLocationCoordinate2D, discovered: DiscoveredLandmark) {
        self.coordinate = coordinate
        self.discoverable = nil
        self.discovered = discovered
    }
}
