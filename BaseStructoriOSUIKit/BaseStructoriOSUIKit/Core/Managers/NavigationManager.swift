//
//  NavigationManager.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

// MARK: - Navigation Bar Style
enum NavigationBarStyle {
    case `default`
    case transparent
    case colored(UIColor)
    case hidden
}

// MARK: - Navigation Manager
final class NavigationManager {
    
    static let shared = NavigationManager()
    private init() {}
    
    // MARK: - Global Setup
    func setupGlobalAppearance(
        tintColor: UIColor = .systemBlue,
        backgroundColor: UIColor = .systemBackground,
        hideBackButtonText: Bool = true
    ) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = tintColor
        
        if hideBackButtonText {
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(
                UIOffset(horizontal: -1000, vertical: 0), for: .default
            )
        }
    }
    
    // MARK: - Factory
    func createNavigationController(
        rootViewController: UIViewController,
        style: NavigationBarStyle = .default
    ) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        apply(style, to: nav)
        return nav
    }
    
    // MARK: - Apply Style
    func apply(_ style: NavigationBarStyle, to nav: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        
        switch style {
        case .default:
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            nav.setNavigationBarHidden(false, animated: false)
            
        case .transparent:
            appearance.configureWithTransparentBackground()
            nav.setNavigationBarHidden(false, animated: false)
            
        case .colored(let color):
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = color
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            nav.navigationBar.tintColor = .white
            
        case .hidden:
            nav.setNavigationBarHidden(true, animated: false)
            return
        }
        
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
    }
}

// MARK: - UIViewController Extension
extension UIViewController {
    
    func setNavTitle(_ title: String) {
        self.title = title
    }
    
    func setNavStyle(_ style: NavigationBarStyle) {
        guard let nav = navigationController else { return }
        NavigationManager.shared.apply(style, to: nav)
    }
    
    func addNavButton(
        position: NavButtonPosition,
        image: UIImage?,
        action: @escaping () -> Void
    ) {
        let button = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        button.primaryAction = UIAction { _ in action() }
        
        switch position {
        case .left:  navigationItem.leftBarButtonItem = button
        case .right: navigationItem.rightBarButtonItem = button
        }
    }
    
    func addNavButton(
        position: NavButtonPosition,
        title: String,
        action: @escaping () -> Void
    ) {
        let button = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        button.primaryAction = UIAction { _ in action() }
        
        switch position {
        case .left:  navigationItem.leftBarButtonItem = button
        case .right: navigationItem.rightBarButtonItem = button
        }
    }
}

enum NavButtonPosition {
    case left, right
}
