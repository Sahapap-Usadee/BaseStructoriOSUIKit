//
//  MainCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class MainCoordinator: BaseCoordinator {
    
    override func start() {
        let mainTabBarController = MainTabBarController()
        mainTabBarController.coordinator = self
        
        navigationController.setViewControllers([mainTabBarController], animated: true)
    }
    
    // MARK: - Tab Navigation Methods
    func showTabOneDetail() {
        let tabOneCoordinator = TabOneCoordinator(navigationController: navigationController)
        addChildCoordinator(tabOneCoordinator)
        tabOneCoordinator.showDetail()
    }
    
    func showModalFromTabTwo() {
        let tabTwoCoordinator = TabTwoCoordinator(navigationController: navigationController)
        addChildCoordinator(tabTwoCoordinator)
        tabTwoCoordinator.showModal()
    }
}
