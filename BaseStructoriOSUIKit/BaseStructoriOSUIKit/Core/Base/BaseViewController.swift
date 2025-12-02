//
//  BaseViewController.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 4/9/2568 BE.
//

import UIKit
import Combine

// MARK: - Base View Controller (Without ViewModel)
class BaseViewController: UIViewController {
    
    // MARK: - Navigation Configuration (Override in subclass)
    var navigationTitle: String? { nil }
    var navigationStyle: NavigationBarStyle { .default }
    var prefersLargeTitles: Bool { false }
    var hidesBackButton: Bool { false }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
    // MARK: - Navigation Setup
    private func configureNavigation() {
        title = navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.largeTitleDisplayMode = prefersLargeTitles ? .always : .never
        navigationItem.hidesBackButton = hidesBackButton
        applyNavigationStyle()
    }
    
    private func applyNavigationStyle() {
        guard let nav = navigationController else { return }
        
        let appearance = UINavigationBarAppearance()
        
        switch navigationStyle {
        case .default:
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
            nav.navigationBar.tintColor = .systemBlue
            nav.setNavigationBarHidden(false, animated: true)
            
        case .transparent:
            appearance.configureWithTransparentBackground()
            nav.setNavigationBarHidden(false, animated: true)
            
        case .colored(let color):
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = color
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            nav.navigationBar.tintColor = .white
            nav.setNavigationBarHidden(false, animated: true)
            
        case .hidden:
            nav.setNavigationBarHidden(true, animated: true)
            return
        }
        
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
    }
    
    // MARK: - Navigation Helpers
    func addRightButton(image: UIImage?, action: @escaping () -> Void) {
        let button = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        button.primaryAction = UIAction { _ in action() }
        navigationItem.rightBarButtonItem = button
    }
    
    func addRightButton(title: String, action: @escaping () -> Void) {
        let button = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        button.primaryAction = UIAction { _ in action() }
        navigationItem.rightBarButtonItem = button
    }
    
    func addLeftButton(image: UIImage?, action: @escaping () -> Void) {
        let button = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        button.primaryAction = UIAction { _ in action() }
        navigationItem.leftBarButtonItem = button
    }
}

// MARK: - Base View Controller with ViewModel
class BaseViewModelController<VM: ObservableObject>: BaseViewController {
    
    // MARK: - ViewModel
    public var viewModel: VM
    
    // MARK: - Init
    public init(viewModel: VM, bundle: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: bundle)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
