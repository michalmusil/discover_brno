//
//  DiscoveredDetailScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 13.01.2023.
//

import SwiftUI

struct DiscoveredDetailScreen: View {
    private let di: DiContainer
    
    private var discoveredLandmark: DiscoveredLandmark
    @StateObject var store: DiscoveredDetailStore
    
    init(di: DiContainer, discoveredLandmark: DiscoveredLandmark) {
        self.di = di
        self.discoveredLandmark = discoveredLandmark
        self._store = StateObject(wrappedValue: di.discoveredDetailStore)
    }
    
    
    var body: some View {
        ScrollView(.vertical){
            image
            content
        }
        .navigationTitle(discoveredLandmark.landmark?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    var image: some View{
        if let landmark = discoveredLandmark.landmark{
            AsyncImage(url: URL(string: landmark.titleImageUrl), content: { image in
                image.resizable()
                .scaledToFit()
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: .infinity)
                .cornerRadius(20)
            }, placeholder: {
                ProgressView()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            })
        }
        else {
            Image(systemName: "questionmark")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: .infinity)
                .padding(100)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(20)
        }
    }
    
    @ViewBuilder
    var content: some View{
        if let landmark = discoveredLandmark.landmark{
            ZStack{
                VStack{
                    Text(landmark.name)
                        .font(.title)
                        .padding(.vertical, 10)
                    Text(landmark.landmarkDescription)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity)
            .background(.background)
            .cornerRadius(20)
            .offset(y: -50)
        }
    }
}

struct DiscoveredDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveredDetailScreen(di: DiContainer(), discoveredLandmark: DiscoveredLandmark.sampleDiscovered)
    }
}
