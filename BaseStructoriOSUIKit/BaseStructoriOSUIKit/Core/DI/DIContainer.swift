//
//  DIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

// MARK: - Pokemon Data Sources Container
protocol PokemonDataSourceContainer {
    func makePokemonRemoteDataSource() -> PokemonRemoteDataSourceProtocol
}

class DefaultPokemonDataSourceContainer: PokemonDataSourceContainer {
    private let networkService: EnhancedNetworkServiceProtocol
    
    init(networkService: EnhancedNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func makePokemonRemoteDataSource() -> PokemonRemoteDataSourceProtocol {
        return PokemonRemoteDataSource(networkService: networkService)
    }
}

// MARK: - Pokemon Use Cases Container
protocol PokemonUseCaseContainer {
    func makeGetPokemonListUseCase() -> GetPokemonListUseCaseProtocol
    func makeGetPokemonDetailUseCase() -> GetPokemonDetailUseCaseProtocol
}

class DefaultPokemonUseCaseContainer: PokemonUseCaseContainer {
    private let repository: PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
    
    func makeGetPokemonListUseCase() -> GetPokemonListUseCaseProtocol {
        return GetPokemonListUseCase(repository: repository)
    }
    
    func makeGetPokemonDetailUseCase() -> GetPokemonDetailUseCaseProtocol {
        return GetPokemonDetailUseCase(repository: repository)
    }
}

// MARK: - DI Container Protocol
protocol DIContainer {
        // Services
    func makeNetworkService() -> EnhancedNetworkServiceProtocol
    func makeImageService() -> ImageServiceProtocol
    func makeSessionManager() -> SessionManagerProtocol
    func makeUserService() -> UserServiceProtocol
    
    // Data Layer
    func makePokemonRemoteDataSource() -> PokemonRemoteDataSourceProtocol
    func makePokemonRepository() -> PokemonRepositoryProtocol
    
    // Use Cases
    func makeGetPokemonListUseCase() -> GetPokemonListUseCaseProtocol
    func makeGetPokemonDetailUseCase() -> GetPokemonDetailUseCaseProtocol
    
    // Module DI Containers
    func makeHomeDIContainer() -> HomeDIContainer
    func makeListDIContainer() -> ListDIContainer
    func makeSettingsDIContainer() -> SettingsDIContainer
    
    // Main Coordinator
    func makeMainCoordinator(window: UIWindow) -> MainCoordinator
}

//MARK: - App DI Container
class AppDIContainer: DIContainer {
    
    // Singleton instance
    static let shared = AppDIContainer()
    
    private init() {}
    
    // MARK: - Lazy Service Instances
    
    // Core Services
    private lazy var userService: UserServiceProtocol = {
        return UserService()
    }()
    
    private lazy var tokenDataSource: TokenLocalDataSource = {
        return TokenDefaultsDataSource()
    }()
    
    private lazy var tokenUseCase: TokenUseCaseProtocol = {
        return TokenUseCase(dataSource: tokenDataSource)
    }()
    
    private lazy var sessionManager: SessionManagerProtocol = {
        return SessionManager(tokenUseCase: tokenUseCase)
    }()
    
    private lazy var networkService: EnhancedNetworkServiceProtocol = {
        return EnhancedNetworkService(sessionManager: sessionManager)
    }()
    
    private lazy var imageService: ImageServiceProtocol = {
        return ImageService()
    }()
    
    // Pokemon Data Sources Container
    private lazy var pokemonDataSourceContainer: PokemonDataSourceContainer = {
        return DefaultPokemonDataSourceContainer(networkService: makeNetworkService())
    }()
    
    // Pokemon Repository
    private lazy var pokemonRepository: PokemonRepositoryProtocol = {
        return PokemonRepositoryImpl(
            remoteDataSource: pokemonDataSourceContainer.makePokemonRemoteDataSource()
        )
    }()
    
    // Pokemon Use Cases Container  
    private lazy var pokemonUseCaseContainer: PokemonUseCaseContainer = {
        return DefaultPokemonUseCaseContainer(repository: pokemonRepository)
    }()
    
    // MARK: - Core Services Factory Methods
    
    func makeUserService() -> UserServiceProtocol {
        return userService
    }
    
    func makeNetworkService() -> EnhancedNetworkServiceProtocol {
        return networkService
    }
    
    func makeImageService() -> ImageServiceProtocol {
        return imageService
    }
    
    func makeSessionManager() -> SessionManagerProtocol {
        return sessionManager
    }
    
    // MARK: - Data Layer Factory Methods
    
    func makePokemonRemoteDataSource() -> PokemonRemoteDataSourceProtocol {
        return pokemonDataSourceContainer.makePokemonRemoteDataSource()
    }
    
    func makePokemonRepository() -> PokemonRepositoryProtocol {
        return pokemonRepository
    }
    
    // MARK: - Use Cases Factory Methods
    
    func makeGetPokemonListUseCase() -> GetPokemonListUseCaseProtocol {
        return pokemonUseCaseContainer.makeGetPokemonListUseCase()
    }
    
    func makeGetPokemonDetailUseCase() -> GetPokemonDetailUseCaseProtocol {
        return pokemonUseCaseContainer.makeGetPokemonDetailUseCase()
    }
    
    // MARK: - Module DI Containers Factory Methods
    
    func makeHomeDIContainer() -> HomeDIContainer {
        return HomeDIContainer(appDIContainer: self)
    }
    
    func makeListDIContainer() -> ListDIContainer {
        return ListDIContainer(appDIContainer: self)
    }
    
    func makeSettingsDIContainer() -> SettingsDIContainer {
        return SettingsDIContainer(appDIContainer: self)
    }
    
    func makeMainCoordinator(window: UIWindow) -> MainCoordinator {
        return MainCoordinator(
            window: window,
            container: self
        )
    }
}
