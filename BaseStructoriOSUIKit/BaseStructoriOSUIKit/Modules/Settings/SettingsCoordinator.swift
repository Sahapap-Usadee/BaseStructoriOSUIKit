//
//  SettingsCoordinator.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit
import Combine

class SettingsCoordinator: BaseCoordinator {
    private var cancellables = Set<AnyCancellable>()
    
    func createSettingsViewController() -> SettingsViewController {
        // Create ViewModel
        let viewModel = SettingsViewModel()
        
        // Create ViewController with ViewModel
        let viewController = SettingsViewController(viewModel: viewModel)
        
        // Subscribe to ViewModel events
        subscribeToViewModelEvents(viewModel)
        
        return viewController
    }
    
    private func subscribeToViewModelEvents(_ viewModel: SettingsViewModel) {
        viewModel.themeChangeRequested
            .sink { [weak self] isDarkMode in
                self?.handleThemeChange(isDarkMode)
            }
            .store(in: &cancellables)
        
        viewModel.aboutRequested
            .sink { [weak self] in
                self?.showAboutScreen()
            }
            .store(in: &cancellables)
        
        viewModel.resetRequested
            .sink { [weak self] in
                self?.showResetConfirmation()
            }
            .store(in: &cancellables)
    }
    
    private func handleThemeChange(_ isDarkMode: Bool) {
        // Handle theme change globally
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
    }
    
    private func showAboutScreen() {
        let aboutViewController = AboutViewController()
        let navController = UINavigationController(rootViewController: aboutViewController)
        navigationController.present(navController, animated: true)
    }
    
    private func showResetConfirmation() {
        let alert = UIAlertController(
            title: "รีเซ็ตการตั้งค่า",
            message: "คุณแน่ใจหรือไม่ที่จะรีเซ็ตการตั้งค่าทั้งหมดกลับเป็นค่าเริ่มต้น?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "รีเซ็ต", style: .destructive) { _ in
            // Reset confirmed
        })
        
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        
        navigationController.present(alert, animated: true)
    }
}

// MARK: - About View Controller (Simple implementation)
class AboutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "เกี่ยวกับแอป"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissTapped)
        )
        
        setupUI()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "BaseStructor iOS\nเวอร์ชัน 1.0.0\n\nแอปพลิเคชันตัวอย่างที่ใช้ MVVM-C Architecture"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func dismissTapped() {
        dismiss(animated: true)
    }
}
