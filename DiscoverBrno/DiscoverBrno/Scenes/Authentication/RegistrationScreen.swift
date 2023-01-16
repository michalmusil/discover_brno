//
//  RegistrationScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import SwiftUI

struct RegistrationScreen: View {
    @StateObject private var store: RegistrationStore
    @Binding private var parentState: ContentStore.State
    
    @State var firstDisplayed = true
    
    init(di: DiContainer, parentState: Binding<ContentStore.State>) {
        self._store = StateObject(wrappedValue: di.registrationStore)
        self._parentState = parentState
    }
    
    var body: some View {
        ScrollView(.vertical){
            Group{
                switch store.state{
                case .start:
                    registrationContent
                case .idle:
                    registrationContent
                case .loading:
                    ProgressView()
                }
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.large)
        
    }
    
    @ViewBuilder
    var registrationContent: some View{
        VStack{
            image
            registrationForm
        }
        .padding(.horizontal, 5)
    }
    
    @ViewBuilder
    var image: some View{
        Image(uiImage: UIImage(named: "discoverBrnoLogo")!)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
    }
    
    
    @ViewBuilder
    var registrationForm: some View{
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
            
            DBButton(text: String(localized: "register")){
                Task{
                    do{
                        let credentials = try await store.registerUser()
                        try await store.loginUser(email: credentials.email, password: credentials.password)
                    }
                    catch AuthenticationError.registrationFailed {
                        store.errorMessage = String(localized: "registrationFailed")
                        store.state = .idle
                    }
                    catch AuthenticationError.loginFailed {
                        store.errorMessage = String(localized: "registrationSuccessButLoginFailed")
                        store.state = .idle
                    }
                }
            }
            .disabled(!store.credentialsValid)
            .padding(.vertical, 5)
            
            Button(String(localized: "login")){
                parentState = .login
            }
            .padding(.top, 5)
            
        }
    }
}

struct RegistrationScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationScreen(di: DiContainer(), parentState: .constant(.registration))
    }
}
