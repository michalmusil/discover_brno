//
//  DiscoverBrnoApp.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 05.01.2023.
//

import SwiftUI

@main
struct DiscoverBrnoApp: App {
    private let diContainer = DiContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView(di: diContainer)
        }
    }
}
