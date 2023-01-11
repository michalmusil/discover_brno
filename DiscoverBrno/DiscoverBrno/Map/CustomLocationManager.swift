//
//  CustomLocationManager.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import Foundation
import SwiftUI
import MapKit

class CustomLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var currentLocation: CLLocation?
    @Published var reverseGeolocated: String?
    
    private var locationManager: CLLocationManager?
    
    override init(){
        super.init()
        checkSystemLocation()
    }
    
    
    // MARK: User location
    
    func checkSystemLocation(){
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager = CLLocationManager()
            locationManager?.startUpdatingLocation()
            self.locationManager?.delegate = self // IMPORTANT !!!!
            // checkAppLicationAuthorization gets called after creation by locationManagerDidChangeAuthorization
        }
    }
    
    func requestNewLocation(){
        checkAppLocationAuthorization()
    }
    
    private func checkAppLocationAuthorization(){
        guard let locMan = locationManager else {
            return
        }
        switch locMan.authorizationStatus{
        case .notDetermined:
            locMan.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = locMan.location{
                currentLocation = location
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
                    if let placemark = placemarks?.first{
                        let city = placemark.locality
                        let state = placemark.administrativeArea
                        self.reverseGeolocated = "\(city ?? "") \(state ?? "")"
                    }
                })
            }
        default:
            print("Location denied")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAppLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    
}

