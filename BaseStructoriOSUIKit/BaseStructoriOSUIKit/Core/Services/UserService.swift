//
//  UserService.swift
//  BaseStructoriOSUIKit
//
//  Created by AI Assistant on 2024
//

import Foundation

// MARK: - User Data Model
struct UserData: Codable {
    let id: String
    let username: String
    let email: String
    let fullName: String?
    let profileImageURL: String?
}

// MARK: - User Service Protocol
protocol UserServiceProtocol {
    func updatecurrentUser(_ userData: UserData)
    func getUserData() -> UserData?
}

// MARK: - User Service Implementation
class UserService: UserServiceProtocol {

    var user: UserData
    // MARK: - Initialization
    init() {
        user = .init(id: "", username: "", email: "", fullName: "", profileImageURL: "")
    }
    
    // MARK: - Public Methods
    func updatecurrentUser(_ userData: UserData) {
        user = userData
    }
    
    func getUserData() -> UserData? {
        return user
    }
}
