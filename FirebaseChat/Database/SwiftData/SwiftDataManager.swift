//
//  SwiftDataManager.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 23/04/25.
//

import Foundation
import SwiftData

class SwiftDataManager {
    static let shared = SwiftDataManager()

    private let container: ModelContainer

    private init() {
        let schema = Schema([LocalMessage.self, LocalUser.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        container = try! ModelContainer(for: schema, configurations: [config])
    }

    var context: ModelContext {
        ModelContext(container)
    }

    // MARK: - Save Message
    func saveMessage(_ messages: [MessageModel]) {
        for message in messages {
            // Check if already saved
            if !messageExists(id: message.id) {
                let local = LocalMessage(
                    id: message.id,
                    text: message.text,
                    senderId: message.senderId,
                    receiverId: message.receiverId,
                    timestamp: message.timestamp,
                    status: message.status.rawValue
                )
                context.insert(local)
            }
        }
        try? context.save()
    }

    private func messageExists(id: String) -> Bool {
        let predicate = #Predicate<LocalMessage> { $0.id == id }
        let descriptor = FetchDescriptor<LocalMessage>(predicate: predicate)
        return (try? context.fetch(descriptor).isEmpty == false) ?? false
    }

    // MARK: - Fetch Messages
    func fetchMessages() -> [MessageModel] {
        let fetchDescriptor = FetchDescriptor<LocalMessage>()
        let results = (try? context.fetch(fetchDescriptor)) ?? []

        return results.map {
            MessageModel(
                id: $0.id,
                text: $0.text,
                senderId: $0.senderId,
                receiverId: $0.receiverId,
                timestamp: $0.timestamp,
                status: MessageStatus(rawValue: $0.status) ?? .sent
            )
        }
    }

    // MARK: - Save Users
    func saveUsers(_ users: [UserModel]) {
        for user in users {
            if !userExists(userId: user.userId) {
                let local = LocalUser(
                    userId: user.userId,
                    username: user.username,
                    email: user.email,
                    createdAt: user.createdAt
                )
                context.insert(local)
            }
        }
        try? context.save()
    }

    private func userExists(userId: String) -> Bool {
        let predicate = #Predicate<LocalUser> { $0.userId == userId }
        let descriptor = FetchDescriptor<LocalUser>(predicate: predicate)
        return (try? context.fetch(descriptor).isEmpty == false) ?? false
    }

    // MARK: - Fetch Users
    func fetchUsers() -> [UserModel] {
        let fetchDescriptor = FetchDescriptor<LocalUser>()
        let results = (try? context.fetch(fetchDescriptor)) ?? []

        return results.map {
            UserModel(
                userId: $0.userId,
                username: $0.username,
                email: $0.email,
                createdAt: $0.createdAt
            )
        }
    }
}
