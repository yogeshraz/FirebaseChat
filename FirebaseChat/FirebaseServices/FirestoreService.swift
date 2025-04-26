//
//  FirebaseFirestore.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    private init() {}
    private let db = Firestore.firestore()
    
    // MARK: - Fetch All Documents
    func fetchCollection<T: Codable>(from collection: firebaseCollection) async throws -> [T] {
        let snapshot = try await db.collection(collection.rawValue).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: T.self) }
    }
    
    // MARK: - Save Document
    func saveDocument<T: Codable>(to collection: firebaseCollection, data: T, withId id: String? = nil) async throws {
        if let id = id {
            try db.collection(collection.rawValue).document(id).setData(from: data)
        } else {
            _ = try db.collection(collection.rawValue).addDocument(from: data)
        }
    }
    
    // MARK: - Update Document by ID
    func updateDocument<T: Codable>(in collection: firebaseCollection, id: String?, data: T) async throws {
        if let id = id {
            try db.collection(collection.rawValue).document(id).setData(from: data, merge: true)
        } else {
            _ = try db.collection(collection.rawValue).addDocument(from: data)
        }
        
    }
    
    // MARK: - Delete Document by ID
    func deleteDocument(from collection: String, id: String) async throws {
        try await db.collection(collection).document(id).delete()
    }
    
    // MARK: - Real-Time Listener
    func listenCollection<T: Codable>(from collection: firebaseCollection, onUpdate: @escaping ([T]) -> Void) -> ListenerRegistration {
        return db.collection(collection.rawValue).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Snapshot listener error: \(error?.localizedDescription ?? "Unknown error")")
                onUpdate([])
                return
            }
            
            let items = snapshot.documents.compactMap { try? $0.data(as: T.self) }
            onUpdate(items)
        }
    }
    
    // MARK: - Real-Time Listener Updated Or Added
    func listenCollectionUpdatedOrAdded<T: Codable>(from collection: firebaseCollection, onUpdate: @escaping ([T]) -> Void) -> ListenerRegistration {
        return db.collection(collection.rawValue).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Snapshot listener error: \(error?.localizedDescription ?? "Unknown error")")
                onUpdate([])
                return
            }
            
            // Filter documents that are updated or added
            let updatedItems = snapshot.documentChanges.filter { change in
                change.type == .modified || change.type == .added
            }.compactMap { change -> T? in
                return try? change.document.data(as: T.self)
            }
            
            // Notify with updated data only
            onUpdate(updatedItems)
        }
    }
    
    // MARK: - Real-Time Listener for Last Document
    func listenLastDocument<T: Codable>(from collection: firebaseCollection, sortedBy field: String, onUpdate: @escaping (T?) -> Void
    ) -> ListenerRegistration {
        return db.collection(collection.rawValue)
            .order(by: field, descending: true)
            .limit(to: 1)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    print("Snapshot listener error: \(error?.localizedDescription ?? "Unknown error")")
                    onUpdate(nil)
                    return
                }
                
                let latestItem = snapshot.documents.first.flatMap { document in
                    try? document.data(as: T.self)
                }
                onUpdate(latestItem)
            }
    }
    
    func listenTypingStatuses(roomId: String, onUpdate: @escaping ([TypingStatusModel]) -> Void) -> ListenerRegistration {
        return db.collection("chatRooms/\(roomId)/typingStatus")
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    print("🔥 Typing status listener error: \(error?.localizedDescription ?? "Unknown error")")
                    onUpdate([])
                    return
                }

                let statuses: [TypingStatusModel] = snapshot.documents.compactMap { doc in
                    var status = try? doc.data(as: TypingStatusModel.self)
                    status?.id = doc.documentID
                    return status
                }
                onUpdate(statuses)
            }
    }
}

struct TypingStatusModel: Codable, Identifiable {
    var id: String? = nil // userId
    var isTyping: Bool
}
