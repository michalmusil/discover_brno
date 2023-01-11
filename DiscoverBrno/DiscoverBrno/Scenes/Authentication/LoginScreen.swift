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
    
    init(di: DiContainer, parentState: Binding<ContentStore.State>) {
        self._store = StateObject(wrappedValue: di.loginStore)
        self._parentState = parentState
    }
    
    var body: some View {
        Group{
            switch store.state{
            case .start:
                loginForm
            case .idle:
                loginForm
            case .loading:
                ProgressView()
            }
        }
        .padding()
        .navigationTitle("Log in")
        .navigationBarTitleDisplayMode(.large)
        
    }
    
    
    @ViewBuilder
    var loginForm: some View{
        VStack{
            TextField("E-mail", text: $store.email)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 30)
            SecureField("Password", text: $store.password)
                .autocorrectionDisabled(true)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 30)
        
            if !store.errorMessage.isEmpty{
                Text(store.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button{
                Task{
                    do{
                        try await store.loginUser()
                    }
                    catch AuthenticationError.loginFailed {
                        store.errorMessage = "Logging in failed"
                        store.state = .idle
                    }
                }
            } label: {
                Text("Log in")
                    .font(.title3)
                    .frame(minWidth: 200)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .background(store.credentialsValid ? .blue : .gray)
                    .cornerRadius(10)
                    .padding(.top, 12)
            }
            .disabled(!store.credentialsValid)
            
            Button("New user"){
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
