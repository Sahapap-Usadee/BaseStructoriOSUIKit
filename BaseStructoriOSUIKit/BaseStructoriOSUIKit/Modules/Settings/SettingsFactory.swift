//
//  SettingsFactory.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

// MARK: - Settings Factory Protocol
protocol SettingsFactoryProtocol {
    func makeSettingsViewModel() -> SettingsViewModel
    func makeSettingsViewController() -> SettingsViewController
}

// MARK: - Settings DI Container
class SettingsDIContainer {
    
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    func makeSettingsFlowCoordinator(navigationController: UINavigationController) -> SettingsCoordinator {
        return SettingsCoordinator(navigationController: navigationController, container: self)
    }
}

// MARK: - Settings DI Container + Factory
extension SettingsDIContainer: SettingsFactoryProtocol {
    
    func makeSettingsViewModel() -> SettingsViewModel {
        let userService = appDIContainer.makeUserService()
        return SettingsViewModel(userService: userService)
    }
    
    func makeSettingsViewController() -> SettingsViewController {
        let viewModel = makeSettingsViewModel()
        return SettingsViewController(viewModel: viewModel)
    }
}
