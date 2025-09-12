//
//  DIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

protocol ServiceFactory {
    func makeNetworkService() -> NetworkServiceProtocol
    func makeSessionManager() -> SessionManagerProtocol
    func makeUserManager() -> UserManagerProtocol
}

protocol CoordinatorFactory {
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator
}

protocol ModuleContainerFactory {
    func makeMainDIContainer() -> MainDIContainer
    func makeLoadingDIContainer() -> LoadingDIContainer

}

//MARK: - App DI Container (Composition Root)
class AppDIContainer {
    static let shared = AppDIContainer()

    private init() {}

    private lazy var sessionManager: SessionManagerProtocol = SessionManager()
    private lazy var networkService: NetworkServiceProtocol = NetworkService(sessionManager: sessionManager)
    private lazy var userManager: UserManagerProtocol = UserManager()

    private lazy var mainDIContainer: MainDIContainer = MainDIContainer(appDIContainer: self)
    private lazy var loadingDIContainer: LoadingDIContainer = LoadingDIContainer(appDIContainer: self)
}

extension AppDIContainer: ServiceFactory {

    // MARK: Core Services
    func makeNetworkService() -> NetworkServiceProtocol {
        return networkService
    }

    func makeSessionManager() -> SessionManagerProtocol {
        return sessionManager
    }

    func makeUserManager() -> UserManagerProtocol {
        return userManager
    }
}

extension AppDIContainer: ModuleContainerFactory {
    func makeMainDIContainer() -> MainDIContainer {
        return mainDIContainer
    }

    func makeLoadingDIContainer() -> LoadingDIContainer {
        return loadingDIContainer
    }
}

extension AppDIContainer: CoordinatorFactory {
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator {
        return AppCoordinator(window: window, container: self)
    }
}
