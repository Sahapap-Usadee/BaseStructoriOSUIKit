//
//  SettingsDIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

final class SettingsDIContainer {

    private let appDIContainer: AppDIContainer

    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }

    // MARK: - Factory
    func makeSettingsFlowCoordinator(navigationController: UINavigationController) -> SettingsCoordinator {
        SettingsCoordinator(navigationController: navigationController, container: self)
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(userManager: appDIContainer.makeUserManager())
    }

    func makeSettingsViewController() -> SettingsViewController {
        SettingsViewController(viewModel: makeSettingsViewModel())
    }

    func makeLocalizationTestViewController() -> LocalizationTestViewController {
        LocalizationTestViewController()
    }
}
