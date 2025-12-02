//
//  BaseCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 4/9/2568 BE.
//

import UIKit
import Combine

// MARK: - Coordinator Protocol
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

// MARK: - Base Coordinator
class BaseCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var cancellables = Set<AnyCancellable>()
    
    // Callback เมื่อ coordinator จบการทำงาน
    var onFinish: (() -> Void)?
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        fatalError("Subclass ต้อง implement start()")
    }
    
    // MARK: - Child Management
    
    /// Start child coordinator และ auto-remove เมื่อ finish
    func coordinate<T: BaseCoordinator>(to coordinator: T, animated: Bool = true, onFinish: (() -> Void)? = nil) {
        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else { return }
            self?.removeChild(coordinator)
            onFinish?()
        }
        addChild(coordinator)
        coordinator.start()
    }
    
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
    /// จบ coordinator และแจ้ง parent
    func finish() {
        childCoordinators.forEach { ($0 as? BaseCoordinator)?.finish() }
        childCoordinators.removeAll()
        cancellables.removeAll()
        onFinish?()
    }
    
    // MARK: - Navigation
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }
    
    func setRoot(_ viewController: UIViewController, animated: Bool = false) {
        navigationController.setViewControllers([viewController], animated: animated)
    }
    
    func present(_ viewController: UIViewController, style: UIModalPresentationStyle = .automatic, animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = style
        navigationController.present(viewController, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: - Utilities
    
    func topViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return nil }
        
        var top = window.rootViewController
        
        while let presented = top?.presentedViewController {
            top = presented
        }
        
        if let nav = top as? UINavigationController {
            return nav.topViewController
        }
        
        if let tab = top as? UITabBarController {
            if let nav = tab.selectedViewController as? UINavigationController {
                return nav.topViewController
            }
            return tab.selectedViewController
        }
        
        return top
    }
}
