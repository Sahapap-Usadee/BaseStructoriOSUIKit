//
//  DIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

// MARK: - DI Container Protocol
protocol DIContainer {
    // Core Services เท่านั้น
    func makeNetworkService() -> NetworkServiceProtocol
    func makeUserService() -> UserServiceProtocol
    func makeImageService() -> ImageServiceProtocol
    
    // Module DI Containers
    func makeHomeDIContainer() -> HomeDIContainer
    func makeListDIContainer() -> ListDIContainer
    func makeSettingsDIContainer() -> SettingsDIContainer
    
    // Main Coordinator
    func makeMainCoordinator() -> MainCoordinator
}

// MARK: - App DI Container
class AppDIContainer: DIContainer {
    
    // Singleton instance
    static let shared = AppDIContainer()
    
    // Services (lazy loading)
    private lazy var networkService: NetworkServiceProtocol = NetworkService()
    private lazy var userService: UserServiceProtocol = UserService()
    private lazy var imageService: ImageServiceProtocol = ImageService(networkService: networkService)
    
    // Module DI Containers (lazy loading)
    private lazy var homeDIContainer: HomeDIContainer = HomeDIContainer(appDIContainer: self)
    private lazy var listDIContainer: ListDIContainer = ListDIContainer(appDIContainer: self)
    private lazy var settingsDIContainer: SettingsDIContainer = SettingsDIContainer(appDIContainer: self)
    
    private init() {}
    
    // MARK: - Services
    func makeNetworkService() -> NetworkServiceProtocol {
        return networkService
    }
    
    func makeUserService() -> UserServiceProtocol {
        return userService
    }
    
    func makeImageService() -> ImageServiceProtocol {
        return imageService
    }
    
    // MARK: - Module DI Containers
    func makeHomeDIContainer() -> HomeDIContainer {
        return homeDIContainer
    }
    
    func makeListDIContainer() -> ListDIContainer {
        return listDIContainer
    }
    
    func makeSettingsDIContainer() -> SettingsDIContainer {
        return settingsDIContainer
    }
    
    // MARK: - Main Coordinator
    func makeMainCoordinator() -> MainCoordinator {
        return MainCoordinator(container: self)
    }
}
