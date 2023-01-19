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
                ErrorScreen(image: UIImage.getByAssetName(assetName: "sadCroc"), errorMessage: String(localized: "somethingWentWrong"))
            case .noDiscoveries:
                welcomeScreen
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
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
                logoutButton
                    .padding(15)
                VStack{
                    image
                    statCards
                    progressionBar
                    discoveriesList
                }
                .padding(.horizontal, 10)
            }
        }
        
    }
    
    @ViewBuilder
    var welcomeScreen: some View{
        ScrollView(.vertical){
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
                logoutButton
                    .padding(15)
                VStack{
                    Image(uiImage: UIImage.getByAssetName(assetName: "welcome1"))
                        .resizable()
                        .scaledToFit()
                    
                    Image(uiImage: UIImage.getByAssetName(assetName: "welcome2"))
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 100)
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

// MARK: Components
extension HomeScreen{
    
    @ViewBuilder
    var logoutButton: some View{
        Button{
            store.logOut()
        } label: {
            ZStack(alignment: .center){
                Circle()
                    .foregroundColor(.accentColor)
                    .frame(width: 35, height: 35)
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.onAccent)
            }
        }
    }
    
    @ViewBuilder
    var image: some View{
        Image(uiImage: UIImage.getByAssetName(assetName: "discoverBrnoLogo"))
            .resizable()
            .scaledToFit()
            .padding(.vertical, 30)
    }
    
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
                            NavigationLink{
                                DiscoveredDetailScreen(di: di, discoveredLandmark: landmark)
                            } label: {
                                Image(uiImage: UIImage.getByAssetName(assetName: discoverable.imageAssetName))
                                    .resizable()
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
            .frame(maxHeight: 100)
        }
    }
    
    @ViewBuilder
    var progressionBar: some View{
        VStack(alignment: .leading){
            Text(String(localized: "overallProgress"))
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            ProgressBarView(progressValue: $store.progression)
                .frame(height: 30)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(di: DiContainer())
    }
}
