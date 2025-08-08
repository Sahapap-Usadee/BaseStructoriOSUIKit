//
//  NavigationConfiguration.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

// MARK: - Navigation Configurable Protocol
protocol NavigationConfigurable: AnyObject {
    func configureNavigationBar()
    var navigationBarStyle: NavigationBarStyle { get }
    var navigationConfiguration: NavigationConfiguration { get }
}

// MARK: - Navigation Configuration Helper
class NavigationConfigurationHelper {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func configure(with config: NavigationConfiguration) {
        guard let viewController = viewController else { return }
        
        // Set title
        if let title = config.title {
            viewController.title = title
        }
        
        // Apply navigation style
        if let navigationController = viewController.navigationController {
            NavigationManager.shared.applyNavigationStyle(config.style, to: navigationController)
        }
        
        // Configure right button
        if let rightConfig = config.rightButtonConfig {
            let rightButton = UIBarButtonItem(
                image: rightConfig.image,
                style: .plain,
                target: self,
                action: #selector(rightButtonTapped)
            )
            rightButton.accessibilityLabel = "Right Button"
            viewController.navigationItem.rightBarButtonItem = rightButton
        }
        
        // Configure left button
        if let leftConfig = config.leftButtonConfig {
            let leftButton = UIBarButtonItem(
                image: leftConfig.image,
                style: .plain,
                target: self,
                action: #selector(leftButtonTapped)
            )
            leftButton.accessibilityLabel = "Left Button"
            viewController.navigationItem.leftBarButtonItem = leftButton
        }
        
        // Hide back button if needed
        if config.hideBackButton {
            viewController.navigationItem.hidesBackButton = true
        }
        
        // Set large title mode
        viewController.navigationItem.largeTitleDisplayMode = config.largeTitleMode
    }
    
    @objc private func rightButtonTapped() {
        if let configurable = viewController as? NavigationConfigurable {
            configurable.navigationConfiguration.rightButtonConfig?.action()
        }
    }
    
    @objc private func leftButtonTapped() {
        if let configurable = viewController as? NavigationConfigurable {
            configurable.navigationConfiguration.leftButtonConfig?.action()
        }
    }
}

// MARK: - Default Implementation
extension NavigationConfigurable where Self: UIViewController {
    var navigationBarStyle: NavigationBarStyle {
        return .default
    }
    
    var navigationConfiguration: NavigationConfiguration {
        return NavigationConfiguration()
    }
    
    func configureNavigationBar() {
        let helper = NavigationConfigurationHelper(viewController: self)
        helper.configure(with: navigationConfiguration)
    }
}

// MARK: - Navigation Builder
class NavigationBuilder {
    private var configuration = NavigationConfiguration()
    
    func title(_ title: String) -> NavigationBuilder {
        configuration.title = title
        return self
    }
    
    func style(_ style: NavigationBarStyle) -> NavigationBuilder {
        configuration.style = style
        return self
    }
    
    func rightButton(image: UIImage?, action: @escaping () -> Void) -> NavigationBuilder {
        configuration.rightButtonConfig = (image, action)
        return self
    }
    
    func leftButton(image: UIImage?, action: @escaping () -> Void) -> NavigationBuilder {
        configuration.leftButtonConfig = (image, action)
        return self
    }
    
    func hideBackButton(_ hide: Bool = true) -> NavigationBuilder {
        configuration.hideBackButton = hide
        return self
    }
    
    func largeTitleMode(_ mode: UINavigationItem.LargeTitleDisplayMode) -> NavigationBuilder {
        configuration.largeTitleMode = mode
        return self
    }
    
    func build() -> NavigationConfiguration {
        return configuration
    }
}
