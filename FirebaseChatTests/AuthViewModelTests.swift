//
//  AuthViewModelTests.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 24/04/25.
//

import XCTest
import Firebase
@testable import FirebaseChat // Your app module name

final class AuthViewModelTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    func testSignUpAndLoginFlow() async throws {
        let vm = await AuthViewModel()
        let uuid = UUID().uuidString.prefix(8)
        let email = "test\(uuid)@example.com"
        let password = "123456"
        let fullName = "Test User"

        // Sign up
        await vm.signUp(email: email, password: password, fullName: fullName)
        
        // Wait a second to let Firebase register the user
        try await Task.sleep(nanoseconds: 1_000_000_000)

        let userAfterSignUp = await MainActor.run { vm.user }
        let errorAfterSignUp = await MainActor.run { vm.errorMessage }
        XCTAssertNotNil(userAfterSignUp, "User should be set after signup")
        XCTAssertNil(errorAfterSignUp, "Error message should be nil after successful signup")
        
        // Logout
        await vm.logout()
        let userAfterLogout = await MainActor.run { vm.user }
        XCTAssertNil(userAfterLogout, "User should be nil after logout")

        // Login
        await vm.login(email: email, password: password)
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let userAfterLogin = await MainActor.run { vm.user }
        let errorAfterLogin = await MainActor.run { vm.errorMessage }
        XCTAssertNotNil(userAfterLogin, "User should be set after login")
        XCTAssertNil(errorAfterLogin, "Error message should be nil after successful login")
    }
}
