//
//  HomeStore.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 17.01.2023.
//

import Foundation
import Combine

final class HomeStore: ObservableObject{
    @Published var state: State = .loading
    
    @Published var realmManager: RealmManager
    
    @Published var numberOfDiscovered: Int = 0
    @Published var numberOfRemaining: Int = 0
    @Published var progression: Float = 0.0 // from 0.0 to 1.0
    @Published var mostRecentLandmark: DiscoveredLandmark?
    
    @Published var numberOfDiscoveredString = ""
    @Published var numberOfRemainingString = ""
    
    private var subscribtions = Set<AnyCancellable>()
    
    init(realmManager: RealmManager){
        self.realmManager = realmManager
        setUpSubscriptions()
    }
    
    func updateStatistics() {
        do{
            let discoverable = try realmManager.getDiscoverableLandmarks()
            let discovered = try realmManager.getDiscoveredLandmarks()
            
            self.numberOfDiscovered = discovered.count
            self.numberOfRemaining = discoverable.count - discovered.count
            self.progression = getOverallProgression(discoverable: discoverable, discovered: discovered)
            self.mostRecentLandmark = getMostRecentDiscovered(discovered: discovered)
            
            self.state = .loaded
        } catch{
            print(error)
            self.state = .error
        }        
    }
    
}

// MARK: State
extension HomeStore{
    enum State {
        case loading
        case loaded
        case error
    }
}

// MARK: Combine
extension HomeStore{
    
    private func setUpSubscriptions(){
        $numberOfDiscovered
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] value in
                self?.numberOfDiscoveredString = String(value)
            }
            .store(in: &subscribtions)
        
        $numberOfRemaining
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] value in
                self?.numberOfRemainingString = String(value)
            }
            .store(in: &subscribtions)
    }
}


// MARK: Statistics helper methods
extension HomeStore{
    
    private func getOverallProgression(discoverable: [DiscoverableLandmark], discovered: [DiscoveredLandmark]) -> Float{
        let progression = Float(discovered.count)/Float(discoverable.count)
        return progression
    }
    
    private func getMostRecentDiscovered(discovered: [DiscoveredLandmark]) -> DiscoveredLandmark?{
        guard discovered.count > 0 else {
            return nil
        }
        
        let mostRecent = discovered.max(by: { $0.discovered < $1.discovered })
        
        return mostRecent
    }
    
}
