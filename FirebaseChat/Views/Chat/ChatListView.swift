//
//  ChatListView.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import SwiftUI
import SwiftUICoordinator

struct ChatListView: View {
    
    @Environment(Coordinator<MainCoordinatorViews>.self) private var coordinator
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var viewModel = ChatListViewModel()
    
    private var currentUserId: String {
        authViewModel.currentUser()?.uid ?? ""
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if viewModel.users.isEmpty {
                Text("No users found.")
                    .foregroundColor(.gray)
            } else {
                List(viewModel.users) { user in
                    let roomId = [user.userId, currentUserId].sorted().joined(separator: "_")
                    let lastMessage = viewModel.lastMessages[roomId]
                    
                    Button {
                        coordinator.push(page: .chatDetail(userId: user.userId, userName: user.username))
                    } label: {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.primaryColor)
                                    .frame(width: 40, height: 40)
                                
                                Text(String(user.username.prefix(1)).uppercased())
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            VStack(alignment: .leading) {
                                Text(user.username)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text(lastMessage?.text ?? "No messages yet").font(.subheadline).foregroundColor(.gray)
                            }
                            
                            Spacer()
                            if let timestamp = lastMessage?.timestamp {
                                Text(timestamp.formattedTime())
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onAppear {
                        viewModel.listenToLastMessages(roomId: roomId)
                    }
                }
            }
        }
        .navigationTitle("Chats")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Logout") {
                    authViewModel.logout()
                    coordinator.setRoot(page: .login)
                }
                .foregroundColor(.red)
            }
        }
    }
}
//#Preview {
//    ChatListView()
//}
