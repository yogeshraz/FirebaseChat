//
//  LocalMessage.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 23/04/25.
//

import Foundation
import SwiftData

@Model
class LocalMessage {
    @Attribute(.unique) var id: String
    var text: String
    var senderId: String
    var receiverId: String
    var timestamp: Date
    var status: String

    init(id: String, text: String, senderId: String, receiverId: String, timestamp: Date, status: String) {
        self.id = id
        self.text = text
        self.senderId = senderId
        self.receiverId = receiverId
        self.timestamp = timestamp
        self.status = status
    }
}
