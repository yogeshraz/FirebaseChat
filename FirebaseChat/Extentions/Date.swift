//
//  Date.swift
//  FirebaseChat
//
//  Created by Yogesh Raj on 22/04/25.
//

import Foundation

extension Date {
    
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    func formattedSectionHeader(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Check if the message is from today, yesterday, or an older date
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.isDate(date, inSameDayAs: now) {
            return "Today"
        } else {
            // For other dates, show the formatted date (e.g., "Jan 22, 2025")
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
    }
}
