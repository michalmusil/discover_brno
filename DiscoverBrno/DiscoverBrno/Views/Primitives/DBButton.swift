//
//  DiscoverBrnoButton.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 14.01.2023.
//

import SwiftUI

struct DBButton: View {
    @Environment(\.isEnabled)
    var isEnabled
    
    
    private let onTapGesture: () -> Void
    
    @State var text: String
    
    init(text: String, onTapGesture: @escaping () -> Void) {
        self.text = text
        self.onTapGesture = onTapGesture
    }
    
    var body: some View {
        Button{
            onTapGesture()
        } label: {
            ZStack{
                Rectangle()
                    .foregroundColor(isEnabled ? .accentColor : .disabled)
                Text(text)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .colorInvert()
                    .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .cornerRadius(10)
        }
    }
}

struct DiscoverBrnoButton_Previews: PreviewProvider {
    static var previews: some View {
        DBButton(text: "Tap me", onTapGesture: {})
    }
}
