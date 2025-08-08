//
//  MainTabBarController.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - Initialization
    init(
        homeViewController: UIViewController,
        listViewController: UIViewController,
        settingsViewController: UIViewController
    ) {
        super.init(nibName: nil, bundle: nil)
        setupTabBar()
        setupViewControllers(
            home: homeViewController,
            list: listViewController,
            settings: settingsViewController
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func setupViewControllers(
        home: UIViewController,
        list: UIViewController,
        settings: UIViewController
    ) {
        let homeNav = createNavigationController(
            rootViewController: home,
            title: "หน้าหลัก",
            image: "house",
            selectedImage: "house.fill",
            style: .default
        )
        
        let listNav = createNavigationController(
            rootViewController: list,
            title: "รายการ",
            image: "list.bullet",
            selectedImage: "list.bullet.rectangle.fill",
            style: .colored(.systemBlue)
        )
        
        let settingsNav = createNavigationController(
            rootViewController: settings,
            title: "ตั้งค่า",
            image: "gearshape",
            selectedImage: "gearshape.fill",
            style: .default,
            largeTitles: true
        )
        
        viewControllers = [homeNav, listNav, settingsNav]
    }
    
    private func createNavigationController(
        rootViewController: UIViewController,
        title: String,
        image: String,
        selectedImage: String,
        style: NavigationBarStyle,
        largeTitles: Bool = false
    ) -> UINavigationController {
        let navigationController = NavigationManager.shared.createNavigationController(
            rootViewController: rootViewController,
            style: style
        )
        
        if largeTitles {
            navigationController.navigationBar.prefersLargeTitles = true
        }
        
        navigationController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: image),
            selectedImage: UIImage(systemName: selectedImage)
        )
        
        return navigationController
    }
}
