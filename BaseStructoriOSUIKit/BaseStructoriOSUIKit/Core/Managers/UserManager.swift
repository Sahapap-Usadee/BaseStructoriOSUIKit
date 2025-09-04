//
//  UserManager.swift
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
protocol UserManagerProtocol {
    func updatecurrentUser(_ userData: UserData)
    func getUserData() -> UserData?
}

class UserManager: UserManagerProtocol {

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
