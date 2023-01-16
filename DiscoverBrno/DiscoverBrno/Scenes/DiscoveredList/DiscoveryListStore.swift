//
//  DiscoveryListStore.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 16.01.2023.
//

import Foundation


final class DiscoveryListStore: ObservableObject{
    
    @Published var selectedListType: DiscoveryListType = .discovered
    @Published var realmManager: RealmManager
    
    
    init(realmManager: RealmManager) {
        self.realmManager = realmManager
    }
    
    
    func getUndiscoveredLandmarks() -> [DiscoverableLandmark]{
        do{
            let results = try realmManager.getUndiscoveredLandmarks()
            return results
        } catch{
            print(error)
            return []
        }
    }
}
