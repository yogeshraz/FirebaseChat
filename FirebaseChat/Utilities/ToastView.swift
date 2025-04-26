//
//  t.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 22/04/25.
//

import SwiftUI

struct ToastView: View {
    var message: String
    @Binding var isPresented: Bool

    var body: some View {
        Text(message)
            .font(.body)
            .fontWeight(.medium)
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .center)
            .offset(y: isPresented ? 0 : 100)  // Move off-screen when not presented
            .animation(.easeInOut(duration: 0.5), value: isPresented)  // Animate toast
            .onAppear {
                // Dismiss toast after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.isPresented = false
                    }
                }
            }
    }
}
