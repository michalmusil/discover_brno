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
    @State var cameraPresented: Bool = false
    
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
        }
        else {
            ScrollView(.vertical){
                image
                content
            }
            .navigationTitle("New discovery")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    var image: some View{
        if let takenImage = store.image{
            Image(uiImage: takenImage)
                .resizable()
                .scaledToFill()
                .aspectRatio(1, contentMode: .fill)
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
                if !store.errorMessage.isEmpty{
                    Text(store.errorMessage)
                        .font(.title3)
                        .foregroundColor(.red)
                    Button{
                        cameraPresented = true
                    } label: {
                        Text("Try again")
                            .font(.title3)
                            .frame(minWidth: 250)
                            .padding(.vertical, 10)
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                            .padding(.top, 12)
                    }
                }
                else if let discovered = store.discoveredLandmark{
                    Text("🎉Congratulations!🎉")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("you have discovered: ")
                        .font(.title3)
                        .padding(.bottom, 10)
                    Text(discovered.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack{
                        Text(store.errorMessage)
                            .font(.title)
                            .foregroundColor(.red)
                        Button{
                            cameraPresented = true
                        } label: {
                            Text("Go to detail")
                                .font(.title3)
                                .frame(minWidth: 250)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .cornerRadius(10)
                                .padding(.top, 12)
                        }
                    }
                }
                else {
                    Button{
                        cameraPresented = true
                    } label: {
                        Text("Open camera")
                            .font(.title3)
                            .frame(minWidth: 250)
                            .padding(.vertical, 10)
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                            .padding(.top, 12)
                    }
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity)
        .background(.background)
        .cornerRadius(20)
        .offset(y: -50)
    }
}


// MARK: Reacting to discoveries
extension ImageRecognitionScreen{
    
}






struct ImageRecognitionScreen_Previews: PreviewProvider {
    static var previews: some View {
        ImageRecognitionScreen(di: DiContainer())
    }
}
