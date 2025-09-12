//
//  HomeCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

class HomeCoordinator: BaseCoordinator {
    private let container: HomeDIContainer

    init(navigationController: UINavigationController, container: HomeDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
        print("🔍 HomeCoordinator created: \(self)")
    }
    
    deinit {
        print("🔍 HomeCoordinator deinit: \(self)")
    }
    
    func showDetail(pokemonId: Int, hidesBottomBar: Bool = true) {
        print("🔍 HomeCoordinator showDetail called with pokemonId: \(pokemonId)")
        print("🔍 NavigationController: \(navigationController)")
        print("🔍 NavigationController viewControllers count: \(navigationController.viewControllers.count)")
        
        // สร้าง DetailViewController ผ่าน Module DI Container
        let detailViewController = container.makeHomeDetailViewController(pokemonId: pokemonId)
        detailViewController.coordinator = self
        // Hide TabBar when pushing (full screen)
        detailViewController.hidesBottomBarWhenPushed = hidesBottomBar

        pushViewController(detailViewController, animated: true)
        
        print("🔍 After push - viewControllers count: \(navigationController.viewControllers.count)")
    }
    
    func showDetailModal(pokemonId: Int) {
        print("🔍 HomeCoordinator showDetailModal called with pokemonId: \(pokemonId)")
        
        let detailViewController = container.makeHomeDetailViewController(pokemonId: pokemonId)
        detailViewController.coordinator = self
        
        // Wrap in NavigationController for modal presentation
        let modalNavController = UINavigationController(rootViewController: detailViewController)
        modalNavController.modalPresentationStyle = .fullScreen
        presentViewController(modalNavController)
    }
}
