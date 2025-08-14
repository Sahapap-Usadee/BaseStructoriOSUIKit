//
//  SettingsCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit
import Combine

class SettingsCoordinator: BaseCoordinator {
    private var cancellables = Set<AnyCancellable>()
    private let container: SettingsDIContainer
    
    init(navigationController: UINavigationController, container: SettingsDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }
    
    private func handleThemeChange(_ isDarkMode: Bool) {
        // Handle theme change globally
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
    }
    
    private func showAboutScreen() {
        let aboutViewController = AboutViewController()
        let navController = UINavigationController(rootViewController: aboutViewController)
        navigationController.present(navController, animated: true)
    }
    
    private func showResetConfirmation() {
        let alert = UIAlertController(
            title: "รีเซ็ตการตั้งค่า",
            message: "คุณแน่ใจหรือไม่ที่จะรีเซ็ตการตั้งค่าทั้งหมดกลับเป็นค่าเริ่มต้น?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "รีเซ็ต", style: .destructive) { _ in
            // Reset confirmed
        })
        
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        
        navigationController.present(alert, animated: true)
    }
}
