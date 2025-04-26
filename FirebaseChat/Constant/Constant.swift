//
//  Constant.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//


enum firebaseCollection: RawRepresentable {
    case chatRooms
    case users
    case chatRoomMessages(roomId: String)
    case typingStatus(roomId: String)
    
    var rawValue: String {
        switch self {
        case .chatRooms:
            return "chatRooms"
        case .users:
            return "users"
        case .chatRoomMessages(let roomId):
            return "chatRooms/\(roomId)/messages"
        case .typingStatus(roomId: let roomId):
            return "chatRooms/\(roomId)/typingStatus"
        }
    }

    init?(rawValue: String) {
        return nil 
    }
}
