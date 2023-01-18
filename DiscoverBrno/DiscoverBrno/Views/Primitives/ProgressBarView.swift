//
//  ProgressBarView.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 17.01.2023.
//

import SwiftUI

struct ProgressBarView: View {
    
    // value should be from between 0.0 and 1.0
    @Binding var progressValue: Float
    private var barColor: Color
    
    init(progressValue: Binding<Float>, barColor: Color = .green) {
        self._progressValue = progressValue
        self.barColor = barColor
    }
    
    var body: some View {
        GeometryReader{ parentFrame in
            ZStack(alignment: .leading){
                Rectangle()
                    .frame(width: parentFrame.size.width, height: parentFrame.size.height)
                    .foregroundColor(barColor)
                    .opacity(0.3)
                    .clipShape(Capsule())
                ZStack(alignment: .trailing){
                    Rectangle()
                        .frame(height: parentFrame.size.height)
                        .frame(width: (parentFrame.size.width * CGFloat(progressValue)))
                        .foregroundColor(barColor)
                        .clipShape(Capsule())
                        .animation(.linear, value: progressValue)
                    Text("\(String(Int(progressValue*100)))%")
                        .foregroundColor(.onAccent)
                        .font(.subheadline)
                        .padding(.trailing, 5)
                }
            }
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            ProgressBarView(progressValue: .constant(0.23))
        }
        .frame(maxHeight: 40)
    }
}
