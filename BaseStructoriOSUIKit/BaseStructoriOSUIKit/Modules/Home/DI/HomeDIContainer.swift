//
//  HomeDIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

final class HomeDIContainer {

    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }

    // MARK: - Data Layer
    private lazy var pokemonRemoteDataSource: PokemonRemoteDataSourceProtocol = PokemonRemoteDataSource(networkService: appDIContainer.makeNetworkService())
    private lazy var pokemonRepository: PokemonRepositoryProtocol = PokemonRepositoryImpl(remoteDataSource: pokemonRemoteDataSource)
    private lazy var getPokemonListUseCase: GetPokemonListUseCaseProtocol = GetPokemonListUseCase(repository: pokemonRepository)
    private lazy var getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol = GetPokemonDetailUseCase(repository: pokemonRepository)

    // MARK: - Factory
    func makeHomeFlowCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        HomeCoordinator(navigationController: navigationController, container: self)
    }

    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(userManager: appDIContainer.makeUserManager(), getPokemonListUseCase: getPokemonListUseCase)
    }

    func makeHomeViewController() -> HomeViewController {
        HomeViewController(viewModel: makeHomeViewModel())
    }

    func makeHomeDetailViewModel(pokemonId: Int) -> HomeDetailViewModel {
        HomeDetailViewModel(pokemonId: pokemonId, getPokemonDetailUseCase: getPokemonDetailUseCase)
    }

    func makeHomeDetailViewController(pokemonId: Int) -> HomeDetailViewController {
        HomeDetailViewController(viewModel: makeHomeDetailViewModel(pokemonId: pokemonId))
    }
}
