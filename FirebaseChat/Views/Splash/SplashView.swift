
//
//  Splash.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 26/04/25.
//

import SwiftUI
import SwiftUICoordinator

struct SplashView: View {
    
    @Environment(Coordinator<MainCoordinatorViews>.self) private var coordinator
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            VStack {
                Image("chat_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if FirebaseAuthService.shared.currentUser != nil {
                    coordinator.push(page: .chat)
                } else {
                    coordinator.push(page: .login)
                }
            }
        }
    }
}

//struct SplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashView()
//    }
//}
