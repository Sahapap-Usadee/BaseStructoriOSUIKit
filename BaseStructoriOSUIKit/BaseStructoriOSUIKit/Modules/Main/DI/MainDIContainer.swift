//
//  MainDIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import UIKit

protocol MainModuleContainerFactory {
    func makeHomeDIContainer() -> HomeDIContainer
    func makeListDIContainer() -> ListDIContainer
    func makeSettingsDIContainer() -> SettingsDIContainer
}

class MainDIContainer {

    private let appDIContainer: AppDIContainer

    private lazy var homeDIContainer: HomeDIContainer = HomeDIContainer(appDIContainer: appDIContainer)
    private lazy var listDIContainer: ListDIContainer = ListDIContainer(appDIContainer: appDIContainer)
    private lazy var settingsDIContainer: SettingsDIContainer = SettingsDIContainer(appDIContainer: appDIContainer)

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }

    func makeMainFlowCoordinator(window: UIWindow) -> MainCoordinator {
        return MainCoordinator(window: window, container: self)
    }
}

extension MainDIContainer: MainModuleContainerFactory {
    func makeHomeDIContainer() -> HomeDIContainer {
        return homeDIContainer
    }

    func makeListDIContainer() -> ListDIContainer {
        return listDIContainer
    }

    func makeSettingsDIContainer() -> SettingsDIContainer {
        return settingsDIContainer
    }
}
