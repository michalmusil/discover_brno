//
//  BackgroundGradient.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 14.01.2023.
//

import Foundation
import SwiftUI

struct BackgroundGradient: View {
    
    let topLeftColor: Color
    let bottomRightColor: Color
    
    init(topLeftColor: Color = .appBackgroundGradientTop, bottomRightColor: Color = .appBackgroundGradientBottom) {
        self.topLeftColor = topLeftColor
        self.bottomRightColor = bottomRightColor
    }
    
    var body: some View {
        LinearGradient(
            gradient: .init(colors: [topLeftColor, bottomRightColor]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct BackgroundGradient_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundGradient()
    }
}
