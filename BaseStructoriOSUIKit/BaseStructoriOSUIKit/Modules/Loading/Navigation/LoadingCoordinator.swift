//
//  LoadingCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class LoadingCoordinator: BaseCoordinator {
    private let container: LoadingDIContainer
    var onFinishedLoading: (() -> Void)?

    init(navigationController: UINavigationController, container: LoadingDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }

    override func start() {
        let loadingViewController = container.makeLoadingViewController()
        loadingViewController.coordinator = self
        
        navigationController.setViewControllers([loadingViewController], animated: false)
    }
    
    func didFinishLoading() {
        self.onFinishedLoading?()
    }
}
