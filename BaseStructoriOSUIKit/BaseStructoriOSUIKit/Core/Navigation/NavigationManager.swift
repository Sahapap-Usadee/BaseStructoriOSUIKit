//
//  NavigationManager.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

// MARK: - Navigation Configuration
struct NavigationConfiguration {
    var title: String?
    var style: NavigationBarStyle = .default
    var rightButtonConfig: (image: UIImage?, action: (() -> Void))?
    var leftButtonConfig: (image: UIImage?, action: (() -> Void))?
    var hideBackButton: Bool = false
    var largeTitleMode: UINavigationItem.LargeTitleDisplayMode = .automatic
}

// MARK: - Navigation Bar Style
enum NavigationBarStyle {
    case `default`
    case transparent
    case colored(UIColor)
    case gradient([UIColor])
    case hidden
    case custom(NavigationBarConfiguration)
}

struct NavigationBarConfiguration {
    let backgroundColor: UIColor?
    let titleColor: UIColor?
    let titleFont: UIFont?
    let isTranslucent: Bool
    let prefersLargeTitles: Bool
    let hideBackButtonText: Bool
    let customBackButton: UIImage?
}

// MARK: - Navigation Manager
class NavigationManager {
    static let shared = NavigationManager()
    
    private init() {}
    
    // MARK: - Global Setup
    func setupGlobalAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        // Back button configuration
        UINavigationBar.appearance().tintColor = .systemBlue
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(
            UIOffset(horizontal: -1000, vertical: 0),
            for: .default
        )
    }
    
    // MARK: - Navigation Factory
    func createNavigationController(
        rootViewController: UIViewController,
        style: NavigationBarStyle = .default
    ) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        applyNavigationStyle(style, to: navController)
        return navController
    }
    
    // MARK: - Style Application
    func applyNavigationStyle(_ style: NavigationBarStyle, to navigationController: UINavigationController) {
        switch style {
        case .default:
            setDefaultNavigationStyle(navigationController)
        case .transparent:
            setTransparentNavigationStyle(navigationController)
        case .colored(let color):
            setColoredNavigationStyle(color, navigationController)
        case .gradient(let colors):
            setGradientNavigationStyle(colors, navigationController)
        case .hidden:
            navigationController.setNavigationBarHidden(true, animated: false)
        case .custom(let config):
            setCustomNavigationStyle(config, navigationController)
        }
    }
    
    // MARK: - Private Style Methods
    private func setDefaultNavigationStyle(_ navigationController: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.setNavigationBarHidden(false, animated: false)
    }
    
    private func setTransparentNavigationStyle(_ navigationController: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.setNavigationBarHidden(false, animated: false)
    }
    
    private func setColoredNavigationStyle(_ color: UIColor, _ navigationController: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setGradientNavigationStyle(_ colors: [UIColor], _ navigationController: UINavigationController) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = navigationController.navigationBar.bounds
        
        let gradientImage = gradientLayer.toImage()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundImage = gradientImage
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setCustomNavigationStyle(_ config: NavigationBarConfiguration, _ navigationController: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        
        if let backgroundColor = config.backgroundColor {
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundColor
        } else {
            appearance.configureWithTransparentBackground()
        }
        
        if let titleColor = config.titleColor, let titleFont = config.titleFont {
            appearance.titleTextAttributes = [
                .foregroundColor: titleColor,
                .font: titleFont
            ]
        }
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.isTranslucent = config.isTranslucent
        navigationController.navigationBar.prefersLargeTitles = config.prefersLargeTitles
    }
}

// MARK: - CALayer Extension
extension CALayer {
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
