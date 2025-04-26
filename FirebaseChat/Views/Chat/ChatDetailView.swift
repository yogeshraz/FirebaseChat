//
//  ChatDetailView.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import SwiftUI

struct ChatDetailView: View {
    var userId: String
    var userName: String
    var currentUser = FirebaseAuthService.shared.currentUser
    
    @State private var newMessage = ""
    @StateObject private var viewModel = ChatViewModel()
    
    @State private var visibleDate: String = ""
    @State private var showDateToast = false
    @State private var isOtherUserTyping = false
    @State private var typingDebounceWorkItem: DispatchWorkItem?
    
    private var currentUserId: String {
        currentUser?.uid ?? ""
    }
    
    private var roomId: String {
        [userId, currentUserId].sorted().joined(separator: "_")
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                chatMessagesScrollView
                typingStatusView
                messageInputArea
            }
            floatingDateToast
        }
        .navigationTitle(userName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: setup)
        .onChange(of: newMessage) { _, newValue in
            handleTypingChange(newValue)
        }
    }
}

// MARK: - Components
private extension ChatDetailView {
    
    var chatMessagesScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.groupedMessages.keys.sorted(), id: \.self) { date in
                        messageSection(for: date)
                    }
                    Spacer()
                        .frame(height: 1)
                }
                .padding()
            }
            .onChange(of: viewModel.messages.count) {
                scrollToBottom(proxy: proxy)
            }
        }
    }
    
    func messageSection(for date: String) -> some View {
        Section(
            header: Text(Date().formattedSectionHeader(from: date))
                .font(.headline)
                .padding(.top)
                .background(
                    GeometryReader { _ in
                        Color.clear
                            .onAppear { updateVisibleDate(date) }
                    }
                )
        ) {
            ForEach(viewModel.groupedMessages[date] ?? []) { msg in
                ChatBubble(message: msg, isCurrentUser: msg.senderId == currentUserId)
                    .id(msg.id)
            }
        }
    }
    
    var messageInputArea: some View {
        HStack(spacing: 8) {
            TextField("Message...", text: $newMessage)
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.primaryColor)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .dividerAbove()
    }
    
    var typingStatusView: some View {
        Group {
            if isOtherUserTyping {
                HStack(spacing: 6) {
                    Text("\(userName) is typing")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TypingAnimationDots()
                }
                .padding(.horizontal)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isOtherUserTyping)
    }
    
    struct TypingAnimationDots: View {
        @State private var isAnimating = false
        
        var body: some View {
            HStack(spacing: 4) {
                ForEach(0..<3) { i in
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(.gray)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .animation(.easeInOut(duration: 0.6).repeatForever().delay(Double(i) * 0.2), value: isAnimating)
                }
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
    
    var floatingDateToast: some View {
        Group {
            if showDateToast {
                Text(visibleDate)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .shadow(radius: 3)
                    .padding(.top, 12)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showDateToast)
    }
}

// MARK: - Actions
private extension ChatDetailView {
    
    func setup() {
        guard !roomId.isEmpty, !currentUserId.isEmpty else { return }
        viewModel.listenToMessages(roomId: roomId)
        viewModel.listenToTypingStatus(roomId: roomId, currentUserId: currentUserId) { status in
            isOtherUserTyping = status
        }
    }
    
    func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !currentUserId.isEmpty
        else { return }
        
        let message = MessageModel(
            id: UUID().uuidString,
            text: newMessage,
            senderId: currentUserId,
            receiverId: userId,
            timestamp: Date(),
            status: .sent
        )
        
        Task {
            await viewModel.sendMessage(message, roomId: roomId)
            await viewModel.setTypingStatus(isTyping: false, roomId: roomId)
            newMessage = ""
        }
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            withAnimation(.easeOut(duration: 0.4)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
    
    func updateVisibleDate(_ date: String) {
        let formatted = Date().formattedSectionHeader(from: date)
        guard visibleDate != formatted else { return }
        
        visibleDate = formatted
        showDateToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showDateToast = false
            }
        }
    }
    
    func handleTypingChange(_ text: String) {
        guard !currentUserId.isEmpty else { return }
        
        // Cancel any previous debounce work
        typingDebounceWorkItem?.cancel()
        
        // If user clears text, send false immediately
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Task {
                await viewModel.setTypingStatus(isTyping: false, roomId: roomId)
            }
            return
        }
        
        // Send typing status true (but debounce frequent calls)
        if viewModel.typingStatusSent == false {
            viewModel.typingStatusSent = true
            Task {
                await viewModel.setTypingStatus(isTyping: true, roomId: roomId)
            }
        }
        
        // Schedule debounce to set typing false
        let workItem = DispatchWorkItem {
            Task {
                viewModel.typingStatusSent = false
                await viewModel.setTypingStatus(isTyping: false, roomId: roomId)
            }
        }
        
        typingDebounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: workItem)
    }
}
