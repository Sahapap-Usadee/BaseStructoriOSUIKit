//
//  HomeCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

final class HomeCoordinator: BaseCoordinator {

    private let container: HomeDIContainer

    init(navigationController: UINavigationController, container: HomeDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }

    func showDetail(pokemonId: Int, hidesBottomBar: Bool = true) {
        let vc = container.makeHomeDetailViewController(pokemonId: pokemonId)
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = hidesBottomBar
        push(vc)
    }

    func showDetailModal(pokemonId: Int) {
        let vc = container.makeHomeDetailViewController(pokemonId: pokemonId)
        vc.coordinator = self
        present(UINavigationController(rootViewController: vc), style: .fullScreen)
    }
}
