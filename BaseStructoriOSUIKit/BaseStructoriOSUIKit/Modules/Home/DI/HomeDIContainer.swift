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

// MARK: - Home DI Container
class HomeDIContainer {

    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    func makeHomeFlowCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        return HomeCoordinator(navigationController: navigationController, container: self)
    }
}

// MARK: - Home DI Container + Factory
extension HomeDIContainer: HomeFactoryProtocol {
    
    func makeHomeViewModel() -> HomeViewModel {
        let userService = appDIContainer.makeUserService()
        let getPokemonListUseCase = appDIContainer.makeGetPokemonListUseCase()
        print("🏠 HomeDIContainer - UserService: \(userService)")
        return HomeViewModel(
            userService: userService,
            getPokemonListUseCase: getPokemonListUseCase
        )
    }
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = makeHomeViewModel()
        return HomeViewController(viewModel: viewModel)
    }
    
    func makeHomeDetailViewModel(pokemonId: Int) -> HomeDetailViewModel {
        let getPokemonDetailUseCase = appDIContainer.makeGetPokemonDetailUseCase()
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
