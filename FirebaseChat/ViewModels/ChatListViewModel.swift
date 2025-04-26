//
//  ChatListViewModel.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 22/04/25.
//

import Foundation
import FirebaseFirestore

@MainActor
class ChatListViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastMessages: [String: MessageModel] = [:]

    private var listener: ListenerRegistration?
    private let service = FirestoreService.shared
    private let authService = FirebaseAuthService.shared
    private var messageListeners: [String: ListenerRegistration] = [:]
    
    init() {
        listenToUsers()
    }

    deinit {
        listener?.remove()
        messageListeners.values.forEach { $0.remove() }
        messageListeners.removeAll()
        listener = nil
    }
    
    // MARK: - Listen to User List
    func listenToUsers() {
        guard let currentUserId = authService.currentUser?.uid else {
            self.errorMessage = "User not authenticated."
            return
        }

        isLoading = true
        
        listener = service.listenCollection(from: .users) { [weak self] (users: [UserModel]) in
            guard let self = self else { return }
            
            Task { @MainActor in
                self.users = users
                    .filter { $0.userId != currentUserId }
                    .sorted(by: { $0.createdAt > $1.createdAt })
                SwiftDataManager.shared.saveUsers(self.users)
                self.isLoading = false
            }
        }
    }
    
    func listenToLastMessages(roomId: String) {
        guard lastMessages[roomId] == nil, messageListeners[roomId] == nil else { return }

        let listener = service.listenLastDocument(
            from: .chatRoomMessages(roomId: roomId),
            sortedBy: "timestamp"
        ) { [weak self] (message: MessageModel?) in
            guard let self = self, let message = message else { return }
            DispatchQueue.main.async {
                self.lastMessages[roomId] = message
            }
        }
        messageListeners[roomId] = listener
    }
}
