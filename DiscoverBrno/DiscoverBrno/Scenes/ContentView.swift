//
//  ContentView.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 05.01.2023.
//

import SwiftUI

struct ContentView: View {
    private let di: DiContainer
    
    @StateObject var store: ContentStore
    
    init(di: DiContainer){
        self.di = di
        self._store = StateObject(wrappedValue: di.contentStore)
    }
    
    var body: some View {
        if store.userLoggedIn {
            appNavigation
        }
        else {
            
            switch store.state{
            case .login:
                LoginScreen(di: di, parentState: $store.state)
            case .registration:
                Text("Registration")
            }
            
        }
    }
    
    @ViewBuilder
    var appNavigation: some View{
        Text("smrdim")
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(di: DiContainer())
    }
}
