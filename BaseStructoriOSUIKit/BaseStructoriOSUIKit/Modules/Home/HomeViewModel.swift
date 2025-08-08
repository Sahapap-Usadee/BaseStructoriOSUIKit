//
//  HomeViewModel.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var title: String = "หน้าหลัก"
    @Published var description: String = "ยินดีต้อนรับสู่แอปพลิเคชัน iOS ที่ใช้ MVVM-C Architecture"
    @Published var isLoading: Bool = false
    @Published var users: [User] = []
    @Published var currentTheme: String = "ธีมสว่าง"
    
    // MARK: - Input Publishers  
    private let detailRequestedSubject = PassthroughSubject<Void, Never>()
    private let themeToggleRequestedSubject = PassthroughSubject<Void, Never>()
    private let refreshRequestedSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Output Publishers
    var detailRequested: AnyPublisher<Void, Never> {
        detailRequestedSubject.eraseToAnyPublisher()
    }
    
    var themeToggleRequested: AnyPublisher<Void, Never> {
        themeToggleRequestedSubject.eraseToAnyPublisher()
    }
    
    var refreshRequested: AnyPublisher<Void, Never> {
        refreshRequestedSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        loadInitialData()
    }
    
    // MARK: - Public Methods
    func showDetailTapped() {
        detailRequestedSubject.send()
    }
    
    func toggleThemeTapped() {
        // Toggle theme state
        currentTheme = currentTheme == "ธีมสว่าง" ? "ธีมมืด" : "ธีมสว่าง"
        themeToggleRequestedSubject.send()
    }
    
    func refreshTapped() {
        refreshData()
        refreshRequestedSubject.send()
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
        users = [
            User(id: "1", name: "สมชาย ใจดี", email: "somchai@example.com"),
            User(id: "2", name: "สมหญิง สวยงาม", email: "somying@example.com"),
            User(id: "3", name: "สมศักดิ์ มีสุข", email: "somsak@example.com"),
            User(id: "4", name: "สมพร เก่งมาก", email: "somporn@example.com"),
            User(id: "5", name: "สมคิด ฉลาด", email: "somkid@example.com")
        ]
    }
}
