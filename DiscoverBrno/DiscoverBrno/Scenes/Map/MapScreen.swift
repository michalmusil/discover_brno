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
    private let di: DiContainer
    @StateObject private var store: MapStore
    
    @ObservedResults(DiscoverableLandmark.self)
    var discoverableLandmarks
    @ObservedResults(DiscoveredLandmark.self)
    var discoveredLandmarks
    

    @State var lastSelected: DiscoverableLandmark? = nil
    @State var lastSelectedDiscovered: Bool = false
    @State var showPopup: Bool = false
    
    @State var locations: [BrnoLocation] = []
    
    init(di: DiContainer) {
        self.di = di
        self._store = StateObject(wrappedValue: di.mapStore)
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            ZStack(alignment: .bottom){
                MapView(locations: locations)
                    .ignoresSafeArea(edges: .top)
                    .onAppear{
                        store.centerMapOnUserLocation()
                        updateBrnoLocations(discoverableLandmarks: discoverableLandmarks.reversed())
                    }
            
                if let discoverable = self.lastSelected,
                   showPopup == true{
                    MapPopupView(di: di, landmark: discoverable, showPopup: $showPopup, hasBeenDiscovered: $lastSelectedDiscovered)
                        .padding(.bottom, 15)
                        .padding(.horizontal, 5)
                }
            }
            
            NavigationLink{
                ImageRecognitionScreen(di: di)
            } label: {
                ZStack(alignment: .center){
                    Circle()
                        .foregroundColor(.accentColor)
                        .frame(width: 75, height: 75)
                    Circle()
                        .foregroundColor(.onAccent)
                        .frame(width: 55, height: 55)
                    Image(systemName: "camera.viewfinder")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.accentColor)
                }
                .padding(.trailing, 15)
            }
             
        }
    }
}


// MARK: Util functions
extension MapScreen{
    
    private func getDiscoveredIfExists(discoverable: DiscoverableLandmark) -> DiscoveredLandmark?{
        return discoveredLandmarks.first(where: { $0.landmark?._id.stringValue == discoverable._id.stringValue })
    }
    
    private func updateBrnoLocations(discoverableLandmarks: [DiscoverableLandmark]){
        var locationsTemp: [BrnoLocation] = []
        for landmark in discoverableLandmarks {
            let isDiscovered = getDiscoveredIfExists(discoverable: landmark) != nil
            
            let onTap: (DiscoverableLandmark) -> Void = isDiscovered ?
            { discoveredLandmark in
                // NAVIGATE TO LANDMARK DETAIL
                lastSelected = discoveredLandmark
                lastSelectedDiscovered = true
                withAnimation{
                    showPopup = true
                }
            }
            : { discoverableLandmark in
                lastSelected = discoverableLandmark
                lastSelectedDiscovered = false
                withAnimation{
                    showPopup = true
                }
            }
           
            
            locationsTemp.append(BrnoLocation(coordinate: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude), landmark: landmark, isDiscovered: isDiscovered, onTap: onTap))
        }
        locations = locationsTemp
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen(di: DiContainer())
    }
}
