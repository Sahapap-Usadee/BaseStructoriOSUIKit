//
//  LoadingCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

final class LoadingCoordinator: BaseCoordinator {

    private let container: LoadingDIContainer
    var onFinishedLoading: (() -> Void)?

    init(navigationController: UINavigationController, container: LoadingDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }

    override func start() {
        let vc = container.makeLoadingViewController()
        vc.coordinator = self
        setRoot(vc)
    }

    func didFinishLoading() {
        onFinishedLoading?()
    }
}
