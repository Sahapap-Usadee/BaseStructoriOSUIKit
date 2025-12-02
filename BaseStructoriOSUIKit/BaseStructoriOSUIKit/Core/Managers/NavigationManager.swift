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

// MARK: - Navigation Manager (Global Setup Only)
final class NavigationManager {
    
    static let shared = NavigationManager()
    private init() {}
    
    /// Call once in AppDelegate or SceneDelegate
    func setupGlobalAppearance(
        tintColor: UIColor = .systemBlue,
        backgroundColor: UIColor = .systemBackground
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
        
        // Hide back button text globally
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(
            UIOffset(horizontal: -1000, vertical: 0), for: .default
        )
    }
}
