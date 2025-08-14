//
//  HomeFactory.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

// MARK: - Home Factory Protocol
protocol HomeFactoryProtocol {
    func makeHomeViewModel() -> HomeViewModel
    func makeHomeViewController() -> HomeViewController
    func makeHomeDetailViewController() -> HomeDetailViewController
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
        let networkService = appDIContainer.makeNetworkService()
        return HomeViewModel(userService: userService, networkService: networkService)
    }
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = makeHomeViewModel()
        return HomeViewController(viewModel: viewModel)
    }
    
    func makeHomeDetailViewController() -> HomeDetailViewController {
        return HomeDetailViewController()
    }
}
