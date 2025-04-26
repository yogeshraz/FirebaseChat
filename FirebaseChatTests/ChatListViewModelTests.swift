//
//  ChatListViewModelTests.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 24/04/25.
//

import XCTest
import Firebase
@testable import FirebaseChat


@MainActor
final class ChatListViewModelTests: XCTestCase {
    var mockService: MockFirestoreService!
    var mockAuth: MockFirebaseAuthService!
    var viewModel: ChatListViewModel!

    override func setUp() {
        super.setUp()
        mockService = MockFirestoreService()
        mockAuth = MockFirebaseAuthService()
        viewModel = ChatListViewModel()
    }

    func testExcludesCurrentUser() {
        let expectation = self.expectation(description: "Users updated")
        
        mockService.simulateUserUpdate { users in
            self.viewModel.listenToUsers()
            XCTAssertEqual(self.viewModel.users.map(\.userId), ["userB"])
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }

    func testSortsByDate() {
        let expectation = self.expectation(description: "Users sorted by date")
        
        let older = UserModel.mock(id: "u1", createdAt: Date().addingTimeInterval(-100))
        let newer = UserModel.mock(id: "u2", createdAt: Date())
        
        mockService.simulateUserUpdate { users in
            self.viewModel.listenToUsers()
            XCTAssertEqual(self.viewModel.users.map(\.userId), ["u2", "u1"])
            expectation.fulfill()
        }
        
        mockService.simulateUserUpdate { users in
//            users.append(contentsOf: [older, newer])
        }
        
        waitForExpectations(timeout: 2)
    }

    func testStoresLastMessage() {
        let expectation = self.expectation(description: "Last message stored")
        
        let roomId = "room123"
        let message = MessageModel(id: "msg1", text: "Hello", senderId: "u1", receiverId: "u2", timestamp: Date(), status: .sent)

        viewModel.listenToLastMessages(roomId: roomId)

        mockService.simulateLastMessage(for: roomId, message: message) { message in
            XCTAssertEqual(self.viewModel.lastMessages[roomId]?.id, message?.id)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testAvoidsDuplicateListeners() {
        let roomId = "roomDupCheck"
        
        viewModel.listenToLastMessages(roomId: roomId)
        viewModel.listenToLastMessages(roomId: roomId) // Should not add again

        XCTAssertEqual(mockService.lastMessages.count, 1)
    }
}

struct MockFirebaseAuthService {
    var currentUserID: String = "currentUser123"
}

struct MockFirestoreService {
    var users: [UserModel] = []
    var lastMessages: [String: MessageModel] = [:]

    func simulateUserUpdate(_ update: ([UserModel]) -> Void) {
        update(users)
    }

    func simulateLastMessage(for roomId: String, message: MessageModel, update: (MessageModel?) -> Void) {
        update(message)
    }
}
