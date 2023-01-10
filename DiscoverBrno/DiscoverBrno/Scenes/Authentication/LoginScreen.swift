//
//  LoginScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 06.01.2023.
//

import SwiftUI

struct LoginScreen: View {
    
    @StateObject var store: LoginStore = LoginStore()
    
    @Binding var parentState: ContentStore.State
    
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
            if !store.emailError.isEmpty && store.state != .start{
                Text(store.emailError)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            SecureField("Password", text: $store.password)
                .autocorrectionDisabled(true)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 30)
            if !store.passwordError.isEmpty && store.state != .start{
                Text(store.passwordError)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button{
                Task{
                    do{
                        try await store.loginUser()
                    } catch{
                        store.state = .idle
                    }
                }
            } label: {
                Text("Log in")
                    .font(.title3)
                    .frame(minWidth: 200)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(10)
                    .padding(.top, 12)
            }
            
            Button("New user"){
                parentState = .registration
            }
            .padding(.top, 5)
            
        }
    }
    
    
    private func goBack(){
        
    }
    
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(parentState: .constant(.login))
    }
}
