//
//  MainCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

final class MainCoordinator: BaseCoordinator {

    private let container: MainDIContainer
    private let window: UIWindow
    var onSignOut: (() -> Void)?

    init(window: UIWindow, container: MainDIContainer) {
        self.window = window
        self.container = container
        super.init()
    }

    override func start() {
        let tabBar = MainTabBarController()
        tabBar.coordinator = self
        tabBar.setViewControllers([
            createHomeTab(),
            createListTab(),
            createSettingsTab()
        ])

        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }

    // MARK: - Tabs

    private func createHomeTab() -> UINavigationController {
        let homeDI = container.makeHomeDIContainer()
        let homeVC = homeDI.makeHomeViewController()

        let nav = NavigationManager.shared.createNavigationController(rootViewController: homeVC, style: .default)
        nav.tabBarItem = UITabBarItem(title: "หน้าหลัก", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        let coordinator = homeDI.makeHomeFlowCoordinator(navigationController: nav)
        addChild(coordinator)
        homeVC.coordinator = coordinator

        return nav
    }

    private func createListTab() -> UINavigationController {
        let listDI = container.makeListDIContainer()
        let listVC = listDI.makeListViewController()

        let nav = NavigationManager.shared.createNavigationController(rootViewController: listVC, style: .colored(.systemBlue))
        nav.tabBarItem = UITabBarItem(title: "รายการ", image: UIImage(systemName: "list.bullet"), selectedImage: UIImage(systemName: "list.bullet.rectangle.fill"))

        let coordinator = listDI.makeListFlowCoordinator(navigationController: nav)
        addChild(coordinator)
        listVC.coordinator = coordinator

        return nav
    }

    private func createSettingsTab() -> UINavigationController {
        let settingsDI = container.makeSettingsDIContainer()
        let settingsVC = settingsDI.makeSettingsViewController()

        let nav = NavigationManager.shared.createNavigationController(rootViewController: settingsVC, style: .default)
        nav.tabBarItem = UITabBarItem(title: "ตั้งค่า", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))

        let coordinator = settingsDI.makeSettingsFlowCoordinator(navigationController: nav)
        coordinator.onSignOut = { [weak self] in self?.onSignOut?() }
        addChild(coordinator)
        settingsVC.coordinator = coordinator

        return nav
    }
}
