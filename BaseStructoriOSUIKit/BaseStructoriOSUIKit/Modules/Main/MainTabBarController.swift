//
//  MainTabBarController.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🔍 MainTabBarController viewDidLoad called")
        setupTabBar()
    }
    
    // Simple method to set view controllers (called by coordinator)
    func setViewControllers(_ controllers: [UINavigationController]) {
        viewControllers = controllers
        print("🔍 viewControllers set: \(controllers.count) tabs")
    }
    
    private func setupTabBar() {
        print("🔍 setupTabBar called")
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
        
        // Modern tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabBarController()
}
