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
    var landmark: DiscoverableLandmark
    var isDiscovered: Bool
    
    init(coordinate: CLLocationCoordinate2D, landmark: DiscoverableLandmark, isDiscovered: Bool) {
        self.coordinate = coordinate
        self.landmark = landmark
        self.isDiscovered = isDiscovered
    }
}
