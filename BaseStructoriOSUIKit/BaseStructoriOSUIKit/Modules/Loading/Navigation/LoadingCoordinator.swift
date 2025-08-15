//
//  LoadingCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class LoadingCoordinator: BaseCoordinator {
    var onFinishedLoading: (() -> Void)?

    override func start() {
        let loadingViewController = LoadingViewController()
        loadingViewController.coordinator = self
        
        navigationController.setViewControllers([loadingViewController], animated: false)
    }
    
    func didFinishLoading() {
        self.onFinishedLoading?()
    }
}
