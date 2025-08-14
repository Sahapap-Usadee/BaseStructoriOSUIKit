//
//  TabBarConfiguration.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

// MARK: - Tab Item Configuration
struct TabItemConfiguration {
    let title: String
    let image: UIImage?
    let selectedImage: UIImage?
    let tag: Int
    
    var tabBarItem: UITabBarItem {
        let item = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        item.tag = tag
        return item
    }
}

// MARK: - Tab Configuration
struct TabConfiguration {
    let viewControllerType: TabViewControllerType
    let tabItem: TabItemConfiguration
    let navigationStyle: NavigationBarStyle
}

// MARK: - Tab Types
enum TabViewControllerType {
    case home
    case list
    case settings
    case custom(UIViewController.Type)
}

// MARK: - Default Configurations
extension TabConfiguration {
    
    static var defaultTabs: [TabConfiguration] {
        return [
            TabConfiguration(
                viewControllerType: .home,
                tabItem: TabItemConfiguration(
                    title: "หน้าหลัก",
                    image: UIImage(systemName: "house"),
                    selectedImage: UIImage(systemName: "house.fill"),
                    tag: 0
                ),
                navigationStyle: .default
            ),
            TabConfiguration(
                viewControllerType: .list,
                tabItem: TabItemConfiguration(
                    title: "รายการ",
                    image: UIImage(systemName: "list.bullet"),
                    selectedImage: UIImage(systemName: "list.bullet.rectangle.fill"),
                    tag: 1
                ),
                navigationStyle: .colored(.systemBlue)
            ),
            TabConfiguration(
                viewControllerType: .settings,
                tabItem: TabItemConfiguration(
                    title: "ตั้งค่า",
                    image: UIImage(systemName: "gearshape"),
                    selectedImage: UIImage(systemName: "gearshape.fill"),
                    tag: 2
                ),
                navigationStyle: .default
            )
        ]
    }
}
