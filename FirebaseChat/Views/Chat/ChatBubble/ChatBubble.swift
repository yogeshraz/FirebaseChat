//
//  ChatBubble.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import SwiftUI

struct ChatBubble: View {
    let message: MessageModel
    let isCurrentUser: Bool
    @State private var appear = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        ChatBubbleShape(isCurrentUser: isCurrentUser)
                            .fill(isCurrentUser ? Color.sentBubbleColor : Color(.systemGray5))
                    )
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.70, alignment: isCurrentUser ? .trailing : .leading)
                    .scaleEffect(appear ? 1 : 0.8)
                    .opacity(appear ? 1 : 0)
                    .shadow(color: .black.opacity(0.05), radius: 1, x: 1, y: 1)
                    .onAppear {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            appear = true
                        }
                    }
                
                HStack(spacing: 4) {
                    Text(message.timestamp.formattedTime())
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    // ✅ Show ticks for sent messages (only for current user)
                    if isCurrentUser {
                        Image(systemName: message.status == .delivered ? "checkmark.circle.fill" : "checkmark")
                            .font(.caption2)
                            .foregroundColor(message.status == .delivered ? .blue : .gray)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
            
            if isCurrentUser {
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, 0)   // minimal padding
        .padding(.vertical, 2)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: message.id)
    }
}
