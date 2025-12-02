//
//  SettingsCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

final class SettingsCoordinator: BaseCoordinator {
    
    private let container: SettingsDIContainer
    var onSignOut: (() -> Void)?
    
    init(navigationController: UINavigationController, container: SettingsDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let vc = container.makeSettingsViewController()
        vc.coordinator = self
        setRoot(vc)
    }
    
    func showLocalizationTest() {
        let vc = container.makeLocalizationTestViewController()
        vc.coordinator = self
        push(vc)
    }
    
    func showAboutScreen() {
        present(UINavigationController(rootViewController: AboutViewController()))
    }
    
    func showResetConfirmation() {
        let alert = UIAlertController(
            title: "รีเซ็ตการตั้งค่า",
            message: "คุณแน่ใจหรือไม่ที่จะรีเซ็ตการตั้งค่าทั้งหมดกลับเป็นค่าเริ่มต้น?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "รีเซ็ต", style: .destructive))
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        present(alert)
    }
    
    func signOut() {
        onSignOut?()
    }
}
