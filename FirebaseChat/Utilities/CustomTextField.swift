//
//  Custom.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var icon: String? = nil
    var isSecure: Bool = false
    
    @State private var isPasswordVisible: Bool = false
    
    init(
        _ placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        icon: String? = nil,
        isSecure: Bool = false
    ) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.icon = icon
        self.isSecure = isSecure
    }
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.gray)
            }
            
            if isSecure {
                Group {
                    if isPasswordVisible {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                }
                .keyboardType(keyboardType)
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .onChange(of: text) {
                        if keyboardType == .numberPad {
                            text = text.filter { $0.isNumber }
                        } else if keyboardType == .decimalPad {
                            text = filterDecimalInput(text)
                        }
                    }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    
    // Helper for valid decimal input (e.g. "123.45")
    private func filterDecimalInput(_ input: String) -> String {
        var result = ""
        var hasDecimal = false
        
        for char in input {
            if char.isNumber {
                result.append(char)
            } else if char == "." && !hasDecimal {
                result.append(char)
                hasDecimal = true
            }
        }
        
        return result
    }
}
