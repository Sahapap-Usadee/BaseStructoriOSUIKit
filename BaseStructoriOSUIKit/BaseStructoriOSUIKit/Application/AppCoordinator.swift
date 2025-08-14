//
//  AppCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let container: DIContainer
    
    init(window: UIWindow, container: DIContainer = AppDIContainer.shared) {
        self.window = window
        self.container = container
        super.init(navigationController: UINavigationController())
    }
    
    override func start() {
        // Setup global navigation appearance
        NavigationManager.shared.setupGlobalAppearance()
        
        // Start with loading coordinator
        showLoadingScreen()
    }
    
    private func showLoadingScreen() {
        let loadingCoordinator = LoadingCoordinator(navigationController: navigationController)
        loadingCoordinator.delegate = self
        addChildCoordinator(loadingCoordinator)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        loadingCoordinator.start()
    }
    
    private func showMainApp() {
        print("🔍 AppCoordinator showMainApp() called")
        // Clear loading coordinator
        childCoordinators.removeAll()
        
        // Start main coordinator through DI Container
        let mainCoordinator = container.makeMainCoordinator()
        addChildCoordinator(mainCoordinator)
        print("🔍 AppCoordinator created MainCoordinator: \(mainCoordinator)")
        
        // Start the coordinator first, then get the TabBar
        mainCoordinator.start()
        print("🔍 AppCoordinator called mainCoordinator.start()")
        
        // Set TabBar as window root directly
        window.rootViewController = mainCoordinator.getTabBarController()
        print("🔍 AppCoordinator set window root to TabBarController")
    }
}

// MARK: - LoadingCoordinatorDelegate
extension AppCoordinator: LoadingCoordinatorDelegate {
    func loadingDidComplete() {
        showMainApp()
    }
}
