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
        loadingCoordinator.onFinishedLoading = { [weak self] in
            self?.showMainApp()
        }

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
        let mainCoordinator = container.makeMainCoordinator(window: window)
        mainCoordinator.onSignOut = { [weak self] in
            self?.showLoadingScreen()
        }
        addChildCoordinator(mainCoordinator)
        print("🔍 AppCoordinator created MainCoordinator: \(mainCoordinator)")
        
        // MainCoordinator จะจัดการ window เอง
        mainCoordinator.start()
        print("🔍 AppCoordinator called mainCoordinator.start() - MainCoordinator handles window internally")
    }
}
