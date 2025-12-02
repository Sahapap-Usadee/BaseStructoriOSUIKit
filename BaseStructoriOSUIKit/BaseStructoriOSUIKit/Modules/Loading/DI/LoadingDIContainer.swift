//
//  LoadingDIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 5/9/2568 BE.
//

import UIKit

final class LoadingDIContainer {

    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }

    // MARK: - Factory
    func makeLoadingFlowCoordinator(navigationController: UINavigationController) -> LoadingCoordinator {
        LoadingCoordinator(navigationController: navigationController, container: self)
    }

    func makeLoadingViewModel() -> LoadingViewModel {
        LoadingViewModel()
    }

    func makeLoadingViewController() -> LoadingViewController {
        LoadingViewController(viewModel: makeLoadingViewModel())
    }
}
