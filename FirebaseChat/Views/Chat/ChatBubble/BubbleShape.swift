//
//  ChatBubbleShape.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import SwiftUI

struct ChatBubbleShape: Shape {
    let isCurrentUser: Bool
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [
                                    .topLeft,
                                    .topRight,
                                    isCurrentUser ? .bottomLeft : .bottomRight
                                ],
                                cornerRadii: CGSize(width: 16, height: 16))
        return Path(path.cgPath )
    }
}
