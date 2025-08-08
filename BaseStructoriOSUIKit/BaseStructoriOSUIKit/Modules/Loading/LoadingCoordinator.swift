//
//  LoadingCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

protocol LoadingCoordinatorDelegate: AnyObject {
    func loadingDidComplete()
}

class LoadingCoordinator: BaseCoordinator {
    weak var delegate: LoadingCoordinatorDelegate?
    
    override func start() {
        let loadingViewController = LoadingViewController()
        loadingViewController.coordinator = self
        
        navigationController.setViewControllers([loadingViewController], animated: false)
    }
    
    func didFinishLoading() {
        delegate?.loadingDidComplete()
    }
}
