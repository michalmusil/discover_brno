//
//  EverythingDiscoveredScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 16.01.2023.
//

import SwiftUI

struct EverythingDiscoveredScreen: View {
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Image(uiImage: UIImage(named: "strongCroc")!)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 25)
                Text(String(localized: "everythingDiscovered"))
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
        .padding(.horizontal, 10)
    }
}

struct EverythingDiscoveredScreen_Previews: PreviewProvider {
    static var previews: some View {
        EverythingDiscoveredScreen()
    }
}
