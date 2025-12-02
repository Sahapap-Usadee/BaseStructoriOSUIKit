//
//  MainDIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import UIKit

final class MainDIContainer {

    private let appDIContainer: AppDIContainer

    private lazy var homeDIContainer = HomeDIContainer(appDIContainer: appDIContainer)
    private lazy var listDIContainer = ListDIContainer(appDIContainer: appDIContainer)
    private lazy var settingsDIContainer = SettingsDIContainer(appDIContainer: appDIContainer)

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }

    // MARK: - Factory
    func makeMainFlowCoordinator(window: UIWindow) -> MainCoordinator {
        MainCoordinator(window: window, container: self)
    }

    func makeHomeDIContainer() -> HomeDIContainer { homeDIContainer }
    func makeListDIContainer() -> ListDIContainer { listDIContainer }
    func makeSettingsDIContainer() -> SettingsDIContainer { settingsDIContainer }
}
