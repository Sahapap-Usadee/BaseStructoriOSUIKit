//
//  ListDIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

// MARK: - List Factory Protocol
protocol ListFactoryProtocol {
    func makeListViewModel() -> ListViewModel
    func makeListViewController() -> ListViewController
}

// MARK: - List DI Container
class ListDIContainer {
    
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    func makeListFlowCoordinator(navigationController: UINavigationController) -> ListCoordinator {
        return ListCoordinator(navigationController: navigationController, container: self)
    }
}

// MARK: - List DI Container + Factory
extension ListDIContainer: ListFactoryProtocol {
    
    func makeListViewModel() -> ListViewModel {
        let userManager = appDIContainer.makeUserManager()
        return ListViewModel(userManager: userManager)
    }
    
    func makeListViewController() -> ListViewController {
        let viewModel = makeListViewModel()
        return ListViewController(viewModel: viewModel)
    }
}
