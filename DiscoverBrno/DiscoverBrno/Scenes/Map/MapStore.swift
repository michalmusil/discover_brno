//
//  MapStore.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import Foundation
import RealmSwift
import MapKit
import Combine
import SwiftUI

final class MapStore: ObservableObject{
    
    @Published var realmManager: RealmManager
    private var subscribtions = Set<AnyCancellable>()
    
    
    @StateObject var locationManager: CustomLocationManager
    @Published var currentLocationString: String = ""
    @Published var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45, longitude: 16), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    init(realmManager: RealmManager, locationManager: CustomLocationManager){
        self.realmManager = realmManager
        self._locationManager = StateObject(wrappedValue: locationManager)
        initializeSubs()
    }
    
}

// MARK: Subs
extension MapStore{
    
    private func initializeSubs(){
        locationManager.$currentLocation
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] location in
                if let loc = location{
                    self?.coordinateRegion = MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                }
            })
            .store(in: &subscribtions)
    }
}
