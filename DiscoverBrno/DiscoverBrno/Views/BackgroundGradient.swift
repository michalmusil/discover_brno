//
//  BackgroundGradient.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 14.01.2023.
//

import Foundation
import SwiftUI

struct BackgroundGradient: View {
    var body: some View {
        LinearGradient(
            gradient: .init(colors: [.appBackgroundGradientTop, .appBackgroundGradientBottom]),
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
