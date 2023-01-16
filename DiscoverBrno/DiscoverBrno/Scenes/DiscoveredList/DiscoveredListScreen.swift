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

    @State var selectedListType: DiscoveryListType = .discovered
    
    init(di: DiContainer) {
        self.di = di
    }
    
    var body: some View {
        VStack{
            ScrollView(.vertical){
                LazyVStack{
                    switch selectedListType {
                    case .discovered:
                        discoveredItems
                    case .undiscovered:
                        undiscoveredItems
                    }
                }
            }
            
            Picker("Select list type", selection: $selectedListType){
                ForEach(DiscoveryListType.allCases, id: \.self){ listType in
                    Text(listType.getName())
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 8)
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    var discoveredItems: some View{
        ForEach(discoveredLandmarks){ discovered in
            DiscoveredListItem(di: di, discoveredLandmark: discovered)
        }
    }
    
    @ViewBuilder
    var undiscoveredItems: some View{
        ForEach(discoveredLandmarks){ discovered in
            DiscoveredListItem(di: di, discoveredLandmark: discovered)
        }
    }
    
}

enum DiscoveryListType: CaseIterable{
    case discovered
    case undiscovered
    
    func getName() -> String{
        switch self{
        case .discovered:
            return String(localized: "discovered")
        case .undiscovered:
            return String(localized: "undiscovered")
        }
    }
}



struct DiscoveredListScreen_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveredListScreen(di: DiContainer())
    }
}
