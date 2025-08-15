//
//  UIViewController+Extensions.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

extension UIViewController {
    
    // MARK: - Navigation Helpers
    func hideNavigationBarOnSwipe() {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func setCustomBackButton(image: UIImage? = nil, title: String? = nil) {
        let backButton = UIBarButtonItem()
        backButton.title = title ?? ""
        backButton.image = image
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setNavigationBarGradient(colors: [UIColor]) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = navigationBar.bounds
        
        if let gradientImage = gradientLayer.toImage() {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundImage = gradientImage
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    // MARK: - Alert Helpers
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    func showConfirmationAlert(
        title: String,
        message: String,
        confirmTitle: String = "ยืนยัน",
        cancelTitle: String = "ยกเลิก",
        confirmAction: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: confirmTitle, style: .destructive) { _ in
            confirmAction()
        })
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        
        present(alert, animated: true)
    }
    
    // MARK: - Loading Helpers
    func showLoading() {
        let alert = UIAlertController(title: nil, message: "กำลังโหลด...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        
        alert.setValue(loadingIndicator, forKey: "accessoryView")
        present(alert, animated: true)
    }
    
    func hideLoading() {
        if presentedViewController is UIAlertController {
            dismiss(animated: true)
        }
    }
    
    // MARK: - Keyboard Handling
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        // Override in subclass if needed
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // Override in subclass if needed
    }
    
    // MARK: - Accessibility
    func configureAccessibility() {
        navigationItem.rightBarButtonItem?.accessibilityLabel = "เพิ่มรายการใหม่"
        navigationItem.leftBarButtonItem?.accessibilityLabel = "ย้อนกลับ"
    }
}
