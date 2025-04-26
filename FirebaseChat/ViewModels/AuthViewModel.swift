//
//  AuthViewModel.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    init() {
        self.user = FirebaseAuthService.shared.currentUser
    }
    
    func signUp(email: String, password: String, fullName: String) {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let user = try await FirebaseAuthService.shared.signUp(
                    email: email,
                    password: password
                )
                self.user = user
                
                let newUser = UserModel(userId: user.uid, username: fullName, email: email)
                try await FirestoreService.shared.saveDocument(to: .users, data: newUser, withId: user.uid)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func login(email: String, password: String) {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let user = try await FirebaseAuthService.shared.signIn(
                    email: email,
                    password: password
                )
                self.user = user
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func logout() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                try FirebaseAuthService.shared.signOut()
                self.user = nil
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func currentUser() -> User? {
        return FirebaseAuthService.shared.currentUser
    }
}
