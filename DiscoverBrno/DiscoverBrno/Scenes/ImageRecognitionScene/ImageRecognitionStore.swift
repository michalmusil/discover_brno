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
    @Published var landmarkName: String = ""
    
    private var subscribtions = Set<AnyCancellable>()
    
    init(realmManager: RealmManager, mlModel: DiscoverBrno) {
        self.realmManager = realmManager
        self.mlModel = mlModel
        initializeSubs()
    }
    
    func tryRecognizeImage(image: UIImage) throws{
        let resized = image.resize(size: CGSize(width: 299, height: 299))
        let pixelBuffer = resized?.toPixelBuffer()
        
        guard let buffer = pixelBuffer else {
            return
        }
        
        let results = try? mlModel.prediction(image: buffer)
        
        if let output = results?.classLabel {
            self.landmarkName = output
        }
        else {
            landmarkName = "Image not recognized"
        }
    }
}

// MARK: Combine
extension ImageRecognitionStore{
    
    private func initializeSubs(){
        $image
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] image in
                if let img = image{
                    do{
                        try self?.tryRecognizeImage(image: img)
                    }
                    catch{
                        print(error)
                    }
                }
            }
            .store(in: &subscribtions)
    }
}
