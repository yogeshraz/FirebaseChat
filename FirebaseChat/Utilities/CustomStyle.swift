//
//  CapsuleButtonStyle.swift
//  TransportApp
//
//  Created by Yogesh Raj on 23/03/25.
//

import SwiftUI

struct CommonButtonStyle: ButtonStyle {
    var bgColor: Color = .primaryColor
    var textColor: Color = .white
    var hasBorder: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(textColor)
            .padding()
            .frame(maxWidth: .infinity)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .background(bgColor)
            .cornerRadius(12)
            .shadow(radius: 2)
    }
}
