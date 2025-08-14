//
//  Models.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import Foundation

// MARK: - App Models Namespace
enum Models {
    
    // MARK: - User
    struct User: Codable, Identifiable {
        let id: String
        let name: String
        let email: String
        let profileImageURL: String?
        let createdAt: Date
        let updatedAt: Date
        
        init(id: String, name: String, email: String, profileImageURL: String? = nil) {
            self.id = id
            self.name = name
            self.email = email
            self.profileImageURL = profileImageURL
            self.createdAt = Date()
            self.updatedAt = Date()
        }
    }
    
    // MARK: - Post
    struct Post: Codable, Identifiable {
        let id: String
        let title: String
        let content: String
        let authorId: String
        let imageURLs: [String]
        let createdAt: Date
        let updatedAt: Date
    }
    
    // MARK: - Category
    struct Category: Codable, Identifiable {
        let id: String
        let name: String
        let description: String
        let color: String
        let iconName: String
    }
}

// MARK: - Type Aliases สำหรับใช้งานง่าย
typealias AppUser = Models.User
typealias AppPost = Models.Post
typealias AppCategory = Models.Category
