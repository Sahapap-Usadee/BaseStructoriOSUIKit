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
    
    // MARK: - Properties
    private let tokenUseCase: TokenUseCaseProtocol
    
    // MARK: - Computed Properties
    var authToken: String? {
        return tokenUseCase.getToken()
    }
    
    var isLoggedIn: Bool {
        return authToken != nil && !authToken!.isEmpty
    }
    
    // MARK: - Initialization
    init(tokenUseCase: TokenUseCaseProtocol) {
        self.tokenUseCase = tokenUseCase
    }
    
    // MARK: - Public Methods
    func setAuthToken(_ token: String) {
        tokenUseCase.saveToken(token)
    }
    
    func clearAuthToken() {
        tokenUseCase.removeToken()
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
