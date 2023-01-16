//
//  UndiscoveredListItem.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 16.01.2023.
//

import SwiftUI

struct UndiscoveredListItem: View {
    
    let discoverableLandmark: DiscoverableLandmark
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                HStack{
                    image
                    Spacer()
                    hint
                    Spacer()
                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(BackgroundGradient(topLeftColor: .disabled, bottomRightColor: .shadowColor))
        .cornerRadius(20)
        .shadow(color: .shadowColor, radius: 4)
        .padding(.horizontal, 4)
        .padding(.vertical, 5)
    }
    
    @ViewBuilder
    var hint: some View{
        Text(discoverableLandmark.hint)
            .font(.subheadline)
            .foregroundColor(.onAccent)
            .multilineTextAlignment(.center)
            .padding(.top, 2)
    }
    
    @ViewBuilder
    var image: some View{
        Image(systemName: "questionmark.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 75, height: 75)
            .padding(.horizontal, 5)
            .foregroundColor(.onAccent)
    }
    
}

struct UndiscoveredListItem_Previews: PreviewProvider {
    static var previews: some View {
        UndiscoveredListItem(discoverableLandmark: DiscoverableLandmark.sampleDiscoverable)
    }
}
