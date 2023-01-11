//
//  LandmarkMarker.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import SwiftUI
import RealmSwift

struct LandmarkMarker: View {
    
    @ObservedRealmObject
    var discoverableLandmark: DiscoverableLandmark
    
    @ObservedResults(DiscoveredLandmark.self)
    var alreadyDiscovered
    
    var onTapDiscovered: (DiscoveredLandmark) -> Void
    var onTapDiscoverable: (DiscoverableLandmark) -> Void
    
    var body: some View {
        if let landmark = alreadyDiscovered.first(where: {$0.landmark?._id == discoverableLandmark._id}) {
            discovered(discoveredLandmark: landmark)
        }
        else{
            undiscovered(discoverableLandmark: discoverableLandmark)
        }
    }
    
    
    func discovered(discoveredLandmark: DiscoveredLandmark) -> some View {
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
            onTapDiscovered(discoveredLandmark)
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
    static var sampleDiscoverable = DiscoverableLandmark(name: "Brno theatre", hint: "Just go with the wind", titleImageUrl: "http://www.pruvodcebrnem.cz/fotografie/historicke-stavby/morovy-sloup/morovy-sloup-2.jpg", landmarkDescription: "bla bla bla bla bla", rewardKey: "MahenTheatre", longitude: 49.3, latitude: 16.2)
    
    
    
    static var previews: some View {
        LandmarkMarker(discoverableLandmark: sampleDiscoverable, onTapDiscovered: {_ in }, onTapDiscoverable: {_ in })
    }
}
