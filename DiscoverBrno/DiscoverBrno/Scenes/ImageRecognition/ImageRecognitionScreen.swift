//
//  ImageRecognitionScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 12.01.2023.
//

import SwiftUI
import Combine
import RealmSwift

struct ImageRecognitionScreen: View {
    private let di: DiContainer
    private let subscribtions = Set<AnyCancellable>()
    
    @StateObject var store: ImageRecognitionStore
    @State var cameraPresented: Bool = true
    
    @ObservedResults(DiscoveredLandmark.self)
    var alreadyDiscovered
    
    
    init(di: DiContainer) {
        self.di = di
        self._store = StateObject(wrappedValue: di.imageRecognitionStore)
    }
    
    var body: some View {
        if cameraPresented{
            ImagePicker(isPresented: $cameraPresented, image: $store.image)
                .ignoresSafeArea(.all)
                .onAppear{
                    store.resetResultAnimation()
                }
        }
        else {
            ScrollView(.vertical){
                image
                    .opacity(store.contentOpacity)
                    .animation(.linear(duration: 0.3), value: store.contentOpacity)
                content
                    .offset(y: store.contentYOffset)
                    .opacity(store.contentOpacity)
                    .animation(.easeOut(duration: 0.3), value: store.contentYOffset)
                    .animation(.linear(duration: 0.3), value: store.contentOpacity)
            }
            .onAppear{
                store.startResultAnimation()
            }
            .navigationTitle(String(localized: "discover"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    var image: some View{
        if let takenImage = store.image{
            Image(uiImage: takenImage)
                .resizable()
                .scaledToFill()
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .cornerRadius(20)
        }
        else {
            Image(systemName: "questionmark")
                .resizable()
                .scaledToFit()
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: .infinity)
                .padding(100)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(20)
        }
    }
    
    @ViewBuilder
    var content: some View{
        ZStack{
            VStack{
                cameraButton
                    .zIndex(1)
                ZStack(alignment: .top){
                    VStack{
                        switch store.state{
                        case .failedToSave, .landmarkAlreadyDiscovered, .failedToProcessImage:
                            errorMessage
                        case .imageNotRecognized:
                            notRecognized
                        case .newLandmarkDiscovered:
                            successContent(discovered: store.discoveredLandmark!)
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.top, 50)
                    .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity)
                .background(.background)
                .cornerRadius(20)
            }
        }
        .offset(y: -150)
    }
    
    func successContent(discovered: DiscoveredLandmark) -> some View{
        VStack{
            congratulations
            Text(String(localized: "youHaveDiscovered"))
                .font(.title3)
                .padding(.vertical, 10)
            Text(discovered.landmark?.name ?? "")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            DBNavigationButton(text: String(localized: "goToDetail"), destination: DiscoveredDetailScreen(di: di, discoveredLandmark: discovered))
            
            NavigationLink{
                RewardARScreen(discoveredLandmark: discovered)
            } label: {
                Text(String(localized: "showReward"))
                    .foregroundColor(.accentColor)
            }
        }
    }
}




// MARK: Components
extension ImageRecognitionScreen{
    
    @ViewBuilder
    var errorMessage: some View{
        Text(store.errorMessage)
            .font(.title3)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .fontWeight(.bold)
            .padding(.vertical, 20)
    }
    
    @ViewBuilder
    var congratulations: some View{
        Image(uiImage: UIImage.getByAssetName(assetName: "congratulations"))
            .resizable()
            .scaledToFit()
            .aspectRatio(1, contentMode: .fill)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 70)
    }
    
    @ViewBuilder
    var notRecognized: some View{
        Image(uiImage: UIImage.getByAssetName(assetName: "landmarkNotRecognized"))
            .resizable()
            .scaledToFit()
            .aspectRatio(1, contentMode: .fill)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 70)
            .padding(.vertical, 20)
    }
    
    @ViewBuilder
    var cameraButton: some View{
        Button{
            cameraPresented.toggle()
        } label: {
            ZStack(alignment: .center){
                Circle()
                    .foregroundColor(.accentColor)
                    .frame(width: 90, height: 90)
                Circle()
                    .foregroundColor(.onAccent)
                    .frame(width: 70, height: 70)
                Image(systemName: "camera.viewfinder")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.accentColor)
            }
            .offset(y: 52)
        }
    }
}






struct ImageRecognitionScreen_Previews: PreviewProvider {
    static var previews: some View {
        ImageRecognitionScreen(di: DiContainer())
    }
}
