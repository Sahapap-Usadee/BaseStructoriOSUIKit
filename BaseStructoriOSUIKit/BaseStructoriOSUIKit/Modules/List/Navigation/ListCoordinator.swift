//
//  ListCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit
import Combine

class ListCoordinator: BaseCoordinator {
    private var cancellables = Set<AnyCancellable>()
    private let container: ListDIContainer
    
    init(navigationController: UINavigationController, container: ListDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }
    
    func showModal() {
        let modalViewController = ListModalViewController()
        modalViewController.coordinator = self
        
        let modalNavController = UINavigationController(rootViewController: modalViewController)
        modalNavController.modalPresentationStyle = .pageSheet
        
        navigationController.present(modalNavController, animated: true)
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "เลือกการกระทำ", message: "กรุณาเลือกตัวเลือก", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "ตัวเลือก 1", style: .default) { _ in
            print("เลือกตัวเลือก 1")
        })
        
        actionSheet.addAction(UIAlertAction(title: "ตัวเลือก 2", style: .default) { _ in
            print("เลือกตัวเลือก 2")
        })
        
        actionSheet.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        
        navigationController.present(actionSheet, animated: true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "แจ้งเตือน", message: "นี่คือการแจ้งเตือนจาก Coordinator", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
        navigationController.present(alert, animated: true)
    }
}
