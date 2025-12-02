//
//  AppCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

final class AppCoordinator: BaseCoordinator {

    private let window: UIWindow
    private let container: AppDIContainer
    private var currentState: AppState = .loading

    private enum AppState {
        case loading, main, expired
    }

    init(window: UIWindow, container: AppDIContainer) {
        self.window = window
        self.container = container
        super.init()
        observeSessionExpired()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func start() {
        NavigationManager.shared.setupGlobalAppearance()
        goTo(.loading)
    }

    // MARK: - State

    private func goTo(_ state: AppState) {
        finish()
        currentState = state

        switch state {
        case .loading:  showLoading()
        case .main:     showMain()
        case .expired:  showSessionExpired()
        }
    }

    // MARK: - Screens

    private func showLoading() {
        let loadingContainer = container.makeLoadingDIContainer()
        let loadingCoordinator = loadingContainer.makeLoadingFlowCoordinator(navigationController: navigationController)

        loadingCoordinator.onFinishedLoading = { [weak self] in
            self?.goTo(.main)
        }

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        coordinate(to: loadingCoordinator)
    }

    private func showMain() {
        let mainContainer = container.makeMainDIContainer()
        let mainCoordinator = mainContainer.makeMainFlowCoordinator(window: window)

        mainCoordinator.onSignOut = { [weak self] in
            self?.goTo(.loading)
        }

        coordinate(to: mainCoordinator)
    }

    private func showSessionExpired() {
        let alert = UIAlertController(
            title: "เซสชันหมดอายุ",
            message: "กรุณาเข้าสู่ระบบใหม่",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default) { [weak self] _ in
            self?.goTo(.loading)
        })
        topViewController()?.present(alert, animated: true)
    }

    // MARK: - Session

    private func observeSessionExpired() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSessionExpired), name: .sessionExpired, object: nil)
    }

    @objc private func handleSessionExpired() {
        goTo(.expired)
    }
}
