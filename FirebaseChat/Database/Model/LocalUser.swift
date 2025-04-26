//
//  LocalUsers.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 23/04/25.
//

import Foundation
import SwiftData

@Model
class LocalUser {
    @Attribute(.unique) var userId: String
    var username: String
    var email: String
    var createdAt: Date

    init(userId: String, username: String, email: String, createdAt: Date = Date()) {
        self.userId = userId
        self.username = username
        self.email = email
        self.createdAt = createdAt
    }
}
