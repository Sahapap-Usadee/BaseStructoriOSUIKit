//
//  BaseViewController.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 4/9/2568 BE.
//

import UIKit

// MARK: - Base View Controller
class BaseViewController<T>: UIViewController {
    public var viewModel: T

    public init(viewModel: T, bundle: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: bundle)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
