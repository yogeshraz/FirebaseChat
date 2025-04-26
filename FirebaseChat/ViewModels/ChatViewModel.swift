//
//  ChatViewModel.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 22/04/25.
//

import SwiftUI
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [MessageModel] = []
    @Published var typingStatusSent = false
    
    private var listener: ListenerRegistration?
    private let service = FirestoreService.shared
    private let authService = FirebaseAuthService.shared
    
    deinit {
        listener?.remove()
    }
    
    // MARK: - Public Methods
    func sendMessage(_ message: MessageModel, roomId: String) async {
        do {
            try await service.saveDocument(
                to: .chatRoomMessages(roomId: roomId),
                data: message,
                withId: message.id
            )
            await markMessageAsSent(message, in: roomId)
        } catch {
            print("Failed to send message: \(error.localizedDescription)")
        }
    }
    
    func listenToMessages(roomId: String) {
        listener?.remove() // ensure no multiple listeners
        listener = service.listenCollection(from: .chatRoomMessages(roomId: roomId)) { [weak self] (messages: [MessageModel]) in
            guard let self = self else { return }
            
            let sorted = messages.sorted(by: { $0.timestamp < $1.timestamp })
            self.messages = sorted
            SwiftDataManager.shared.saveMessage(self.messages)
            
            Task {
                await self.updateDeliveredStatusIfNeeded(for: sorted, in: roomId)
            }
        }
    }
    
    // MARK: - Private Helpers
    private func markMessageAsSent(_ message: MessageModel, in roomId: String) async {
        do {
            try await service.updateDocument(
                in: .chatRoomMessages(roomId: roomId),
                id: message.id,
                data: ["status": MessageStatus.sent.rawValue]
            )
        } catch {
            print("Failed to update message status to sent: \(error.localizedDescription)")
        }
    }
    
    private func updateDeliveredStatusIfNeeded(for messages: [MessageModel], in roomId: String) async {
        guard let currentUserId = authService.currentUser?.uid else { return }
        for message in messages where message.receiverId == currentUserId && message.status != .delivered {
            await updateMessageStatusToDelivered(message, in: roomId)
        }
    }
    
    private func updateMessageStatusToDelivered(_ message: MessageModel, in roomId: String) async {
        do {
            try await service.updateDocument(
                in: .chatRoomMessages(roomId: roomId),
                id: message.id,
                data: ["status": MessageStatus.delivered.rawValue]
            )
        } catch {
            print("Failed to update message status to delivered: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Typing Indicator
    func setTypingStatus(isTyping: Bool, roomId: String) async {
        guard let userId = authService.currentUser?.uid else { return }

        do {
            try await service.updateDocument(
                in: .typingStatus(roomId: roomId),
                id: userId, // <-- each user's typing status is stored in a document named by their userId
                data: ["isTyping": isTyping]
            )
        } catch {
            print("Failed to update typing status: \(error.localizedDescription)")
        }
    }

    func listenToTypingStatus(roomId: String, currentUserId: String, onUpdate: @escaping (Bool) -> Void) {
        listener = FirestoreService.shared.listenTypingStatuses(roomId: roomId, onUpdate: { roomTypingStatus in
            guard let room = roomTypingStatus.first(where: { $0.id != currentUserId }) else { return }
            onUpdate(room.isTyping)
        })
    }
    
    // MARK: - Group Messages by Date
    var groupedMessages: [String: [MessageModel]] {
        Dictionary(grouping: messages, by: { ($0.timestamp.formattedDate()) })
    }
}
