//
//  AppCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
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
        // Clear loading coordinator
        childCoordinators.removeAll()
        
        // Start main coordinator
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        addChildCoordinator(mainCoordinator)
        mainCoordinator.start()
    }
}

// MARK: - LoadingCoordinatorDelegate
extension AppCoordinator: LoadingCoordinatorDelegate {
    func loadingDidComplete() {
        showMainApp()
    }
}
