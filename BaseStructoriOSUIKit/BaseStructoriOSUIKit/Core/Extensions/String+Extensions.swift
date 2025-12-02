//
//  String+Extensions.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import Foundation

// MARK: - String Localization Extension
extension String {
    
    /// Example: "hello_world".localized → "Hello, World!" / "สวัสดีชาวโลก!"
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Localization with string formatting
    /// Example: "welcome_user".localized(with: "John") → "Welcome, John!"
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
    /// Pluralization support
    /// Example: "item_count".localizedPlural(count: 5) → "5 items"
    func localizedPlural(count: Int) -> String {
        return String.localizedStringWithFormat(self.localized, count)
    }
}
