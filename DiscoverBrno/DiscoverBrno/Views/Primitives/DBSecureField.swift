//
//  DBSecureField.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 14.01.2023.
//

import SwiftUI

struct DBSecureField: View {
    @State var title: String
    @Binding var text: String
    
    private var keyBoardType: UIKeyboardType
    
    init(title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) {
        self.title = title
        self._text = text
        self.keyBoardType = keyboardType
    }
    
    
    var body: some View {
        SecureField(title, text: $text)
            .autocorrectionDisabled(true)
            .keyboardType(keyBoardType)
            .textFieldStyle(.roundedBorder)
    }
}

struct DBSecureField_Previews: PreviewProvider {
    static var previews: some View {
        DBSecureField(title: "Sample secure", text: .constant(""))
    }
}
