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
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
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
    
    private func setupViewControllers() {
        let tabOneNav = createTabOneNavigationController()
        let tabTwoNav = createTabTwoNavigationController()
        let tabThreeNav = createTabThreeNavigationController()
        
        viewControllers = [tabOneNav, tabTwoNav, tabThreeNav]
    }
    
    private func createTabOneNavigationController() -> UINavigationController {
        let tabOneViewController = TabOneViewController()
        tabOneViewController.coordinator = coordinator
        
        let navigationController = NavigationManager.shared.createNavigationController(
            rootViewController: tabOneViewController,
            style: .default
        )
        
        navigationController.tabBarItem = UITabBarItem(
            title: "หน้าแรก",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        return navigationController
    }
    
    private func createTabTwoNavigationController() -> UINavigationController {
        let tabTwoViewController = TabTwoViewController()
        tabTwoViewController.coordinator = coordinator
        
        let navigationController = NavigationManager.shared.createNavigationController(
            rootViewController: tabTwoViewController,
            style: .colored(.systemBlue)
        )
        
        navigationController.tabBarItem = UITabBarItem(
            title: "รายการ",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet.rectangle.fill")
        )
        
        return navigationController
    }
    
    private func createTabThreeNavigationController() -> UINavigationController {
        let tabThreeViewController = TabThreeViewController()
        tabThreeViewController.coordinator = coordinator
        
        let navigationController = NavigationManager.shared.createNavigationController(
            rootViewController: tabThreeViewController,
            style: .default
        )
        
        navigationController.navigationBar.prefersLargeTitles = true
        
        navigationController.tabBarItem = UITabBarItem(
            title: "ตั้งค่า",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        return navigationController
    }
}
