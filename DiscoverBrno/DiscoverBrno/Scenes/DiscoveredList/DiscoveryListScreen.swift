//
//  DiscoveredListScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import SwiftUI
import RealmSwift

struct DiscoveryListScreen: View {
    private let di: DiContainer
    
    @StateObject var store: DiscoveryListStore
    
    @ObservedResults(DiscoveredLandmark.self)
    var discoveredLandmarks
    @State
    var undiscoveredLandmarks: [DiscoverableLandmark] = []
    
    init(di: DiContainer) {
        self.di = di
        self._store = StateObject(wrappedValue: di.discoveryListStore)
    }
    
    var body: some View {
        VStack{
            ScrollView(.vertical){
                switch store.selectedListType {
                case .discovered:
                    if discoveredLandmarks.isEmpty{
                        ErrorScreen(image: UIImage(named: "sadCroc")!, errorMessage: String(localized: "noDiscoveries"))
                    } else {
                        discoveredItems
                    }
                case .undiscovered:
                    if undiscoveredLandmarks.isEmpty{
                        EverythingDiscoveredScreen()
                    } else {
                        undiscoveredItems
                    }
                }
            }
            
            Picker("Select list type", selection: $store.selectedListType){
                ForEach(DiscoveryListType.allCases, id: \.self){ listType in
                    Text(listType.getName())
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 8)
            .padding(.horizontal)
        }
        .onAppear{
            undiscoveredLandmarks = store.getUndiscoveredLandmarks()
            store.selectedListType = discoveredLandmarks.isEmpty ? .undiscovered : .discovered
        }
    }
    
    @ViewBuilder
    var discoveredItems: some View{
        LazyVStack{
            ForEach(discoveredLandmarks){ discovered in
                DiscoveredListItem(di: di, discoveredLandmark: discovered)
            }
        }
    }
    
    @ViewBuilder
    var undiscoveredItems: some View{
        LazyVStack{
            ForEach(undiscoveredLandmarks){ undiscovered in
                UndiscoveredListItem(discoverableLandmark: undiscovered)
            }
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
        DiscoveryListScreen(di: DiContainer())
    }
}
