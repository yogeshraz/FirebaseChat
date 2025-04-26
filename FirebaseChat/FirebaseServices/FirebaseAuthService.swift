//
//  firebase.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthService {
    
    static let shared = FirebaseAuthService()
    private init() {}
    
    // MARK: - Sign Up
    func signUp(email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        guard let user = authResult.user as User? else {
            throw AuthError.unknown
        }
        return user
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        guard let user = authResult.user as User? else {
            throw AuthError.unknown
        }
        return user
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Current User
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    // MARK: - Error
    enum AuthError: LocalizedError {
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .unknown:
                return "An unknown authentication error occurred."
            }
        }
    }
}
