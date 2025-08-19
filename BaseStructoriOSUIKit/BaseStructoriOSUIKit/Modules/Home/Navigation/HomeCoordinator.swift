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
    
    func showDetail(hidesBottomBar: Bool = true) {
        print("🔍 HomeCoordinator showDetail called")
        print("🔍 NavigationController: \(navigationController)")
        print("🔍 NavigationController viewControllers count: \(navigationController.viewControllers.count)")
        
        // สร้าง DetailViewController ผ่าน Module DI Container
        let detailViewController = container.makeHomeDetailViewController()
        detailViewController.coordinator = self
        
        // Hide TabBar when pushing (full screen)
        detailViewController.hidesBottomBarWhenPushed = hidesBottomBar

        navigationController.pushViewController(detailViewController, animated: true)
        
        print("🔍 After push - viewControllers count: \(navigationController.viewControllers.count)")
    }
    
    func showDetailModal() {
        print("🔍 HomeCoordinator showDetailModal called")
        
        let detailViewController = container.makeHomeDetailViewController()
        detailViewController.coordinator = self
        
        // Wrap in NavigationController for modal presentation
        let modalNavController = UINavigationController(rootViewController: detailViewController)
        modalNavController.modalPresentationStyle = .fullScreen
        presentViewController(modalNavController)
    }
    
    private func toggleTheme() {
        // Handle theme toggle logic
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                if window.overrideUserInterfaceStyle == .dark {
                    window.overrideUserInterfaceStyle = .light
                } else {
                    window.overrideUserInterfaceStyle = .dark
                }
            }
        }
    }
}
