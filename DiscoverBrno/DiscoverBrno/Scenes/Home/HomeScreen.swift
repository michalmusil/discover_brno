//
//  HomeScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import SwiftUI

struct HomeScreen: View {
    private let di: DiContainer
    
    init(di: DiContainer){
        self.di = di
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(di: DiContainer())
    }
}
