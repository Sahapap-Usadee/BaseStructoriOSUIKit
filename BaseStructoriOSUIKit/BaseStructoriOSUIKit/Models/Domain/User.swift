//
//  User.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import Foundation

// MARK: - User Domain Model
struct User: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let email: String
    let profileImageURL: String?
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    
    init(
        id: String = UUID().uuidString,
        name: String,
        email: String,
        profileImageURL: String? = nil,
        isActive: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImageURL = profileImageURL
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - User Extensions
extension User {
    var displayName: String {
        return name.isEmpty ? email : name
    }
    
    var initials: String {
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first?.uppercased() }
        return initials.prefix(2).joined()
    }
    
    var isValidUser: Bool {
        return !name.isEmpty && email.isValidEmail
    }
}

// MARK: - Sample Data
extension User {
    static let sampleUsers: [User] = [
        User(
            name: "สหภาพ อุสาดี",
            email: "sahapap@example.com",
            profileImageURL: "https://example.com/profile1.jpg"
        ),
        User(
            name: "จิรัชญา สมิต",
            email: "jiracha@example.com",
            profileImageURL: "https://example.com/profile2.jpg"
        ),
        User(
            name: "วิชัย เทพสุวรรณ",
            email: "wichai@example.com",
            profileImageURL: nil
        )
    ]
    
    static let currentUser = sampleUsers[0]
}
