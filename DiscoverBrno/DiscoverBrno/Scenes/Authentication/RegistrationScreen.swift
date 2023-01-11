//
//  RegistrationScreen.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 11.01.2023.
//

import SwiftUI

struct RegistrationScreen: View {
    @StateObject var store: RegistrationStore
    @Binding var parentState: ContentStore.State
    
    init(di: DiContainer, parentState: Binding<ContentStore.State>) {
        self._store = StateObject(wrappedValue: di.registrationStore)
        self._parentState = parentState
    }
    
    var body: some View {
        Group{
            switch store.state{
            case .start:
                registrationForm
            case .idle:
                registrationForm
            case .loading:
                ProgressView()
            }
        }
        .padding()
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.large)
        
    }
    
    
    @ViewBuilder
    var registrationForm: some View{
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
                        let credentials = try await store.registerUser()
                        try await store.loginUser(email: credentials.email, password: credentials.password)
                    }
                    catch AuthenticationError.registrationFailed {
                        store.errorMessage = "Registration failed"
                        store.state = .idle
                    }
                    catch AuthenticationError.loginFailed {
                        store.errorMessage = "Registration was successful, but logging you in failed"
                        store.state = .idle
                    }
                }
            } label: {
                Text("Register")
                    .font(.title3)
                    .frame(minWidth: 200)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .background(store.credentialsValid ? .blue : .gray)
                    .cornerRadius(10)
                    .padding(.top, 12)
            }
            .disabled(!store.credentialsValid)
            
            Button("Log in"){
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
