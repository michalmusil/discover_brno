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
        NavigationView{
            if store.userLoggedIn {
                appNavigation
            }
            else {
                Group{
                    switch store.state{
                    case .login:
                        LoginScreen(di: di, parentState: $store.state)
                            .transition(AnyTransition.scale.animation(.easeInOut(duration: 0.2)))
                    case .registration:
                        RegistrationScreen(di: di, parentState: $store.state)
                            .transition(AnyTransition.scale.animation(.easeInOut(duration: 0.2)))
                    }
                }
                
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
