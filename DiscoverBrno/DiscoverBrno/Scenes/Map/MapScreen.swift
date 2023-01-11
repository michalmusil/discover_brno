//
//  MapScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import SwiftUI
import MapKit

struct MapScreen: View {
    private let di: DiContainer
    
    @StateObject private var store: MapStore
    
    init(di: DiContainer) {
        self.di = di
        self._store = StateObject(wrappedValue: di.mapStore)
    }
    
    var body: some View {
        Map(coordinateRegion: $store.coordinateRegion)
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen(di: DiContainer())
    }
}
