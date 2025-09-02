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
    
    init(window: UIWindow, container: DIContainer) {
        self.window = window
        self.container = container
        super.init(navigationController: UINavigationController())

        setupSessionExpiredHandling()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            // ปิด coordinator และลบออกจาก parent
            self?.finish()

            self?.showMainApp()
        }

        addChildCoordinator(loadingCoordinator)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        loadingCoordinator.start()
    }

    private func showMainApp() {
        print("🔍 AppCoordinator showMainApp() called")
        
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
    
    private func showSessionExpiredAlert(completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "เซสชันหมดอายุ",
            message: "เซสชันของคุณหมดอายุแล้ว กรุณาเข้าสู่ระบบใหม่",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "ตกลง", style: .default) { _ in
            completion()
        }
        
        alert.addAction(okAction)
        
        // Find top view controller to present alert
        if let topViewController = getTopViewController() {
            topViewController.present(alert, animated: true)
        }
    }
}

extension AppCoordinator {
    private func setupSessionExpiredHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSessionExpired),
            name: .sessionExpired,
            object: nil
        )
    }

    @objc private func handleSessionExpired() {
        showSessionExpiredAlert { [weak self] in
            // Clear all child coordinators
            self?.childCoordinators.removeAll()

            // Restart app flow
            self?.showLoadingScreen()
        }
    }
}
