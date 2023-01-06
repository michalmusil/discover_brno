//
//  ContentView.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 05.01.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var store = ContentStore()
    
    var body: some View {
        Group{
            switch store.state{
            case .login:
                LoginScreen(parentState: $store.state)
            case .registration:
                Text("Registration")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
