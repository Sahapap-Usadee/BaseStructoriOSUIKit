//
//  MainDIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import UIKit

// MARK: - Settings DI Container
class MainDIContainer {

    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }

    func makeMainFlowCoordinator(window: UIWindow) -> MainCoordinator {
        return MainCoordinator(window: window, container: appDIContainer)
    }
}
