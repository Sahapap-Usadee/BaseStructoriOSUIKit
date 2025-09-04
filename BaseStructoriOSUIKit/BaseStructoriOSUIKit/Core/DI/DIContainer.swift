//
//  DIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

protocol DIContainer {
    func makeNetworkService() -> NetworkServiceProtocol
    func makeSessionManager() -> SessionManagerProtocol
    func makeUserManager() -> UserManagerProtocol

    func makeAppCoordinator(window: UIWindow) -> AppCoordinator

    func makeHomeDIContainer() -> HomeDIContainer
    func makeListDIContainer() -> ListDIContainer
    func makeSettingsDIContainer() -> SettingsDIContainer
    func makeMainDIContainer() -> MainDIContainer
}

//MARK: - App DI Container (Composition Root)
class AppDIContainer {
    static let shared = AppDIContainer()

    private init() {}

    private lazy var sessionManager: SessionManagerProtocol = SessionManager()
    private lazy var networkService: NetworkServiceProtocol = NetworkService(sessionManager: sessionManager)
    private lazy var userManager: UserManagerProtocol = UserManager()

    private lazy var homeDIContainer: HomeDIContainer = HomeDIContainer(appDIContainer: self)
    private lazy var listDIContainer: ListDIContainer = ListDIContainer(appDIContainer: self)
    private lazy var settingsDIContainer: SettingsDIContainer = SettingsDIContainer(appDIContainer: self)
    private lazy var mainDIContainer: MainDIContainer = MainDIContainer(appDIContainer: self)
}

extension AppDIContainer: DIContainer {
    func makeNetworkService() -> NetworkServiceProtocol {
        return networkService
    }

    func makeSessionManager() -> SessionManagerProtocol {
        return sessionManager
    }

    func makeUserManager() -> UserManagerProtocol {
        return userManager
    }

    func makeHomeDIContainer() -> HomeDIContainer {
        return homeDIContainer
    }

    func makeListDIContainer() -> ListDIContainer {
        return listDIContainer
    }

    func makeSettingsDIContainer() -> SettingsDIContainer {
        return settingsDIContainer
    }

    func makeMainDIContainer() -> MainDIContainer {
        return mainDIContainer
    }

    func makeAppCoordinator(window: UIWindow) -> AppCoordinator {
        return AppCoordinator(window: window, container: self)
    }
}
