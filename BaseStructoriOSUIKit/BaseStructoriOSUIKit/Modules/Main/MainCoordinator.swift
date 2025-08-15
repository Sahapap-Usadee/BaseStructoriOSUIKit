//
//  MainCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class MainCoordinator: BaseCoordinator {

    private let container: DIContainer
    private let window: UIWindow
    var onSignOut: (() -> Void)?

    init(window: UIWindow, container: DIContainer) {
        self.window = window
        self.container = container
        super.init(navigationController: UINavigationController())
    }
    
    override func start() {
        print("🔍 MainCoordinator start() called")
        let mainTabBarController = MainTabBarController()
        mainTabBarController.coordinator = self

        // สร้าง 3 tabs แบบง่าย ๆ
        let tabs = [
            createHomeTab(),
            createListTab(), 
            createSettingsTab()
        ]
        
        mainTabBarController.setViewControllers(tabs)
        print("🔍 Created TabBarController with 3 tabs")
        
        // Set TabBar as window root และ make key window
        window.rootViewController = mainTabBarController
        window.makeKeyAndVisible()
        print("🔍 MainCoordinator set window root to TabBarController and made key")
    }
    
        // MARK: - สร้าง Tabs แบบง่าย ๆ
    private func createHomeTab() -> UINavigationController {
        // สร้าง ViewController ผ่าน Module DI Container
        let homeDIContainer = container.makeHomeDIContainer()
        let homeViewController = homeDIContainer.makeHomeViewController()
        
        // สร้าง NavigationController
        let navigationController = NavigationManager.shared.createNavigationController(
            rootViewController: homeViewController,
            style: .default
        )
        
        // ตั้งค่า TabBar Item
        navigationController.tabBarItem = UITabBarItem(
            title: "หน้าหลัก",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // สร้าง Coordinator ผ่าน Module DI Container
        let homeCoordinator = homeDIContainer.makeHomeFlowCoordinator(navigationController: navigationController)
        addChildCoordinator(homeCoordinator) // ✅ ใช้ built-in method
        print("🔍 Created HomeCoordinator: \(homeCoordinator)")
        print("🔍 Added to childCoordinators: \(childCoordinators.count) coordinators")
        
        homeViewController.coordinator = homeCoordinator
        print("🔍 Set coordinator to HomeViewController: \(homeViewController.coordinator)")
        
        return navigationController
    }
    
    private func createListTab() -> UINavigationController {
        // สร้าง ViewController ผ่าน Module DI Container
        let listDIContainer = container.makeListDIContainer()
        let listViewController = listDIContainer.makeListViewController()
        
        // สร้าง NavigationController
        let navigationController = NavigationManager.shared.createNavigationController(
            rootViewController: listViewController,
            style: .colored(.systemBlue)
        )
        
        // ตั้งค่า TabBar Item
        navigationController.tabBarItem = UITabBarItem(
            title: "รายการ",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet.rectangle.fill")
        )
        
        // สร้าง Coordinator ผ่าน Module DI Container
        let listCoordinator = listDIContainer.makeListFlowCoordinator(navigationController: navigationController)
        addChildCoordinator(listCoordinator) // ✅ ใช้ built-in method
        listViewController.coordinator = listCoordinator
        
        return navigationController
    }
    
    private func createSettingsTab() -> UINavigationController {
        // สร้าง ViewController ผ่าน Module DI Container
        let settingsDIContainer = container.makeSettingsDIContainer()
        let settingsViewController = settingsDIContainer.makeSettingsViewController()
        
        // สร้าง NavigationController
        let navigationController = NavigationManager.shared.createNavigationController(
            rootViewController: settingsViewController,
            style: .default
        )
        
        // ตั้งค่า TabBar Item
        navigationController.tabBarItem = UITabBarItem(
            title: "ตั้งค่า",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        // สร้าง Coordinator ผ่าน Module DI Container
        let settingsCoordinator = settingsDIContainer.makeSettingsFlowCoordinator(navigationController: navigationController)
        settingsCoordinator.onSignOut = { [weak self] in
            self?.onSignOut?()
        }
        addChildCoordinator(settingsCoordinator) // ✅ ใช้ built-in method
        settingsViewController.coordinator = settingsCoordinator
        
        return navigationController
    }

}
