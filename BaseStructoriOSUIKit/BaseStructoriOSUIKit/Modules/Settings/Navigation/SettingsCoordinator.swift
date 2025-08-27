//
//  SettingsCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class SettingsCoordinator: BaseCoordinator {
    private let container: SettingsDIContainer
    var onSignOut: (() -> Void)?

    init(navigationController: UINavigationController, container: SettingsDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let settingsViewController = container.makeSettingsViewController()
        settingsViewController.coordinator = self
        
        navigationController.setViewControllers([settingsViewController], animated: false)
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

    func showLocalizationTest() {
        let localizationTestViewController = container.makeLocalizationTestViewController()
        localizationTestViewController.coordinator = self

        pushViewController(localizationTestViewController)
    }

    func showAboutScreen() {
        let aboutViewController = AboutViewController()
        let navController = UINavigationController(rootViewController: aboutViewController)
        presentViewController(navController)
    }
    
    func showResetConfirmation() {
        let alert = UIAlertController(
            title: "รีเซ็ตการตั้งค่า",
            message: "คุณแน่ใจหรือไม่ที่จะรีเซ็ตการตั้งค่าทั้งหมดกลับเป็นค่าเริ่มต้น?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "รีเซ็ต", style: .destructive) { _ in
            // Reset confirmed
        })
        
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        presentViewController(alert)
    }

    func signOut() {
        onSignOut?()
    }
}
