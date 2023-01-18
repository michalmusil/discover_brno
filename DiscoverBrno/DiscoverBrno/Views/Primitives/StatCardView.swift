//
//  StatCardView.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 18.01.2023.
//

import SwiftUI

struct StatCardView: View {
    
    let titleText: String
    @Binding var value: String
    
    var body: some View {
        VStack{
            Text(titleText)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.center)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.onAccent)
                .padding(.top, 15)
            
            Text(value)
                .lineLimit(1)
                .font(.system(size: 30))
                .fontWeight(.bold)
                .foregroundColor(.onAccent)
                .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity)
        .background(BackgroundGradient())
        .cornerRadius(15)
        .shadow(color: .shadowColor, radius: 4)
    }
}

struct StatCardView_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            StatCardView(titleText: "Number of values", value: .constant("29"))
            StatCardView(titleText: "Number of values in a row", value: .constant("32127"))
        }
        .padding(.horizontal, 8)
    }
}
