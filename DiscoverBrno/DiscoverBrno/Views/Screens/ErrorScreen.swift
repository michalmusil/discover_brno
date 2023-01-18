//
//  NoDiscoveriesScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 16.01.2023.
//

import SwiftUI

struct ErrorScreen: View {
    
    let image: UIImage
    let errorMessage: String
    
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                
                Text(errorMessage)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
        .padding(.horizontal, 10)
    }
}

struct ErrorScreen_Previews: PreviewProvider {
    static var previews: some View {
        ErrorScreen(image: UIImage.getByAssetName(assetName: "sadCroc"), errorMessage: "Some particular thing has gone wrong and this is the error screen")
    }
}
