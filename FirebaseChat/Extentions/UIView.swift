//
//  UIView.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 26/04/25.
//

import SwiftUI

// MARK: - Helpers
extension View {
    func dividerAbove() -> some View {
        VStack(spacing: 0) {
            Divider()
            self
        }
    }
}
