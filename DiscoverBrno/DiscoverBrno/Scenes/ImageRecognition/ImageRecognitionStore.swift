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
    @Published var state: State = .idle
    
    @Published var realmManager: RealmManager
    private let mlModel: DiscoverBrno
    
    @Published var image: UIImage? = nil
    @Published var errorMessage: String = ""
    @Published var discoveredLandmark: DiscoveredLandmark?
    
    @Published var contentYOffset: CGFloat = 0.0
    @Published var contentOpacity: Double = 0.0
    
    private var subscribtions = Set<AnyCancellable>()
    
    init(realmManager: RealmManager, mlModel: DiscoverBrno) {
        self.realmManager = realmManager
        self.mlModel = mlModel
        initializeSubs()
    }
}

// MARK: State
extension ImageRecognitionStore{
    enum State{
        case idle
        case failedToProcessImage
        case imageNotRecognized
        case landmarkAlreadyDiscovered
        case failedToSave
        case newLandmarkDiscovered
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
    
    private func checkIfUserAlreadyDiscovered(landmarkName: String) -> DiscoveredLandmark?{
        guard let landmark = realmManager.getDiscoveredLandmarkByName(name: landmarkName) else {
            return nil
        }
        return landmark
    }
    
    private func saveNewDiscoveredLandmark(landmarkName: String) throws -> DiscoveredLandmark{
        let discovered = DiscoveredLandmark()
        let discoverableParent = realmManager.getDiscoverableLandmarkByName(name: landmarkName)
        
        guard let discoverable = discoverableParent else {
            throw DataError.dataProcessingFailed
        }
        
        try realmManager.addDiscoveredLandmark(discovered: discovered, parent: discoverable)
        
        return discovered
    }
    
    func startResultAnimation(){
        withAnimation{
            self.contentYOffset = 0
            self.contentOpacity = 1.0
        }
    }
    
    func resetResultAnimation(){
        self.contentYOffset = 500
        self.contentOpacity = 0.0
    }
}



// MARK: Combine
extension ImageRecognitionStore{
    
    private func initializeSubs(){
        $image
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] image in
                guard let self = self else { return }
                
                if self.image == nil && image == nil { return }
                self.errorMessage = ""
                self.discoveredLandmark = nil
                
                guard let img = image else {
                    self.errorMessage = String(localized: "failedToProcessImage")
                    self.state = .failedToProcessImage
                    return
                }
                guard let recognized = self.tryRecognizeImage(image: img) else {
                    self.errorMessage = String(localized: "landmarkNotRecognized")
                    self.state = .imageNotRecognized
                    return
                }
                if let alreadyDisovered = self.checkIfUserAlreadyDiscovered(landmarkName: recognized.name) {
                    self.errorMessage = "\(String(localized: "landmarkAlreadyDiscovered")): \(alreadyDisovered.landmark?.name ?? "")"
                    self.state = .landmarkAlreadyDiscovered
                    return
                }
                do{
                    let saved = try self.saveNewDiscoveredLandmark(landmarkName: recognized.name)
                    self.discoveredLandmark = saved
                    self.state = .newLandmarkDiscovered
                }
                catch{
                    self.errorMessage = String(localized: "failedToSaveLandmark")
                    self.state = .failedToSave
                }
            }
            .store(in: &subscribtions)
    }
}
