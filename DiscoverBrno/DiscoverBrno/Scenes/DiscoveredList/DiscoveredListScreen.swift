//
//  DiscoveredListScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import SwiftUI
import RealmSwift

struct DiscoveredListScreen: View {
    private let di: DiContainer
    
    @ObservedResults(DiscoveredLandmark.self)
    var discoveredLandmarks
    
    init(di: DiContainer) {
        self.di = di
    }
    
    var body: some View {
        List{
            Na
            ForEach(discoveredLandmarks){ discovered in
                DiscoveredListItem(discoveredLandmark: discovered)
            }
        }
    }
}

struct DiscoveredListScreen_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveredListScreen(di: DiContainer())
    }
}
