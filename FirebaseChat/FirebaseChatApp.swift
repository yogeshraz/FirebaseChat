//
//  FirebaseChatApp.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import SwiftUI
import SwiftUICoordinator
import FirebaseCore

@main
struct FirebaseChatApp: App {
    init() {
        // Initialize Firebase when the app starts
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            CoordinatorStack(MainCoordinatorViews.main)
                .preferredColorScheme(.light)
        }
    }
}

