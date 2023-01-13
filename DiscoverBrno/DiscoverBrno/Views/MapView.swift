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
    
    @State private var subscribtions = Set<AnyCancellable>()
    
    private var coordinateRegion: MKCoordinateRegion
    let configuration: MKStandardMapConfiguration

    private var locations: [BrnoLocation]
    
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator()
    }
    
    init(coordinateRegion: MKCoordinateRegion, locations: [BrnoLocation]) {
        configuration = MKStandardMapConfiguration()
        configuration.pointOfInterestFilter = MKPointOfInterestFilter(including: [])
        
        self.coordinateRegion = coordinateRegion
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
        uiView.region.span = coordinateRegion.span
        uiView.setRegion(coordinateRegion, animated: true)
        refreshLocations(locations: locations, mapView: uiView)
    }
    
    
    func refreshLocations(locations: [BrnoLocation], mapView: MKMapView){
        var annotations: [MKPointAnnotation] = []
        let existingAnnotations = mapView.annotations
        mapView.removeAnnotations(existingAnnotations)
        
        for location in locations{
            let annotation = MKPointAnnotation()
            annotation.title = location.landmark.name
            annotation.coordinate = location.coordinate
            annotations.append(annotation)
        }
        print(annotations.count)
        
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    
    final class MapCoordinator: NSObject, MKMapViewDelegate{
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            guard let title = annotation.title as? String else {
                return nil
            }
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: title)
            
            if annotationView == nil{
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: title)
            }
            else {
                annotationView?.annotation = annotation
            }

            annotationView?.image = UIImage(systemName: "pin.fill")
            
            return annotationView
        }
    }
}
