//
//  HomeDIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

// MARK: - Home Factory Protocol
protocol HomeFactoryProtocol {
    func makeHomeViewModel() -> HomeViewModel
    func makeHomeViewController() -> HomeViewController
    func makeHomeDetailViewModel(pokemonId: Int) -> HomeDetailViewModel
    func makeHomeDetailViewController(pokemonId: Int) -> HomeDetailViewController
}

protocol HomeCoordinatorFactory {
    func makeHomeFlowCoordinator(navigationController: UINavigationController) -> HomeCoordinator
}

// MARK: - Home DI Container
class HomeDIContainer {

    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    // MARK: - Pokemon Data Layer 
    private lazy var pokemonRemoteDataSource: PokemonRemoteDataSourceProtocol = PokemonRemoteDataSource(networkService: appDIContainer.makeNetworkService())
    private lazy var pokemonRepository: PokemonRepositoryProtocol = PokemonRepositoryImpl(remoteDataSource: pokemonRemoteDataSource)
    private lazy var getPokemonListUseCase: GetPokemonListUseCaseProtocol = GetPokemonListUseCase(repository: pokemonRepository)
    private lazy var getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol = GetPokemonDetailUseCase(repository: pokemonRepository)
}

extension HomeDIContainer: HomeCoordinatorFactory {
    func makeHomeFlowCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        return HomeCoordinator(navigationController: navigationController, container: self)
    }
}

// MARK: - Home DI Container + Factory
extension HomeDIContainer: HomeFactoryProtocol {
    func makeHomeViewModel() -> HomeViewModel {
        let userManager = appDIContainer.makeUserManager()
        return HomeViewModel(
            userManager: userManager,
            getPokemonListUseCase: getPokemonListUseCase
        )
    }
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = makeHomeViewModel()
        return HomeViewController(viewModel: viewModel)
    }
    
    func makeHomeDetailViewModel(pokemonId: Int) -> HomeDetailViewModel {
        return HomeDetailViewModel(
            pokemonId: pokemonId,
            getPokemonDetailUseCase: getPokemonDetailUseCase
        )
    }
    
    func makeHomeDetailViewController(pokemonId: Int) -> HomeDetailViewController {
        let viewModel = makeHomeDetailViewModel(pokemonId: pokemonId)
        return HomeDetailViewController(viewModel: viewModel)
    }
}
