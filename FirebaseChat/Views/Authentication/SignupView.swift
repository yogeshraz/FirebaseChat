//
//  SignupView.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import SwiftUI
import SwiftUICoordinator

struct SignupView: View {
    
    @Environment(Coordinator<MainCoordinatorViews>.self) private var coordinator
    @StateObject private var viewModel = AuthViewModel()
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    @StateObject private var nameValidator = TextFieldValidator(rules: [
        TextFieldValidator.nonEmptyRule("Name")
    ])
    
    @StateObject private var emailValidator = TextFieldValidator(rules: [
        TextFieldValidator.nonEmptyRule("Email"),
        TextFieldValidator.emailRule
    ])
    
    @StateObject private var passwordValidator = TextFieldValidator(rules: [
        TextFieldValidator.nonEmptyRule("Password"),
        TextFieldValidator.minLengthRule(8)
    ])
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    header
                    icon
                    inputFields
                    signUpButton
                    bottomView
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .gray.opacity(0.1), radius: 10, x: 0, y: 4)
                .padding(.horizontal)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Sign Up")
            .navigationBarBackButtonHidden(true)
            .onChange(of: viewModel.errorMessage) { oldValue, newValue in
                if let error = newValue {
                    coordinator.showBasicAlert(title: "Error", message: error)
                }
            }
            .onChange(of: viewModel.user) { oldValue, newValue in
                if newValue != nil {
                    coordinator.showBasicAlert(
                        title: "Alert",
                        message: "You have successfully signed up. Please log in to start your chat."
                    ) {
                        coordinator.pop()
                    }
                }
            }
            
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .primaryColor))
                    .scaleEffect(1.5)
            }
        }
    }
}

// MARK: - Subviews

private extension SignupView {
    
    var header: some View {
        VStack(spacing: 8) {
            Text("Create your account")
                .font(.title2)
                .fontWeight(.bold)
            Text("Join us by filling in your details below.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    var icon: some View {
        Image("chat_icon")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
    }
    
    var inputFields: some View {
        VStack(spacing: 16) {
            CustomTextField("Full Name", text: $name, icon: "person.fill")
            if let error = nameValidator.errorMessage {
                validationErrorText(error)
            }
            
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
    
    var signUpButton: some View {
        Button("Sign Up") {
            if validateAllFields() {
                viewModel.signUp(email: email, password: password, fullName: name)
            }
        }
        .buttonStyle(CommonButtonStyle())
        .fontWeight(.semibold)
    }
    
    var bottomView: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .foregroundColor(.secondary)
                .font(.footnote)
            
            Button(action: {
                coordinator.pop()
            }) {
                Text("Login")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.primaryColor)
            }
        }
        .padding(.bottom, 24)
    }
    
    func validationErrorText(_ error: String) -> some View {
        Text(error)
            .foregroundColor(.red)
            .font(.caption)
    }
    
    func validateAllFields() -> Bool {
        nameValidator.text = name
        emailValidator.text = email
        passwordValidator.text = password
        
        nameValidator.validate()
        emailValidator.validate()
        passwordValidator.validate()
        
        return [nameValidator, emailValidator, passwordValidator].allSatisfy { $0.errorMessage == nil }
    }
}


//#Preview {
//    SignupView()
//}
