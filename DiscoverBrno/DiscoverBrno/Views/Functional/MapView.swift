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
    
    let configuration: MKStandardMapConfiguration
    private var locations: [BrnoLocation]
    private var startingRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 49.194855, longitude: 16.608431), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    
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
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        refreshLocations(locations: locations, mapView: uiView)
    }
    
    
    
    final class MapCoordinator: NSObject, MKMapViewDelegate{
        
        var lastSelectedAnnotation: CustomMapAnnotation? = nil
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            guard let customAnnotation = annotation as? CustomMapAnnotation else {
                return nil
            }
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: customAnnotation.title!)
            
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
            
            // Focusing the selected annotation
            let focusedRegion = MKCoordinateRegion(center: customAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            mapView.setRegion(focusedRegion, animated: true)
            
            // Enlarging the annotation size
            let standardSize = customAnnotation.defaultImage.size
            view.image = customAnnotation.defaultImage.resize(size: CGSize(width: standardSize.width*1.5, height: standardSize.height*1.5))
            view.sizeToFit()
            
            lastSelectedAnnotation = customAnnotation
            customAnnotation.onSelected(customAnnotation.landmark)
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            guard let customAnnotation = view.annotation as? CustomMapAnnotation else {
                return
            }
            guard let deselectedCustom = lastSelectedAnnotation else {
                return
            }
            
            // Returning image of the deselected annotation to default size
            view.image = deselectedCustom.defaultImage
            view.sizeToFit()
            
            lastSelectedAnnotation = nil
            customAnnotation.onDeselected(customAnnotation.landmark)
        }
    }
}



// MARK: Helper methods
extension MapView{
    func refreshLocations(locations: [BrnoLocation], mapView: MKMapView){
        guard determineIfUpdateAnnotations(annotations: mapView.annotations) else {
            return
        }
        
        let discoveredImage = UIImage.getByAssetName(assetName: "brnoFlag").resize(size: CGSize(width: 72.7, height: 93.1))!
        let undiscoveredImage = UIImage.getByAssetName(assetName: "flagUndiscovered").resize(size: CGSize(width: 72.7, height: 93.1))!
        
        var annotations: [CustomMapAnnotation] = []
        for location in locations{
            let defaultImage = location.isDiscovered ? discoveredImage : undiscoveredImage
            let annotation = CustomMapAnnotation(coordinate: location.coordinate, landmark: location.landmark, defaultImage: defaultImage, isDiscovered: location.isDiscovered, onSelected: location.onSelected, onDeselected: location.onDeselected)
            annotations.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        
        mapView.setRegion(startingRegion, animated: true)
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
}
