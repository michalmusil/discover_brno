//
//  MapPopupView.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 12.01.2023.
//

import SwiftUI
import RealmSwift

struct MapPopupView: View {
    
    @Binding
    var showPopup: Bool
    
    var landmark: DiscoverableLandmark
    
    @Binding
    var hasBeenDiscovered: Bool
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            Button{
                withAnimation{
                    showPopup.toggle()
                }
            } label: {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
                    .padding(.trailing, 2)
                    .offset(y: -23)
            }
            VStack(alignment: .leading){
                HStack{
                    image
                    content
                }
                if hasBeenDiscovered{
                    NavigationLink{
                        Text("Na nan a")
                    } label: {
                        Text("Go to detail")
                            .frame(maxWidth: .infinity)
                            .frame(height: 30)
                            .padding(5)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                    }
                }
            }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 10)
        .background(.background)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 10)
        
    }
    
    @ViewBuilder
    var image: some View{
        if hasBeenDiscovered{
            AsyncImage(url: URL(string: landmark.titleImageUrl), content: { image in
                image.resizable()
            }, placeholder: {
                ProgressView()
            })
            .scaledToFill()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .padding(.horizontal, 15)
        }
        else{
            Image(systemName: "questionmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .padding(.horizontal, 15)
        }
    }
    
    @ViewBuilder
    var content: some View{
        VStack(alignment: .leading){
            if hasBeenDiscovered{
                Text(landmark.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(landmark.landmarkDescription)
                    .font(.body)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            else{
                Text("Hint:")
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    
                
                Text(landmark.hint)
                    .font(.system(size: 12))
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: 230)
    }
}

struct MapPopupView_Previews: PreviewProvider {
    static var previews: some View {
        MapPopupView(showPopup: .constant(true), landmark: DiscoverableLandmark.sampleDiscoverable, hasBeenDiscovered: .constant(true))
    }
}
