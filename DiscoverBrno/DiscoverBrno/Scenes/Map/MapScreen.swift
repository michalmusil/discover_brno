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
    
    init(di: DiContainer) {
        self.di = di
        self._store = StateObject(wrappedValue: di.mapStore)
    }
    
    var body: some View {
        VStack{
            switch store.state{
            case .idle:
                content
            case .error:
                ErrorScreen(image: UIImage.getByAssetName(assetName: "sadCroc"), errorMessage: String(localized: "somethingWentWrong"))
            }
        }
        .onAppear{
            store.centerMapOnUserLocation()
            store.updateBrnoLocations()
        }
    }
    
    @ViewBuilder
    var content: some View{
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            ZStack(alignment: .bottom){
                map
                landmarkPopup
            }
            recognitionLink
        }
    }
    
}


// MARK: Components
extension MapScreen{
    @ViewBuilder
    var map: some View{
        MapView(locations: store.brnoLocations)
            .ignoresSafeArea(edges: .top)
    }
    
    @ViewBuilder
    var landmarkPopup: some View{
        if let discoverable = store.lastSelected,
           store.showPopup == true{
            MapPopupView(di: di, landmark: discoverable, showPopup: $store.showPopup, hasBeenDiscovered: $store.lastSelectedDiscovered)
                .padding(.bottom, 15)
                .padding(.horizontal, 5)
        }
    }
    
    @ViewBuilder
    var recognitionLink: some View{
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

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen(di: DiContainer())
    }
}
