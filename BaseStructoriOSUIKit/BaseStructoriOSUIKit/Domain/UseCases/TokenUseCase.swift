//
//  TokenUseCase.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation

// MARK: - Token Local Data Source Protocol
protocol TokenLocalDataSource {
    func saveToken(_ token: String)
    func getToken() -> String?
    func removeToken()
}

// MARK: - Token Defaults Data Source Implementation
class TokenDefaultsDataSource: TokenLocalDataSource {
    private let key = "auth_token"
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: key)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    func removeToken() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

// MARK: - Token Use Case Protocol
protocol TokenUseCaseProtocol {
    func saveToken(_ token: String)
    func getToken() -> String?
    func removeToken()
}

// MARK: - Token Use Case Implementation
class TokenUseCase: TokenUseCaseProtocol {
    private let dataSource: TokenLocalDataSource
    
    init(dataSource: TokenLocalDataSource) {
        self.dataSource = dataSource
    }
    
    func saveToken(_ token: String) {
        dataSource.saveToken(token)
    }
    
    func getToken() -> String? {
        return dataSource.getToken()
    }
    
    func removeToken() {
        dataSource.removeToken()
    }
}
