//
//  CoordinatorView.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import SwiftUI
import SwiftUICoordinator

enum MainCoordinatorViews: Coordinatable {
    var id: UUID {.init() }
    
    case main
    case login
    case signup
    case chat
    case chatDetail(userId: String, userName: String)
    
    var body: some View {
        switch self {
        case .main:
            SplashView()
        case .login:
            LoginView()
        case .signup:
            SignupView()
        case .chat:
            ChatListView()
        case .chatDetail(let userId, let userName):
            ChatDetailView(userId: userId, userName: userName)
        }
    }
}
