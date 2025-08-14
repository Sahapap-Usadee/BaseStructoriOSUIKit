//
//  TodayDIContainer.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit

// MARK: - Today DI Container
class TodayDIContainer {
    
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    func makeTodayFlowCoordinator(navigationController: UINavigationController) -> TodayCoordinator {
        return TodayCoordinator(navigationController: navigationController, container: self)
    }
    
    func makeTodayViewModel() -> TodayViewModel {
        return TodayViewModel()
    }
    
    func makeTodayViewController() -> TodayViewController {
        let viewModel = makeTodayViewModel()
        return TodayViewController(viewModel: viewModel)
    }
    
    func makeTodayDetailViewController(card: TodayCard) -> TodayDetailViewController {
        return TodayDetailViewController(card: card)
    }
}
