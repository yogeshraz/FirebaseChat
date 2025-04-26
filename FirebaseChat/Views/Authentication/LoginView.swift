//
//  ContentView.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import SwiftUI
import SwiftUICoordinator

struct LoginView: View {
    
    @Environment(Coordinator<MainCoordinatorViews>.self) private var coordinator
    @StateObject private var viewModel = AuthViewModel()
    
    @State private var email = ""
    @State private var password = ""
    
    @StateObject private var emailValidator = TextFieldValidator(
        rules: [
            TextFieldValidator.nonEmptyRule("Email"),
            TextFieldValidator.emailRule
        ]
    )
    
    @StateObject private var passwordValidator = TextFieldValidator(
        rules: [
            TextFieldValidator.nonEmptyRule("Password"),
            TextFieldValidator.minLengthRule(8)
        ]
    )
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 40)
                    
                    Image("chat_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    inputFields
                    loginButton
                    bottomView
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .gray.opacity(0.08), radius: 10, x: 0, y: 4)
                .padding(.horizontal)
            }
            .disabled(viewModel.isLoading) // Disable interaction during loading
            .blur(radius: viewModel.isLoading ? 3 : 0) // Add slight blur during loading
            
            if viewModel.isLoading {
                loadingOverlay
            }
        }
        .navigationTitle("Login")
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: resetFields)
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if let error = newValue {
                coordinator.showBasicAlert(title: "Error", message: error)
            }
        }
        .onChange(of: viewModel.user) { oldValue, newValue in
            if newValue != nil {
                coordinator.setRoot(.chat)
            }
        }
    }
}

private extension LoginView {
    
    var inputFields: some View {
        VStack(spacing: 16) {
            CustomTextField("Email", text: $email, keyboardType: .emailAddress, icon: "envelope.fill")
            if let error = emailValidator.errorMessage {
                validationErrorText(error)
            }
            
            CustomTextField("Password", text: $password, icon: "key.fill", isSecure: true)
            if let error = passwordValidator.errorMessage {
                validationErrorText(error)
            }
        }
    }
    
    var loginButton: some View {
        Button("Login") {
            if validateAllFields() {
                viewModel.login(email: email, password: password)
            }
        }
        .buttonStyle(CommonButtonStyle())
        .fontWeight(.semibold)
        .opacity(viewModel.isLoading ? 0.6 : 1.0)
        .disabled(viewModel.isLoading)
    }
    
    var bottomView: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .foregroundColor(.secondary)
                .font(.footnote)
            
            Button("Create Account") {
                coordinator.push(.signup)
            }
            .font(.footnote)
            .fontWeight(.semibold)
            .foregroundColor(Color.primaryColor)
            .disabled(viewModel.isLoading)
        }
        .padding(.bottom, 24)
    }
    
    var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .primaryColor))
                .scaleEffect(1.5)
        }
    }
    
    func validationErrorText(_ error: String) -> some View {
        Text(error)
            .foregroundColor(.red)
            .font(.caption)
    }
    
    func validateAllFields() -> Bool {
        emailValidator.text = email
        passwordValidator.text = password
        emailValidator.validate()
        passwordValidator.validate()
        
        return [emailValidator, passwordValidator].allSatisfy { $0.errorMessage == nil }
    }
    
    func resetFields() {
        email = ""
        password = ""
        emailValidator.text = ""
        passwordValidator.text = ""
    }
}

//#Preview {
//    LoginView()
//}
