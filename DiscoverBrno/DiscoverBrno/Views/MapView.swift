//
//  MapView.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 12.01.2023.
//

import Foundation
import MapKit
import SwiftUI
import Combine

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    private var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 49.194855, longitude: 16.608431), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    let configuration: MKStandardMapConfiguration
    private var locations: [BrnoLocation]
    
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator()
    }
    
    init(locations: [BrnoLocation]) {
        configuration = MKStandardMapConfiguration()
        configuration.pointOfInterestFilter = MKPointOfInterestFilter(including: [])
        
        self.locations = locations
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.preferredConfiguration = configuration
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        
        mapView.region.span = coordinateRegion.span
        mapView.setRegion(coordinateRegion, animated: true)
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        refreshLocations(locations: locations, mapView: uiView)
    }
    
    
    func refreshLocations(locations: [BrnoLocation], mapView: MKMapView){
        guard determineIfUpdateAnnotations(annotations: mapView.annotations) else {
            return
        }
        
        var annotations: [CustomMapAnnotation] = []
        for location in locations{
            let defaultImage = location.isDiscovered ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "xmark.circle.fill")
            let annotation = CustomMapAnnotation(coordinate: location.coordinate, landmark: location.landmark, defaultImage: defaultImage!, isDiscovered: location.isDiscovered, onTap: location.onTap)
            annotation.title = location.landmark.name
            annotations.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    private func determineIfUpdateAnnotations(annotations: [MKAnnotation]) -> Bool{
        guard locations.count > 0 else {
            return false
        }
        
        var customAnnotations: [CustomMapAnnotation] = []
        for annotation in annotations {
            if let customAnnotation = annotation as? CustomMapAnnotation{
                customAnnotations.append(customAnnotation)
            }
        }
        
        if locations.count != customAnnotations.count{
            return true
        }
        
        for location in locations{
            guard let annotation = customAnnotations.first(where: {$0.landmark._id.stringValue == location.landmark._id.stringValue}),
                  location.isDiscovered == annotation.isDiscovered else {
                return true
            }
        }
        return false
    }
    
    
    final class MapCoordinator: NSObject, MKMapViewDelegate{
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            guard let customAnnotation = annotation as? CustomMapAnnotation else {
                return nil
            }
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: customAnnotation.title ?? "")
            
            if annotationView == nil{
                annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: customAnnotation.title ?? "")
            }
            else {
                annotationView?.annotation = customAnnotation
            }

            annotationView?.image = customAnnotation.defaultImage
            annotationView?.sizeToFit()
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let customAnnotation = view.annotation as? CustomMapAnnotation else {
                return
            }
            customAnnotation.onTap(customAnnotation.landmark)
        }
    }
}
