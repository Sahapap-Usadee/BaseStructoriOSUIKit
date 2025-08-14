//
//  HomeViewModel.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    // MARK: - Services
    private let userService: UserServiceProtocol
    
    // MARK: - Published Properties
    @Published var title: String = "หน้าหลัก"
    @Published var description: String = "ยินดีต้อนรับสู่แอปพลิเคชัน iOS ที่ใช้ MVVM-C Architecture"
    @Published var isLoading: Bool = false
    @Published var users: [AppUser] = []
    @Published var currentTheme: String = "ธีมสว่าง"

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(userService: UserServiceProtocol) {
        self.userService = userService
        loadInitialData()
    }
    
    func refreshData() {
        isLoading = true
        
        // Simulate network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.loadUsers()
            self?.isLoading = false
        }
    }
    
    // MARK: - Private Methods
    private func loadInitialData() {
        loadUsers()
    }
    
    private func loadUsers() {
        // Mock data for demo
//        users = [
//            User(id: "1", name: "สมชาย ใจดี", email: "somchai@example.com"),
//            User(id: "2", name: "สมหญิง สวยงาม", email: "somying@example.com"),
//            User(id: "3", name: "สมศักดิ์ มีสุข", email: "somsak@example.com"),
//            User(id: "4", name: "สมพร เก่งมาก", email: "somporn@example.com"),
//            User(id: "5", name: "สมคิด ฉลาด", email: "somkid@example.com")
//        ]
    }
}
