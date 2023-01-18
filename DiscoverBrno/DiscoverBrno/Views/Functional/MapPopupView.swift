//
//  MapPopupView.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 12.01.2023.
//

import SwiftUI
import RealmSwift

struct MapPopupView: View {
    private let di: DiContainer
    
    var landmark: DiscoverableLandmark

    @Binding
    var hasBeenDiscovered: Bool
    
    private let discoveredLandmark: DiscoveredLandmark?
    
    init(di: DiContainer, landmark: DiscoverableLandmark, showPopup: Binding<Bool>, hasBeenDiscovered: Binding<Bool>) {
        self.di = di
        self.landmark = landmark
        self._hasBeenDiscovered = hasBeenDiscovered
        
        self.discoveredLandmark = di.realmManager.getDiscoveredLandmarkByName(name: landmark.name)
    }
    
    
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                HStack{
                    image
                    content
                    Spacer()
                }
                if let discovered = discoveredLandmark,
                   hasBeenDiscovered{
                    DBNavigationButton(text: String(localized: "goToDetail"), destination: DiscoveredDetailScreen(di: di, discoveredLandmark: discovered))
                        .padding(.top, 3)
                }
            }
            .padding(.vertical, 25)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .background(hasBeenDiscovered ? BackgroundGradient() : BackgroundGradient(topLeftColor: .disabled, bottomRightColor: .shadowColor))
        .cornerRadius(20)
        .shadow(color: .shadowColor, radius: 10)
        
    }
    
    @ViewBuilder
    var image: some View{
        if hasBeenDiscovered{
            Image(uiImage: UIImage.getByAssetName(assetName: landmark.imageAssetName))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .padding(.horizontal, 5)
        }
        else{
            Image(systemName: "questionmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.onAccent)
                .clipShape(Circle())
                .padding(.horizontal, 5)
        }
    }
    
    @ViewBuilder
    var content: some View{
        VStack(alignment: .leading){
            if hasBeenDiscovered{
                Text(landmark.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundColor(.onAccent)
                    .multilineTextAlignment(.leading)
                
                Text(landmark.landmarkDescription)
                    .font(.subheadline)
                    .lineLimit(3)
                    .foregroundColor(.onAccent)
                    .multilineTextAlignment(.leading)
            }
            else{
                Text(String(localized: "hint"))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.onAccent)
                    .multilineTextAlignment(.leading)
                    
                
                Text(landmark.hint)
                    .font(.subheadline)
                    .lineLimit(4)
                    .foregroundColor(.onAccent)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: 230)
    }
}

struct MapPopupView_Previews: PreviewProvider {
    static var previews: some View {
        MapPopupView(di: DiContainer(), landmark: DiscoverableLandmark.sampleDiscoverable, showPopup: .constant(true), hasBeenDiscovered: .constant(false))
    }
}
