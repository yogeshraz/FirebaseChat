//
//  MessageModel.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import Foundation
import FirebaseFirestore

struct MessageModel: Identifiable, Codable {
    var id: String
    var text: String
    var senderId: String
    var receiverId: String
    var timestamp: Date
    var status: MessageStatus
}

enum MessageStatus: String, Codable {
    case sent
    case delivered
}

struct ChatRoomModel: Codable, Identifiable {
    var id: String? = ""
    var participants: [String]
    var typingStatus: [String: Bool] = [:]

    enum CodingKeys: CodingKey {
        case participants
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var participants: [String] = []
        var typingStatus: [String: Bool] = [:]

        for key in container.allKeys {
            if key.stringValue == "participants" {
                participants = try container.decode([String].self, forKey: key)
            } else if key.stringValue.starts(with: "typingStatus.") {
                let userId = key.stringValue.replacingOccurrences(of: "typingStatus.", with: "")
                let value = try container.decode(Int.self, forKey: key)
                typingStatus[userId] = value == 1
            }
        }

        self.participants = participants
        self.typingStatus = typingStatus
    }

    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) { self.stringValue = stringValue }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }
}
