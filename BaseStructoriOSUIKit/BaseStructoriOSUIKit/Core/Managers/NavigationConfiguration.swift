//
//  NavigationConfiguration.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

// MARK: - Navigation Configurable
protocol NavigationConfigurable: UIViewController {
    var navTitle: String? { get }
    var navStyle: NavigationBarStyle { get }
    var hideBackButton: Bool { get }
    var largeTitleMode: UINavigationItem.LargeTitleDisplayMode { get }
}

// MARK: - Default Values
extension NavigationConfigurable {
    var navTitle: String? { nil }
    var navStyle: NavigationBarStyle { .default }
    var hideBackButton: Bool { false }
    var largeTitleMode: UINavigationItem.LargeTitleDisplayMode { .automatic }
    
    func configureNavigationBar() {
        title = navTitle
        navigationItem.hidesBackButton = hideBackButton
        navigationItem.largeTitleDisplayMode = largeTitleMode
        
        if let nav = navigationController {
            NavigationManager.shared.apply(navStyle, to: nav)
        }
    }
}
