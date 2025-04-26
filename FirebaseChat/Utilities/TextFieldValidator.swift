//
//  TextFieldValidator.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 21/04/25.
//

import Foundation
import SwiftUI

class TextFieldValidator: ObservableObject {
    @Published var text: String = ""
    @Published var errorMessage: String? = nil
    
    var validationRules: [(String) -> String?] = []
    
    init(rules: [(String) -> String?] = []) {
        self.validationRules = rules
    }
    
    func validate() {
        for rule in validationRules {
            if let message = rule(text) {
                errorMessage = message
                return
            }
        }
        errorMessage = nil
    }
    
    static func emailRule(_ text: String) -> String? {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: text) ? nil : "Invalid email address"
    }
    
    static func nonEmptyRule(_ placeholder: String) -> (String) -> String? {
        return { text in
            return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "\(placeholder) cannot be empty" : nil
        }
    }
    
    static func minLengthRule(_ minLength: Int) -> (String) -> String? {
        return { text in
            return text.trimmingCharacters(in: .whitespacesAndNewlines).count >= minLength ? nil : "Must be at least \(minLength) characters long"
        }
    }
}
