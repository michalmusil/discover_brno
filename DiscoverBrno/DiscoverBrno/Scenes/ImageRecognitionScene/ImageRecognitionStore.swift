//
//  ImageRecognitionStore.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 12.01.2023.
//

import Foundation
import SwiftUI

final class ImageRecognitionStore: ObservableObject{
    
    @Published var realmManager: RealmManager
    @Published var image: UIImage? = nil
    
    init(realmManager: RealmManager) {
        self.realmManager = realmManager
    }
}
