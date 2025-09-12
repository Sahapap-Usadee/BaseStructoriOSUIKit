//
//  AppCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let container: AppDIContainer

    // MARK: - App State Management
    private enum AppState {
        case loading
        case main
        case sessionExpired
    }
    
    private var currentState: AppState = .loading
    
    init(window: UIWindow, container: AppDIContainer) {
        self.window = window
        self.container = container
        super.init(navigationController: UINavigationController())
        setupSessionExpiredHandling()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("🔍 AppCoordinator deinit")
    }
    
    override func start() {
        // Setup global navigation appearance
        NavigationManager.shared.setupGlobalAppearance()
        
        // Start with loading coordinator
        transitionTo(.loading)
    }
    
    // MARK: - State Management
    private func transitionTo(_ newState: AppState) {        
        let previousState = currentState
        currentState = newState
        
        print("🔄 AppCoordinator: \(previousState) → \(newState)")
        
        // Clean up previous state
        finish()
        
        // Setup new state
        switch newState {
        case .loading:
            showLoadingScreen()
        case .main:
            showMainApp()
        case .sessionExpired:
            showSessionExpiredFlow()
        }
    }
    
    private func showLoadingScreen() {
        let loadingDIContainer = container.makeLoadingDIContainer()
        let loadingCoordinator = loadingDIContainer.makeLoadingFlowCoordinator(navigationController: navigationController)
        loadingCoordinator.onFinishedLoading = { [weak self] in
            self?.transitionTo(.main)
        }

        addChildCoordinator(loadingCoordinator)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        loadingCoordinator.start()
    }

    private func showMainApp() {
        print("🔍 AppCoordinator showMainApp() called")
        
        // Create main coordinator through factory
        let mainDIContainer = container.makeMainDIContainer()
        let mainCoordinator = mainDIContainer.makeMainFlowCoordinator(window: window)
        mainCoordinator.onSignOut = { [weak self] in
            self?.transitionTo(.loading)
        }
        
        addChildCoordinator(mainCoordinator)
        print("🔍 AppCoordinator created MainCoordinator: \(mainCoordinator)")

        mainCoordinator.start()
        print("🔍 AppCoordinator called mainCoordinator.start() - MainCoordinator handles window internally")
    }
    
    private func showSessionExpiredFlow() {
        showSessionExpiredAlert { [weak self] in
            self?.transitionTo(.loading)
        }
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
        transitionTo(.sessionExpired)
    }
}
