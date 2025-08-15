//
//  TestCompile.swift
//  BaseStructoriOSUIKit Test
//
//  Created for testing compilation
//

import UIKit

// ทดสอบการใช้งาน NavigationManager
class TestNavigationUsage {
    func testCreateNavigationController() {
        let viewController = UIViewController()
        
        // ✅ วิธีที่ถูกต้อง - ใช้ NavigationBarStyle enum ที่เราสร้างเอง
        let navController = NavigationManager.shared.createNavigationController(
            rootViewController: viewController,
            style: .default
        )
        
        // ตัวอย่างการใช้ style อื่นๆ
        let transparentNav = NavigationManager.shared.createNavigationController(
            rootViewController: viewController,
            style: .transparent
        )
        
        let coloredNav = NavigationManager.shared.createNavigationController(
            rootViewController: viewController,
            style: .colored(.systemBlue)
        )
        
        let hiddenNav = NavigationManager.shared.createNavigationController(
            rootViewController: viewController,
            style: .hidden
        )
        
        print("Navigation controllers created successfully")
    }
}

// ทดสอบการใช้งาน NavigationConfiguration
class TestNavigationConfiguration {
    func testNavigationBuilder() {
        let config = NavigationBuilder()
            .title("Test Title")
            .style(.colored(.systemRed))
            .rightButton(image: UIImage(systemName: "gear")) {
                print("Right button tapped")
            }
            .build()
        
        print("NavigationConfiguration created: \(config)")
    }
}
