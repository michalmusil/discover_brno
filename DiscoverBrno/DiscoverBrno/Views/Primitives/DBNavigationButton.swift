//
//  DBNavigationLink.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 15.01.2023.
//

import SwiftUI

struct DBNavigationButton: View {
    @Environment(\.isEnabled)
    var isEnabled
    
    let destination: AnyView
    
    @State var text: String
    
    init(text: String,  destination: any View) {
        self.text = text
        self.destination = AnyView(destination)
    }
    
    var body: some View {
        NavigationLink{
            destination
        } label: {
            ZStack{
                Rectangle()
                    .foregroundColor(isEnabled ? .accentColor : .disabled)
                Text(text)
                    .font(.title3)
                    .colorInvert()
                    .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .cornerRadius(10)
        }
    }
}

struct DBNavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        DBNavigationButton(text: "Na text", destination: Text("sdfa"))
    }
}
