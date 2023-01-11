//
//  MapScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import SwiftUI
import MapKit
import RealmSwift

struct MapScreen: View {
    @ObservedResults(DiscoverableLandmark.self)
    var discoverableLandmarks
    @ObservedResults(DiscoveredLandmark.self)
    var discoveredLandmarks
    
    
    init(di: DiContainer) {
        self.di = di
        self._store = StateObject(wrappedValue: di.mapStore)
    }
    
    private let di: DiContainer
    @StateObject private var store: MapStore
    
    var body: some View {
        Map(
            coordinateRegion: $store.coordinateRegion,
            showsUserLocation: true,
            annotationItems: discoverableLandmarks,
            annotationContent: { landmark in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude), content: {
                    LandmarkMarker(discoverableLandmark: landmark)
                })
            })
        .ignoresSafeArea(edges: .top)
        .onAppear{
            store.centerMapOnUserLocation()
        }
    }
}

// MARK: Util functions
extension MapScreen{
    
    private func getDiscoveredIfExists(discoverable: DiscoverableLandmark) -> DiscoveredLandmark?{
        return discoveredLandmarks.first(where: { $0.landmark?._id.stringValue == discoverable._id.stringValue })
    }
    
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen(di: DiContainer())
    }
}
