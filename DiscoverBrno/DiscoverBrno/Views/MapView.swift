//
//  MapView.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 12.01.2023.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {

    let configuration: MKStandardMapConfiguration

    @Binding
    private var coordinateRegion: MKCoordinateRegion

    private var coordinateSpan: MKCoordinateSpan {
        MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125)
    }

    init(coordinateRegion: Binding<MKCoordinateRegion>) {
        configuration = MKStandardMapConfiguration()
        configuration.pointOfInterestFilter = MKPointOfInterestFilter(including: [])
        
        self._coordinateRegion = coordinateRegion
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.region = coordinateRegion
        mapView.preferredConfiguration = configuration

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) { }
}
