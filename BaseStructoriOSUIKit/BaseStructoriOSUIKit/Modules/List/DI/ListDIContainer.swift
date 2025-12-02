//
//  ListDIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

final class ListDIContainer {

    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }

    // MARK: - Factory
    func makeListFlowCoordinator(navigationController: UINavigationController) -> ListCoordinator {
        ListCoordinator(navigationController: navigationController, container: self)
    }

    func makeListViewModel() -> ListViewModel {
        ListViewModel(userManager: appDIContainer.makeUserManager())
    }

    func makeListViewController() -> ListViewController {
        ListViewController(viewModel: makeListViewModel())
    }
}
