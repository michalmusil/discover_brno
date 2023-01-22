//
//  CustomMarker.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 13.01.2023.
//

import Foundation
import MapKit

class CustomMapAnnotation: NSObject, MKAnnotation {
    var title: String? = nil
    var subtitle: String? = nil
    let coordinate: CLLocationCoordinate2D
    let landmark: DiscoverableLandmark
    let defaultImage: UIImage
    let isDiscovered: Bool
    
    var onSelected: (DiscoverableLandmark) -> Void
    var onDeselected: (DiscoverableLandmark) -> Void

    init(coordinate: CLLocationCoordinate2D, landmark: DiscoverableLandmark, defaultImage: UIImage, isDiscovered: Bool, onSelected: @escaping (DiscoverableLandmark) -> Void, onDeselected: @escaping (DiscoverableLandmark) -> Void) {
        self.title = landmark.name
        self.coordinate = coordinate
        self.landmark = landmark
        self.defaultImage = defaultImage
        self.isDiscovered = isDiscovered
        self.onSelected = onSelected
        self.onDeselected = onDeselected
    }

}
