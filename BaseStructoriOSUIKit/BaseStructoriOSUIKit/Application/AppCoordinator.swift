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
        print("🚀 AppCoordinator: Starting app flow")
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
        let mainCoordinator = container.makeMainCoordinator(window: window)
        addChildCoordinator(mainCoordinator)
        print("🔍 AppCoordinator created MainCoordinator: \(mainCoordinator)")
        
        // MainCoordinator จะจัดการ window เอง
        mainCoordinator.start()
        print("🔍 AppCoordinator called mainCoordinator.start() - MainCoordinator handles window internally")
    }
}

// MARK: - LoadingCoordinatorDelegate
extension AppCoordinator: LoadingCoordinatorDelegate {
    func loadingDidComplete() {
        showMainApp()
    }
}
