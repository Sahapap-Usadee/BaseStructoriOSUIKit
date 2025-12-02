//
//  ListCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

final class ListCoordinator: BaseCoordinator {

    private let container: ListDIContainer

    init(navigationController: UINavigationController, container: ListDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }

    func showModal() {
        let vc = ListModalViewController()
        vc.coordinator = self
        present(UINavigationController(rootViewController: vc), style: .pageSheet)
    }

    func showModalFull() {
        let vc = ListModalViewController()
        vc.coordinator = self
        present(UINavigationController(rootViewController: vc), style: .fullScreen)
    }

    func showActionSheet() {
        let sheet = UIAlertController(title: "เลือกการกระทำ", message: "กรุณาเลือกตัวเลือก", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "ตัวเลือก 1", style: .default))
        sheet.addAction(UIAlertAction(title: "ตัวเลือก 2", style: .default))
        sheet.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        present(sheet)
    }

    func showAlert() {
        let alert = UIAlertController(title: "แจ้งเตือน", message: "นี่คือการแจ้งเตือนจาก Coordinator", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
        present(alert)
    }
}
