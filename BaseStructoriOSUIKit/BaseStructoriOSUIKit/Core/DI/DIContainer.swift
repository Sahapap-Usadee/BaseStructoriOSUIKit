//
//  DIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

final class AppDIContainer {

    static let shared = AppDIContainer()
    private init() {}

    // MARK: - Services
    private lazy var sessionManager: SessionManagerProtocol = SessionManager()
    private lazy var networkService: NetworkServiceProtocol = NetworkService(sessionManager: sessionManager)
    private lazy var userManager: UserManagerProtocol = UserManager()

    // MARK: - Module Containers
    private lazy var mainDIContainer = MainDIContainer(appDIContainer: self)
    private lazy var loadingDIContainer = LoadingDIContainer(appDIContainer: self)

    // MARK: - Factory Methods
    func makeNetworkService() -> NetworkServiceProtocol { networkService }
    func makeSessionManager() -> SessionManagerProtocol { sessionManager }
    func makeUserManager() -> UserManagerProtocol { userManager }

    func makeMainDIContainer() -> MainDIContainer { mainDIContainer }
    func makeLoadingDIContainer() -> LoadingDIContainer { loadingDIContainer }
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator { AppCoordinator(window: window, container: self) }
}
