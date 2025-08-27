//
//  String+Extensions.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit

// MARK: - String Localization Extension
extension String {
    /// Example: "hello_world".localized → "Hello, World!" / "สวัสดีชาวโลก!"
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    /// Localization with comment
    /// Example: "login_button".localized(comment: "Main login button text")
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    /// Localization with string formatting
    /// Example: "welcome_user".localized(with: "John") → "Welcome, John!" / "ยินดีต้อนรับ John!"
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }

    /// Localization with array of arguments
    /// Example: "user_score".localized(with: ["John", 100]) → "John scored 100 points!"
    func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized, arguments: arguments)
    }

    /// Pluralization support
    /// Example: "item_count".localizedPlural(count: 5) → "5 items" / "5 รายการ"
    func localizedPlural(count: Int) -> String {
        return String.localizedStringWithFormat(self.localized, count)
    }
}

extension String {
    
    // MARK: - Validation
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    var isNotEmpty: Bool {
        return !isEmpty && trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
    
    // MARK: - Formatting
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func truncated(to length: Int, trailing: String = "...") -> String {
        if count <= length {
            return self
        }
        return String(prefix(length)) + trailing
    }
    
    // MARK: - Date Formatting
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "th_TH")
        return formatter.date(from: self)
    }
    
    // MARK: - URL
    var url: URL? {
        return URL(string: self)
    }
    
    // MARK: - Thai Number Conversion
    var thaiNumbers: String {
        let thaiNumerals = ["๐", "๑", "๒", "๓", "๔", "๕", "๖", "๗", "๘", "๙"]
        var result = self
        
        for (index, numeral) in thaiNumerals.enumerated() {
            result = result.replacingOccurrences(of: "\(index)", with: numeral)
        }
        
        return result
    }
    
    var arabicNumbers: String {
        let thaiNumerals = ["๐", "๑", "๒", "๓", "๔", "๕", "๖", "๗", "๘", "๙"]
        var result = self
        
        for (index, numeral) in thaiNumerals.enumerated() {
            result = result.replacingOccurrences(of: numeral, with: "\(index)")
        }
        
        return result
    }
    
    // MARK: - Currency Formatting
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "th_TH")
        
        if let number = Double(self), let formattedString = formatter.string(from: NSNumber(value: number)) {
            return formattedString
        }
        
        return self
    }
    
    // MARK: - HTML
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            return nil
        }
    }
    
    // MARK: - Substring
    func substring(from index: Int) -> String {
        guard index >= 0, index < count else { return "" }
        return String(suffix(count - index))
    }
    
    func substring(to index: Int) -> String {
        guard index >= 0, index <= count else { return "" }
        return String(prefix(index))
    }
    
    func substring(from: Int, to: Int) -> String {
        guard from >= 0, to >= from, to <= count else { return "" }
        let start = index(startIndex, offsetBy: from)
        let end = index(startIndex, offsetBy: to)
        return String(self[start..<end])
    }
}
