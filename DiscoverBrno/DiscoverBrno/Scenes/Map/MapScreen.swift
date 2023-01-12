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
    

    @State var lastSelected: DiscoverableLandmark? = nil
    @State var lastSelectedDiscovered: Bool = false
    @State var showPopup: Bool = false
    
    
    init(di: DiContainer) {
        self.di = di
        self._store = StateObject(wrappedValue: di.mapStore)
    }
    
    private let di: DiContainer
    @StateObject private var store: MapStore
    
    var body: some View {
        ZStack(alignment: .bottom){
            Map(
                coordinateRegion: $store.coordinateRegion,
                showsUserLocation: true,
                annotationItems: discoverableLandmarks,
                annotationContent: { landmark in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude), content: {
                        LandmarkMarker(discoverableLandmark: landmark, onTapDiscovered: { discoveredLandmark in
                            // NAVIGATE TO LANDMARK DETAIL
                            lastSelected = discoveredLandmark.landmark
                            lastSelectedDiscovered = true
                            withAnimation{
                                showPopup = true
                            }
                            //print(discoveredLandmark.landmark?.name ?? "ERROR")
                        }, onTapDiscoverable: { discoverableLandmark in
                            // DISPLAY HINT
                            lastSelected = discoverableLandmark
                            lastSelectedDiscovered = false
                            withAnimation{
                                showPopup = true
                            }
                            //print("NOT YET DISCOVERED: \(discoverableLandmark.name)")
                        })
                    })
                })
            .ignoresSafeArea(edges: .top)
            .onAppear{
                store.centerMapOnUserLocation()
            }
            if let discoverable = self.lastSelected,
                showPopup == true{
                MapPopupView(showPopup: $showPopup, landmark: discoverable, hasBeenDiscovered: $lastSelectedDiscovered)
                    .frame(maxWidth: .infinity)
            }
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
