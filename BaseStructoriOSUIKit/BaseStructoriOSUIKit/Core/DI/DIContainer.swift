//
//  DIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

// MARK: - DI Container Protocol
protocol DIContainer {
    // Core Services
    func makeNetworkService() -> EnhancedNetworkServiceProtocol
    func makeSessionManager() -> SessionManagerProtocol
    func makeUserService() -> UserServiceProtocol

    // Module DI Containers
    func makeHomeDIContainer() -> HomeDIContainer
    func makeListDIContainer() -> ListDIContainer
    func makeSettingsDIContainer() -> SettingsDIContainer
    func makeMainDIContainer() -> MainDIContainer
}

//MARK: - App DI Container (Composition Root)
class AppDIContainer {
    static let shared = AppDIContainer()

    private init() {}

    // Session & Network
    private lazy var sessionManager: SessionManagerProtocol = SessionManager()
    private lazy var networkService: EnhancedNetworkServiceProtocol = EnhancedNetworkService(sessionManager: sessionManager)

    // Other Services
    private lazy var userService: UserServiceProtocol = UserService()
}

extension AppDIContainer: DIContainer {

    // MARK: Core Services
    func makeNetworkService() -> EnhancedNetworkServiceProtocol {
        return networkService
    }

    func makeSessionManager() -> SessionManagerProtocol {
        return sessionManager
    }

    func makeUserService() -> UserServiceProtocol {
        return userService
    }

    // MARK: Module Containers
    func makeHomeDIContainer() -> HomeDIContainer {
        return HomeDIContainer(appDIContainer: self)
    }

    func makeListDIContainer() -> ListDIContainer {
        return ListDIContainer(appDIContainer: self)
    }

    func makeSettingsDIContainer() -> SettingsDIContainer {
        return SettingsDIContainer(appDIContainer: self)
    }

    func makeMainDIContainer() -> MainDIContainer {
        return MainDIContainer(appDIContainer: self)
    }
}
