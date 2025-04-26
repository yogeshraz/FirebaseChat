
//
//  User.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//
import Foundation
import FirebaseFirestore

// User Model
struct UserModel: Identifiable, Codable, Equatable {
    @DocumentID var id: String? // Firestore automatically generates the document ID.
    var userId: String
    var username: String
    var email: String
    var createdAt: Date // Timestamp for when the user is created
    
    // Default initializer for a new user
    init(userId: String, username: String, email: String, createdAt: Date = Date()) {
        self.userId = userId
        self.username = username
        self.email = email
        self.createdAt = createdAt
    }
    
    // Add the static mock function for testing
      static func mock(id: String = UUID().uuidString, createdAt: Date = Date()) -> UserModel {
          return UserModel(
              userId: id,
              username: "User \(id.prefix(4))",
              email: "\(id)@test.com",
              createdAt: createdAt
          )
      }
}
