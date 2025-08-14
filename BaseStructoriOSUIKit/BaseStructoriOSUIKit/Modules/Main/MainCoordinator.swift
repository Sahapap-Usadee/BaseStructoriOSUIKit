//
//  MainCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class MainCoordinator: BaseCoordinator {
    
    private var mainTabBarController: MainTabBarController?
    private let container: DIContainer
    
    // เก็บ coordinators ลูกไว้
    private var homeCoordinator: HomeCoordinator?
    private var listCoordinator: ListCoordinator?
    private var settingsCoordinator: SettingsCoordinator?
    
    init(container: DIContainer = AppDIContainer.shared) {
        self.container = container
        super.init(navigationController: UINavigationController())
    }
    
    override func start() {
        print("🔍 MainCoordinator start() called")
        let mainTabBarController = MainTabBarController()
        mainTabBarController.coordinator = self
        self.mainTabBarController = mainTabBarController
        
        // สร้าง 3 tabs แบบง่าย ๆ
        let tabs = [
            createHomeTab(),
            createListTab(), 
            createSettingsTab()
        ]
        
        mainTabBarController.setViewControllers(tabs)
        print("🔍 Created TabBarController with 3 tabs")
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
        self.homeCoordinator = homeCoordinator // เก็บไว้ไม่ให้หาย
        print("🔍 Created HomeCoordinator: \(homeCoordinator)")
        print("🔍 Stored in MainCoordinator.homeCoordinator: \(self.homeCoordinator)")
        
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
        self.listCoordinator = listCoordinator // เก็บไว้ไม่ให้หาย
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
        self.settingsCoordinator = settingsCoordinator // เก็บไว้ไม่ให้หาย
        settingsViewController.coordinator = settingsCoordinator
        
        return navigationController
    }
    
    func getTabBarController() -> UITabBarController {
        guard let mainTabBarController = mainTabBarController else {
            fatalError("MainTabBarController is nil! Make sure to call start() first.")
        }
        return mainTabBarController
    }

}
