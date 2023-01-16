//
//  DiscoveredListItem.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 16.01.2023.
//

import SwiftUI

struct DiscoveredListItem: View {
    
    let discoveredLandmark: DiscoveredLandmark
    
    @State var expanded = false
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                if expanded{
                    expandedContent
                } else {
                    nonExpandedContent
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(BackgroundGradient())
        .cornerRadius(20)
        .shadow(color: .shadowColor, radius: 4)
        .padding(.horizontal, 8)
    }
    
    
    @ViewBuilder
    var image: some View{
        Image(systemName: "questionmark.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 75, height: 75)
            .clipShape(Circle())
        /*
        if let imageUrl = discoveredLandmark.landmark?.titleImageUrl{
            AsyncImage(url: URL(string: imageUrl), content: { image in
                image.resizable()
            }, placeholder: {
                ProgressView()
            })
            .scaledToFit()
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
         */
    }
    
    @ViewBuilder
    var nonExpandedContent: some View{
        HStack{
            image
            Spacer()
            title
            Spacer()
            expandButton
        }
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    var expandedContent: some View{
        VStack{
            HStack{
                image
                Spacer()
                title
                Spacer()
                expandButton
            }
            descriptionLong
        }
        .padding(.horizontal, 15)
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
        }
    }
    
    @ViewBuilder
    var descriptionLong: some View{
        if let landmark = discoveredLandmark.landmark{
            Text(landmark.landmarkDescription)
                .font(.caption)
                .foregroundColor(.onAccent)
                .lineLimit(10)
                .multilineTextAlignment(.center)
                .padding(.top, 2)
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
        DiscoveredListItem(discoveredLandmark: DiscoveredLandmark.sampleDiscovered)
    }
}