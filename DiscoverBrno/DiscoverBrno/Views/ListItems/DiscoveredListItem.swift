//
//  DiscoveredListItem.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 16.01.2023.
//

import SwiftUI

struct DiscoveredListItem: View {
    private let di: DiContainer
    let discoveredLandmark: DiscoveredLandmark
    
    init(di: DiContainer, discoveredLandmark: DiscoveredLandmark) {
        self.di = di
        self.discoveredLandmark = discoveredLandmark
    }
    
    @State var expanded = false
    
    var body: some View {
        HStack{
            NavigationLink{
                DiscoveredDetailScreen(di: di, discoveredLandmark: discoveredLandmark)
            } label: {
                VStack(alignment: .leading){
                    HStack{
                        image
                        title
                        Spacer()
                    }
                    
                    if expanded{
                        descriptionLong
                    }
                }
                .padding(.horizontal, 20)
            }
            
            expandButton
                .frame(width: 35, height: 50)
                .padding(.trailing, 20)
                .zIndex(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(BackgroundGradient())
        .cornerRadius(20)
        .shadow(color: .shadowColor, radius: 4)
        .padding(.horizontal, 4)
        .padding(.vertical, 5)
    }
    
    
    @ViewBuilder
    var image: some View{
        if let assetName = discoveredLandmark.landmark?.imageAssetName{
            Image(uiImage: UIImage.getByAssetName(assetName: assetName))
                .resizable()
                .scaledToFill()
                .frame(width: 75, height: 75)
                .clipShape(Circle())
                .padding(.horizontal, 5)
        }
        else{
            Image(systemName: "questionmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .clipShape(Circle())
                .padding(.horizontal, 5)
        }
    }
}



// MARK: Elements
extension DiscoveredListItem{
    @ViewBuilder
    var title: some View{
        if let landmark = discoveredLandmark.landmark{
            Text(landmark.name)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.onAccent)
                .lineLimit(2)
                .padding(.leading, 10)
        }
    }
    
    @ViewBuilder
    var descriptionLong: some View{
        if let landmark = discoveredLandmark.landmark{
            Text(landmark.landmarkDescription)
                .font(.caption)
                .foregroundColor(.onAccent)
                .lineLimit(10)
                .multilineTextAlignment(.leading)
                
        }
    }
    
    @ViewBuilder
    var expandButton: some View{
        Button{
            withAnimation(Animation.easeInOut(duration: 0.1)){
                expanded.toggle()
            }
        } label: {
            Image(systemName: expanded ? "chevron.up" : "chevron.down")
                .tint(.onAccent)
        }
    }
}



struct DiscoveredListItem_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveredListItem(di: DiContainer(), discoveredLandmark: DiscoveredLandmark.sampleDiscovered)
    }
}
