//
//  SettingsViewModel.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var title: String = "การตั้งค่า"
    @Published var description: String = "ปรับแต่งและจัดการการตั้งค่าของแอปพลิเคชัน"
    @Published var isDarkModeEnabled: Bool = false
    @Published var isNotificationEnabled: Bool = true
    @Published var selectedLanguage: String = "ไทย"
    @Published var selectedFontSize: String = "ปกติ"
    @Published var appVersion: String = "1.0.0"
    @Published var buildNumber: String = "100"
    
    // MARK: - Input Publishers
    private let themeChangeRequestedSubject = PassthroughSubject<Bool, Never>()
    private let notificationToggleRequestedSubject = PassthroughSubject<Bool, Never>()
    private let languageChangeRequestedSubject = PassthroughSubject<String, Never>()
    private let aboutRequestedSubject = PassthroughSubject<Void, Never>()
    private let resetRequestedSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Output Publishers
    var themeChangeRequested: AnyPublisher<Bool, Never> {
        themeChangeRequestedSubject.eraseToAnyPublisher()
    }
    
    var notificationToggleRequested: AnyPublisher<Bool, Never> {
        notificationToggleRequestedSubject.eraseToAnyPublisher()
    }
    
    var languageChangeRequested: AnyPublisher<String, Never> {
        languageChangeRequestedSubject.eraseToAnyPublisher()
    }
    
    var aboutRequested: AnyPublisher<Void, Never> {
        aboutRequestedSubject.eraseToAnyPublisher()
    }
    
    var resetRequested: AnyPublisher<Void, Never> {
        resetRequestedSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    let availableLanguages = ["ไทย", "English", "中文", "日本語"]
    let availableFontSizes = ["เล็ก", "ปกติ", "ใหญ่", "ใหญ่มาก"]
    
    // MARK: - Initialization
    init() {
        loadSettings()
    }
    
    // MARK: - Public Methods
    func toggleDarkMode(_ enabled: Bool) {
        isDarkModeEnabled = enabled
        saveSettings()
        themeChangeRequestedSubject.send(enabled)
    }
    
    func toggleNotifications(_ enabled: Bool) {
        isNotificationEnabled = enabled
        saveSettings()
        notificationToggleRequestedSubject.send(enabled)
    }
    
    func changeLanguage(_ language: String) {
        selectedLanguage = language
        saveSettings()
        languageChangeRequestedSubject.send(language)
    }
    
    func changeFontSize(_ fontSize: String) {
        selectedFontSize = fontSize
        saveSettings()
    }
    
    func showAbout() {
        aboutRequestedSubject.send()
    }
    
    func resetToDefaults() {
        isDarkModeEnabled = false
        isNotificationEnabled = true
        selectedLanguage = "ไทย"
        selectedFontSize = "ปกติ"
        saveSettings()
        resetRequestedSubject.send()
    }
    
    // MARK: - Private Methods
    private func loadSettings() {
        // Load settings from UserDefaults
        isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        isNotificationEnabled = UserDefaults.standard.bool(forKey: "isNotificationEnabled")
        selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "ไทย"
        selectedFontSize = UserDefaults.standard.string(forKey: "selectedFontSize") ?? "ปกติ"
        
        // Load app info
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            buildNumber = build
        }
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(isDarkModeEnabled, forKey: "isDarkModeEnabled")
        UserDefaults.standard.set(isNotificationEnabled, forKey: "isNotificationEnabled")
        UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
        UserDefaults.standard.set(selectedFontSize, forKey: "selectedFontSize")
    }
}
