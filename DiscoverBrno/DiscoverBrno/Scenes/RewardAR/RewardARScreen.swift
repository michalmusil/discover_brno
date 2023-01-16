//
//  RewardARScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 15.01.2023.
//

import SwiftUI

struct RewardARScreen: View {
    
    let discoveredLandmark: DiscoveredLandmark
    
    var body: some View {
        ZStack{
            ARView(discoveredLandmark: discoveredLandmark)
        }
        .ignoresSafeArea(.all)
    }
}

struct RewardARScreen_Previews: PreviewProvider {
    static var previews: some View {
        RewardARScreen(discoveredLandmark: DiscoveredLandmark.sampleDiscovered)
    }
}
