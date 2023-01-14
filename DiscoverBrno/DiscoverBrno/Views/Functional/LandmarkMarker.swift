//
//  LandmarkMarker.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import SwiftUI
import RealmSwift
import CoreLocation

struct LandmarkMarker: View {
    
    var location: BrnoLocation
    
    var onTapDiscovered: (DiscoverableLandmark) -> Void
    var onTapDiscoverable: (DiscoverableLandmark) -> Void
    
    var body: some View {
        if location.isDiscovered {
            discovered(discoverableLandmark: location.landmark)
        }
        else{
            undiscovered(discoverableLandmark: location.landmark)
        }
    }
    
    
    func discovered(discoverableLandmark: DiscoverableLandmark) -> some View {
        return VStack(spacing: 0){
            ZStack{
                Circle()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.green)
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.green)
                .frame(width: 15, height: 15)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -6)
                .padding(.bottom, 33)
            
        }
        .onTapGesture {
            onTapDiscovered(discoverableLandmark)
        }
    }
    
    
    func undiscovered(discoverableLandmark: DiscoverableLandmark) -> some View{
        return VStack(spacing: 0){
            ZStack{
                Circle()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.red)
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .frame(width: 15, height: 15)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -6)
                .padding(.bottom, 33)
        }
        .onTapGesture {
            onTapDiscoverable(discoverableLandmark)
        }
    }
}

struct LandmarkMarker_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkMarker(location: BrnoLocation(coordinate: CLLocationCoordinate2D(latitude: 50, longitude: 50), landmark: DiscoverableLandmark.sampleDiscoverable, isDiscovered: false, onTap: {_ in}), onTapDiscovered: {_ in}, onTapDiscoverable: {_ in})
    }
}
