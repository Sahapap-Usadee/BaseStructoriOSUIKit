//
//  SessionManager.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation

// MARK: - Session Manager Protocol
protocol SessionManagerProtocol {
    var authToken: String? { get }
    var isLoggedIn: Bool { get }
    
    func setAuthToken(_ token: String)
    func clearAuthToken()
    func handleUnauthorized()
}

// MARK: - Session Manager Implementation
class SessionManager: SessionManagerProtocol {
    
    // MARK: - Computed Properties
    var authToken: String? {
        return "test" // test mock
    }
    
    var isLoggedIn: Bool {
        return authToken != nil && !authToken!.isEmpty
    }
    
    // MARK: - Initialization
    init() {
        //inite
    }
    
    // MARK: - Public Methods
    func setAuthToken(_ token: String) {
        // set token
    }
    
    func clearAuthToken() {
        // clear token
    }
    
    func handleUnauthorized() {
        clearAuthToken()
        
        // Post notification for session expired
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .sessionExpired, object: nil)
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let sessionExpired = Notification.Name("sessionExpired")
}
