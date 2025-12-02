//
//  SettingsViewController.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit
import Combine

class SettingsViewController: BaseViewModelController<SettingsViewModel> {

    // MARK: - Properties
    weak var coordinator: SettingsCoordinator?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Navigation Configuration
    override var navigationTitle: String? { "ตั้งค่า" }
    override var navigationStyle: NavigationBarStyle { .default }
    override var prefersLargeTitles: Bool { false }

    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let settingsData: [SettingsSection] = [
        SettingsSection(title: "ทั่วไป", items: [
            SettingsItem(title: "โปรไฟล์", icon: "person.circle", action: .profile),
            SettingsItem(title: "การแจ้งเตือน", icon: "bell", action: .notifications),
            SettingsItem(title: "ความเป็นส่วนตัว", icon: "lock.shield", action: .privacy)
        ]),
        SettingsSection(title: "แอปพลิเคชัน", items: [
            SettingsItem(title: "ธีม", icon: "paintbrush", action: .theme),
            SettingsItem(title: "ภาษา", icon: "globe", action: .language),
            SettingsItem(title: "เกี่ยวกับ", icon: "info.circle", action: .about)
        ]),
        SettingsSection(title: "การสนับสนุน", items: [
            SettingsItem(title: "ช่วยเหลือ", icon: "questionmark.circle", action: .help),
            SettingsItem(title: "ติดต่อเรา", icon: "envelope", action: .contact),
            SettingsItem(title: "ออกจากระบบ", icon: "rectangle.portrait.and.arrow.right", action: .logout)
        ])
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func showSuccessMessage(_ message: String) {
        let alert = UIAlertController(title: "สำเร็จ", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData[section].items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsData[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        let item = settingsData[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = settingsData[indexPath.section].items[indexPath.row]
        handleSettingsAction(item.action)
    }

    private func handleSettingsAction(_ action: SettingsAction) {
        switch action {
        case .profile:
            showAlert(title: "โปรไฟล์", message: "เปิดหน้าโปรไฟล์ผู้ใช้")
        case .notifications:
            showAlert(title: "การแจ้งเตือน", message: "ตั้งค่าการแจ้งเตือน")
        case .privacy:
            showAlert(title: "ความเป็นส่วนตัว", message: "ตั้งค่าความเป็นส่วนตัว")
        case .theme:
            showThemeSelector()
        case .language:
            coordinator?.showLocalizationTest()
        case .about:
            coordinator?.showAboutScreen()
        case .help:
            showAlert(title: "ช่วยเหลือ", message: "ศูนย์ช่วยเหลือ")
        case .contact:
            showAlert(title: "ติดต่อเรา", message: "ช่องทางการติดต่อ")
        case .logout:
            showLogoutConfirmation()
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
        present(alert, animated: true)
    }

    private func showThemeSelector() {
        let alert = UIAlertController(title: "เลือกธีม", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "ธีมสว่าง", style: .default) { _ in
            self.overrideUserInterfaceStyle = .light
        })

        alert.addAction(UIAlertAction(title: "ธีมมืด", style: .default) { _ in
            self.overrideUserInterfaceStyle = .dark
        })

        alert.addAction(UIAlertAction(title: "ตามระบบ", style: .default) { _ in
            self.overrideUserInterfaceStyle = .unspecified
        })

        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))

        if let popover = alert.popoverPresentationController {
            popover.sourceView = tableView
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }

        present(alert, animated: true)
    }

    private func showAboutApp() {
        let alert = UIAlertController(
            title: "เกี่ยวกับแอป",
            message: "BaseStructor iOS UIKit\nเวอร์ชัน 1.0.0\nสร้างด้วย MVVM-C Pattern",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
        present(alert, animated: true)
    }

    private func showLogoutConfirmation() {
        let alert = UIAlertController(
            title: "ออกจากระบบ",
            message: "คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "ออกจากระบบ", style: .destructive) { _ in
            self.coordinator?.signOut()
        })

        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))

        present(alert, animated: true)
    }
}

#Preview {
    SettingsViewController(viewModel: .init(userManager: AppDIContainer.shared.makeUserManager()))
}
