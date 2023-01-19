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
    private let defaults: DiscoverBrnoDefaults
    
    @Published var numberOfDiscovered: Int = 0
    @Published var numberOfRemaining: Int = 0
    @Published var progression: Float = 0.0 // from 0.0 to 1.0
    @Published var mostRecentLandmark: DiscoveredLandmark?
    
    @Published var numberOfDiscoveredString = ""
    @Published var numberOfRemainingString = ""
    
    private var subscribtions = Set<AnyCancellable>()
    
    init(realmManager: RealmManager, defaults: DiscoverBrnoDefaults){
        self.realmManager = realmManager
        self.defaults = defaults
        setUpSubscriptions()
    }
    
    @MainActor
    func logOut(){
        Task{
            do{
                defaults.clearEmailAndPassword()
                try await realmManager.logOut()
            } catch{
                print(error)
                state = .error
            }
        }
    }
    
    @MainActor
    func updateStatistics() {
        do{
            let discoverable = try realmManager.getDiscoverableLandmarks()
            let discovered = try realmManager.getDiscoveredLandmarks()
            
            guard discovered.count > 0 else{
                self.state = .noDiscoveries
                return
            }
            
            self.numberOfDiscovered = discovered.count
            self.numberOfRemaining = discoverable.count - discovered.count
            self.mostRecentLandmark = getMostRecentDiscovered(discovered: discovered)
            
            Task{
                try? await Task.sleep(for: Duration(secondsComponent: 0, attosecondsComponent: 500000000000000000)) // half a second delay
                self.progression = getOverallProgression(discoverable: discoverable, discovered: discovered)
            }
            
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
        case noDiscoveries
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
        guard discoverable.count>0 else {
            return 0.0
        }
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
