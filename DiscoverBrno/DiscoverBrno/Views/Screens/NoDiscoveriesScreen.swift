//
//  NoDiscoveriesScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 16.01.2023.
//

import SwiftUI

struct NoDiscoveriesScreen: View {
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Image(uiImage: UIImage(named: "sadCroc")!)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                
                Text(String(localized: "noDiscoveries"))
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
        .padding(.horizontal, 10)
    }
}

struct NoDiscoveriesScreen_Previews: PreviewProvider {
    static var previews: some View {
        NoDiscoveriesScreen()
    }
}
