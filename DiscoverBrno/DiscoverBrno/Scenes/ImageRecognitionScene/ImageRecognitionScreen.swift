//
//  ImageRecognitionScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 12.01.2023.
//

import SwiftUI

struct ImageRecognitionScreen: View {
    private let di: DiContainer
    
    @StateObject var store: ImageRecognitionStore
    
    @State var cameraPresented: Bool = true
    
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
            imagePickerScreenContent
        }
    }
    
    @ViewBuilder
    var imagePickerScreenContent: some View{
        ScrollView(.vertical){
            VStack{
                if let takenImage = store.image{
                    Image(uiImage: takenImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                }
                else {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.accentColor)
                        .background(.background)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                }
                
                Text(store.landmarkName)
                
                Button{
                    cameraPresented = true
                } label: {
                    Text("Open camera")
                        .font(.title3)
                        .frame(minWidth: 200)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding(.top, 12)
                }
            }
        }
        .padding(.horizontal, 20)
        .navigationTitle("New discovery")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ImageRecognitionScreen_Previews: PreviewProvider {
    static var previews: some View {
        ImageRecognitionScreen(di: DiContainer())
    }
}
