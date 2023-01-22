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
    
    @State var contentYOffset: CGFloat = 500
    @State var contentOpacity: Double = 0.0
    
    init(di: DiContainer, discoveredLandmark: DiscoveredLandmark) {
        self.di = di
        self.discoveredLandmark = discoveredLandmark
    }
    
    
    var body: some View {
        ScrollView(.vertical){
            image
                .opacity(contentOpacity)
                .animation(.linear(duration: 0.5), value: contentOpacity)
            content
                .offset(y: contentYOffset)
                .opacity(contentOpacity)
                .animation(.easeInOut(duration: 0.5), value: contentYOffset)
                .animation(.linear(duration: 0.5), value: contentOpacity)
        }
        .navigationTitle(discoveredLandmark.landmark?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            startContentAnimation()
        }
    }
    
    @ViewBuilder
    var image: some View{
        if let landmark = discoveredLandmark.landmark{
            Image(uiImage: UIImage.getByAssetName(assetName: landmark.imageAssetName))
                .resizable()
                .scaledToFit()
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: .infinity)
                .cornerRadius(20)
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
                    rewardButton
                        .zIndex(1)
                    ZStack(alignment: .top){
                        VStack{
                            Text(landmark.name)
                                .font(.largeTitle)
                            
                            discoveredDate()
                                .padding(.bottom, 10)
                            
                            Text(landmark.landmarkDescription)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.top, 50)
                        .padding(.horizontal, 20)
                    }
                    .frame(maxWidth: .infinity)
                    .background(.background)
                    .cornerRadius(20)
                }
            }
            .offset(y: -150)
        }
    }
    
    
    
}

// MARK: Components
extension DiscoveredDetailScreen{
    @ViewBuilder
    var rewardButton: some View{
        NavigationLink{
            RewardARScreen(discoveredLandmark: discoveredLandmark)
        } label: {
            ZStack(alignment: .center){
                Circle()
                    .foregroundColor(.accentColor)
                    .frame(width: 90, height: 90)
                Circle()
                    .foregroundColor(.onAccent)
                    .frame(width: 70, height: 70)
                Image(systemName: "cube.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.accentColor)
            }
            .offset(y: 52)
        }
    }
    
    func discoveredDate() -> some View{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM/dd/yyyy"
        let date = dateFormatter.string(from: discoveredLandmark.discovered)
        
        return Text("\(String(localized: "discoveredOn")): \(date)")
            .font(.subheadline)
    }
    
    func startContentAnimation(){
        withAnimation{
            contentYOffset = 0
            contentOpacity = 1.0
        }
    }
}

struct DiscoveredDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveredDetailScreen(di: DiContainer(), discoveredLandmark: DiscoveredLandmark.sampleDiscovered)
    }
}
