//
//  DBTextField.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 14.01.2023.
//

import SwiftUI

struct DBTextField: View {
    
    @State var title: String
    @Binding var text: String
    
    private var keyBoardType: UIKeyboardType
    
    init(title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) {
        self.title = title
        self._text = text
        self.keyBoardType = keyboardType
    }
    
    
    var body: some View {
        TextField(title, text: $text)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .keyboardType(keyBoardType)
            .textFieldStyle(.roundedBorder)
    }
}

struct DBTextField_Previews: PreviewProvider {
    static var previews: some View {
        DBTextField(title: "Sample text", text: .constant(""))
    }
}
