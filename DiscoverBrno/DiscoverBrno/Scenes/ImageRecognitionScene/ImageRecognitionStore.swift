//
//  ImageRecognitionStore.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 12.01.2023.
//

import Foundation
import SwiftUI
import Combine

final class ImageRecognitionStore: ObservableObject{
    
    @Published var realmManager: RealmManager
    private let mlModel: DiscoverBrno
    
    @Published var image: UIImage? = nil
    @Published var errorMessage: String = ""
    @Published var discoveredLandmark: (name: String, certainty: Int)? = ("Brno dragon", 20)
    
    
    private var subscribtions = Set<AnyCancellable>()
    
    init(realmManager: RealmManager, mlModel: DiscoverBrno) {
        self.realmManager = realmManager
        self.mlModel = mlModel
        initializeSubs()
    }
}

// MARK: Methods
extension ImageRecognitionStore{
    
    private func tryRecognizeImage(image: UIImage) -> (name: String, certainty: Int)?{
        let resized = image.resize(size: CGSize(width: 299, height: 299))
        let pixelBuffer = resized?.toPixelBuffer()
        
        guard let buffer = pixelBuffer else {
            return nil
        }
        
        let results = try? mlModel.prediction(image: buffer)
        
        guard let output = results?.classLabelProbs else{
            return nil
        }
        
        let best = output.max(by: { $0.value < $1.value })
        
        guard let bestResult = best else {
            return nil
        }
        
        // TEMPORARY - faulty model
        if bestResult.key.lowercased() == "brno dragon"{
            return bestResult.value > 0.995 ? (bestResult.key, Int(bestResult.value*100)) : nil
        }
        else {
            return bestResult.value > 0.98 ? (bestResult.key, Int(bestResult.value*100)) : nil
        }
    }
    
    private func checkIfUserAlreadyDiscovered(landmarkName: String) -> Bool{
        guard let _ = realmManager.getDiscoveredLandmarkByName(name: landmarkName) else {
            return false
        }
        return true
    }
    
    private func saveNewDiscoveredLandmark(landmarkName: String) throws{
        let discovered = DiscoveredLandmark()
        let discoverableParent = realmManager.getDiscoverableLandmarkByName(name: landmarkName)
        
        guard let discoverable = discoverableParent else {
            throw DataError.dataProcessingFailed
        }
        
        try realmManager.addDiscoveredLandmark(discovered: discovered, parent: discoverable)
    }
}



// MARK: Combine
extension ImageRecognitionStore{
    
    private func initializeSubs(){
        $image
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] image in
                if self?.image == nil && image == nil { return }
                self?.errorMessage = ""
                self?.discoveredLandmark = nil
                
                guard let img = image else {
                    self?.errorMessage = "Failed to process image"
                    return
                }
                guard let recognized = self?.tryRecognizeImage(image: img) else {
                    self?.errorMessage = "Landmark was not recognized"
                    return
                }
                guard let alreadyDisovered = self?.checkIfUserAlreadyDiscovered(landmarkName: recognized.name) else { return }
                
                if alreadyDisovered{
                    self?.errorMessage = "\(recognized.name) was already discovered"
                }
                else{
                    do{
                        try self?.saveNewDiscoveredLandmark(landmarkName: recognized.name)
                        self?.discoveredLandmark = recognized
                    }
                    catch{
                        self?.errorMessage = "Failed to save the newly discovered landmark: \(recognized.name)"
                    }
                }
            }
            .store(in: &subscribtions)
    }
}
