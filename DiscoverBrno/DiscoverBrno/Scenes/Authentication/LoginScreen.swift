//
//  LoginScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 06.01.2023.
//

import SwiftUI

struct LoginScreen: View {
    
    @StateObject private var store: LoginStore
    @Binding private var parentState: ContentStore.State
    
    @State var firstDisplayed = true
    
    init(di: DiContainer, parentState: Binding<ContentStore.State>) {
        self._store = StateObject(wrappedValue: di.loginStore)
        self._parentState = parentState
    }
    
    var body: some View {
        VStack{
            switch store.state{
            case .start:
                loginContent
            case .idle:
                loginContent
            case .loading:
                ProgressView()
                    .frame(maxHeight: .infinity)
            }
        }
        .padding()
        
    }
    
    @ViewBuilder
    var loginContent: some View{
        ScrollView(.vertical){
            VStack{
                image
                loginForm
            }
        }
        .padding(.horizontal, 5)
    }
    
    @ViewBuilder
    var image: some View{
        Image(uiImage: UIImage.getByAssetName(assetName: "discoverBrnoLogo"))
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
    }
    
    
    @ViewBuilder
    var loginForm: some View{
        VStack{
            DBTextField(title: String(localized: "email"), text: $store.email, keyboardType: .emailAddress)
            DBSecureField(title: String(localized: "password"), text: $store.password)
                .onTapGesture {
                    firstDisplayed = false
                }
        
            if !store.errorMessage.isEmpty && !firstDisplayed{
                Text(store.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            DBButton(text: String(localized: "login")){
                Task{
                    do{
                        try await store.loginUser()
                    }
                    catch AuthenticationError.loginFailed {
                        store.errorMessage = String(localized: "loggingInFailed")
                        store.state = .idle
                    }
                }
            }
            .disabled(!store.credentialsValid)
            .padding(.vertical, 5)
            
            Button(String(localized: "registerNewUser")){
                parentState = .registration
            }
            .padding(.top, 5)
            
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(di: DiContainer(), parentState: .constant(.login))
    }
}
