//
//  SettingsModels.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/12/2568 BE.
//

import Foundation

// MARK: - Settings Section
struct SettingsSection {
    let title: String
    let items: [SettingsItem]
}

// MARK: - Settings Item
struct SettingsItem {
    let title: String
    let icon: String
    let action: SettingsAction
}

// MARK: - Settings Action
enum SettingsAction {
    case profile
    case notifications
    case privacy
    case theme
    case language
    case about
    case help
    case contact
    case logout
}
