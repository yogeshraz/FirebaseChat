//
//  UIColor.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import SwiftUICore

extension Color {
    static let primaryColor = Color(hex: "#25D366")
    static let bgColor = Color(hex: "#F5F7FA")
    static let sentBubbleColor = Color(hex: "#DCF8C6")
    
    
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = ((int >> 24) & 0xff, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
