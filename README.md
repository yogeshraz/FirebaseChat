# 📱 SwiftUI One-to-One Chat App

A real-time one-to-one chat application built with **SwiftUI** and **Firebase**, following a clean **MVVM architecture** for modularity, scalability, and testability.

---

## 🚀 Features

- 🔒 **Firebase Authentication**  
  Secure login and registration system.

- 💬 **Realtime Messaging**  
  Powered by **Cloud Firestore**, with real-time updates and delivery statuses.

- 📴 **Offline Support**  
  Send and receive messages seamlessly, even when offline — messages sync when reconnected.

- 🎯 **MVVM Architecture**  
  Clean separation of concerns for maintainable, testable code.

- 🔗 **Custom SwiftUI Coordinator Self Developed**  
  Built-in modular router system for scalable and reusable navigation.  
  [Coordinator Library ➡️](https://lnkd.in/gq7F2Cwe)

- 🌟 **Modern SwiftUI UI/UX**  
  Smooth transitions, adaptive layout, and polished animations.

---

## 🧠 Architecture Overview

| Layer          | Purpose                                                       |
| -------------- | ------------------------------------------------------------ |
| **Model**      | Defines data structures (User, Message, Chat).                |
| **ViewModel**  | Business logic, network interaction, and state management.    |
| **View**       | SwiftUI views responsible for rendering UI.                  |
| **Coordinator**| Custom navigation management across modules and screens.     |

---

## 🧭 App Flow

1. **Login Screen**  
   Existing users can log in using email and password.

2. **Sign Up Screen**  
   New users can quickly register and join the chat.

3. **Recent Conversations Screen**  
   Displays all active conversations for the signed-in user.

4. **Chat Screen**  
   - Real-time message updates.  
   - Delivery status indicators.  
   - Offline message persistence.  
   - Clean chat bubble UI with animations.

---

✅ **Current Strengths**:

- Robust real-time messaging with offline support.
- MVVM ensures clean and scalable code.
- Smooth user experience with SwiftUI animations and transitions.
- Custom-built router system for clean and scalable navigation.

🌱 **Planned Enhancements**:

- Group Chat Functionality.
- Push Notifications for incoming messages.
- Media attachments (Images, Files).
- Typing Indicators (Real-time).
- Dark/Light mode UI theming.
- Message Search and Filtering.

---
