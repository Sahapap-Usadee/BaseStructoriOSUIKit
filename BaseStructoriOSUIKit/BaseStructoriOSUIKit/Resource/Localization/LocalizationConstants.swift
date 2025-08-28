//
//  LocalizationKeys.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 27/8/2568 BE.
//

/*
// Pattern: screen_component_purpose
"home_title_welcome"           // หน้าแรก - title - ข้อความต้อนรับ
"profile_button_save"          // หน้าโปรไฟล์ - button - บันทึก
"settings_label_language"      // หน้าตั้งค่า - label - ภาษา
"login_error_invalid_password" // หน้าเข้าสู่ระบบ - error - รหัsสผิด

// หรือแบบ snake_case
"welcome_message"
"save_changes"
"delete_confirmation"
"item_count_plural"

// General/Common
"ok", "cancel", "save", "delete", "edit", "back"

// Navigation
"tab_home", "tab_profile", "tab_settings"

// Errors
"error_network", "error_invalid_input", "error_server"

// Messages
"success_saved", "warning_unsaved_changes"
 */


// MARK: - Localization Constants
struct LocalizationKeys {

    // MARK: Common
    struct Common {
        static let ok = "ok"
        static let cancel = "cancel"
        static let save = "save"
        static let delete = "delete"
        static let edit = "edit"
        static let back = "back"
        static let done = "done"
        static let next = "next"
        static let previous = "previous"
        static let close = "close"
        static let confirm = "confirm"
        static let yes = "yes"
        static let no = "no"
    }

    // MARK: Navigation
    struct Navigation {
        static let home = "tab_home"
        static let profile = "tab_profile"
        static let settings = "tab_settings"
    }

    // MARK: Errors
    struct Errors {
        static let network = "error_network"
        static let invalidInput = "error_invalid_input"
        static let serverError = "error_server"
        static let unknownError = "error_unknown"
    }

    // MARK: Messages
    struct Messages {
        static let successSaved = "success_saved"
        static let warningUnsaved = "warning_unsaved_changes"
        static let loadingMessage = "loading_message"
    }

    // MARK: Plurals
    struct Plurals {
        static let itemCount = "item_count_plural"
        static let notificationCount = "notification_count_plural"
        static let messageCount = "message_count_plural"
    }
}
