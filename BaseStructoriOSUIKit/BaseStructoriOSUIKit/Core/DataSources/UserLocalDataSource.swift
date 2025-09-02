//
//  UserLocalDataSource.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation

// MARK: - User Local Data Source Protocol
protocol UserLocalDataSource {
    func saveUserName(_ name: String)
    func getUserName() -> String?
}

// MARK: - User Defaults Data Source Implementation
class UserDefaultsDataSource: UserLocalDataSource {
    private let key = "username"
    
    func saveUserName(_ name: String) {
        UserDefaults.standard.set(name, forKey: key)
    }
    
    func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
