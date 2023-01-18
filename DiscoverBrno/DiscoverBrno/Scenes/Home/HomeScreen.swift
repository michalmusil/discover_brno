//
//  HomeScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import SwiftUI
import RealmSwift

struct HomeScreen: View {
    private let di: DiContainer
    
    @StateObject var store: HomeStore
    
    @ObservedResults(DiscoveredLandmark.self)
    var discovered
    
    init(di: DiContainer){
        self.di = di
        self._store = StateObject(wrappedValue: di.homeStore)
    }
    
    var body: some View {
        Group{
            switch store.state{
            case .loading:
                ProgressView()
            case .error:
                ErrorScreen(image: UIImage(named: "sadCroc")!, errorMessage: String(localized: "somethingWentWrong"))
            case .loaded:
                content
            }
        }
        .onAppear{
            store.updateStatistics()
        }
    }
    
    @ViewBuilder
    var content: some View{
        ScrollView(.vertical){
            VStack{
                statCards
                discoveriesList
            }
        }
        .padding(.horizontal, 5)
    }
}

// MARK: Components
extension HomeScreen{
    
    @ViewBuilder
    var statCards: some View{
        HStack{
            StatCardView(titleText: String(localized: "numberOfDiscovered"), value: $store.numberOfDiscoveredString)
            StatCardView(titleText: String(localized: "numberOfRemaining"), value: $store.numberOfRemainingString)
        }
    }
    
    @ViewBuilder
    var discoveriesList: some View{
        VStack(alignment: .leading){
            Text(String(localized: "discoveries"))
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            ScrollView(.horizontal){
                LazyHStack{
                    ForEach(discovered){ landmark in
                        if let discoverable = landmark.landmark{
                            AsyncImage(url: URL(string: discoverable.titleImageUrl),
                                       content: { image in image.resizable()},
                                       placeholder: { ProgressView() })
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .shadow(color: .shadowColor, radius: 2)
                            .padding(.horizontal, 2)
                        }
                    }
                }
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(di: DiContainer())
    }
}
