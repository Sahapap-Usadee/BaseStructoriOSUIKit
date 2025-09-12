//
//  LoadingDIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 5/9/2568 BE.
//

import UIKit

// MARK: - Loading Factory Protocol
protocol LoadingFactoryProtocol {
    func makeLoadingViewModel() -> LoadingViewModel
    func makeLoadingViewController() -> LoadingViewController
}

protocol LoadingCoordinatorFactory {
    func makeLoadingFlowCoordinator(navigationController: UINavigationController) -> LoadingCoordinator
}

// MARK: - Loading DI Container
class LoadingDIContainer {
    
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
}

// MARK: - Coordinator Factory
extension LoadingDIContainer: LoadingCoordinatorFactory {
    func makeLoadingFlowCoordinator(navigationController: UINavigationController) -> LoadingCoordinator {
        return LoadingCoordinator(navigationController: navigationController, container: self)
    }
}

// MARK: - Factory Implementation
extension LoadingDIContainer: LoadingFactoryProtocol {
    
    func makeLoadingViewModel() -> LoadingViewModel {
        return LoadingViewModel()
    }
    
    func makeLoadingViewController() -> LoadingViewController {
        let viewModel = makeLoadingViewModel()
        return LoadingViewController(viewModel: viewModel)
    }
}
