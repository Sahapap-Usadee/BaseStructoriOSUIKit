//
//  MainCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class MainCoordinator: BaseCoordinator {
    
    override func start() {
        // Create child coordinators with separate navigation controllers
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        let listCoordinator = ListCoordinator(navigationController: UINavigationController())
        let settingsCoordinator = SettingsCoordinator(navigationController: UINavigationController())

        // Add child coordinators
        addChildCoordinator(homeCoordinator)
        addChildCoordinator(listCoordinator)
        addChildCoordinator(settingsCoordinator)
        
        // Create ViewControllers through coordinators
        let homeViewController = homeCoordinator.createHomeViewController()
        let listViewController = listCoordinator.createListViewController()
        let settingsViewController = settingsCoordinator.createSettingsViewController()
        
        // Set child coordinator reference (not main coordinator)
        homeViewController.coordinator = homeCoordinator
        listViewController.coordinator = listCoordinator
        settingsViewController.coordinator = settingsCoordinator

        // Create MainTabBarController with ViewControllers
        let mainTabBarController = MainTabBarController(
            homeViewController: homeViewController,
            listViewController: listViewController,
            settingsViewController: settingsViewController
        )
        mainTabBarController.coordinator = self
        
        // Set TabBarController as root (AppCoordinator will handle this)
        navigationController.setViewControllers([mainTabBarController], animated: true)
    }

}
