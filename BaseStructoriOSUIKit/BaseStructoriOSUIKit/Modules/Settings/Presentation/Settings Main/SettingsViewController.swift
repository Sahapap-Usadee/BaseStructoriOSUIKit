//
//  SettingsViewController.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit
import Combine

class SettingsViewController: UIViewController, NavigationConfigurable {

    // MARK: - Properties
    weak var coordinator: SettingsCoordinator?
    let viewModel: SettingsViewModel  // Changed to internal access
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    var navigationConfiguration: NavigationConfiguration {
        return NavigationBuilder()
            .title("ตั้งค่า")
            .style(.default)
            .largeTitleMode(.always)
            .rightButton(image: UIImage(systemName: "gear")) { [weak self] in
                self?.settingsButtonTapped()
            }
            .build()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
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
    
    private func settingsButtonTapped() {
        let alert = UIAlertController(title: "ตั้งค่าเพิ่มเติม", message: "เลือกการตั้งค่า", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "รีเซ็ตแอป", style: .destructive) { _ in
            self.showResetConfirmation()
        })
        
        alert.addAction(UIAlertAction(title: "ส่งออกข้อมูล", style: .default) { _ in
            self.exportData()
        })
        
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(alert, animated: true)
    }
    
    private func showResetConfirmation() {
        let alert = UIAlertController(
            title: "รีเซ็ตแอปพลิเคชัน",
            message: "คุณแน่ใจหรือไม่ว่าต้องการรีเซ็ตข้อมูลทั้งหมด?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "รีเซ็ต", style: .destructive) { _ in
            // Handle reset
            self.showSuccessMessage("รีเซ็ตเสร็จสิ้น")
        })
        
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func exportData() {
        let activityController = UIActivityViewController(
            activityItems: ["ข้อมูลจาก BaseStructor iOS App"],
            applicationActivities: nil
        )
        present(activityController, animated: true)
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

// MARK: - Models
struct SettingsSection {
    let title: String
    let items: [SettingsItem]
}

struct SettingsItem {
    let title: String
    let icon: String
    let action: SettingsAction
}

enum SettingsAction {
    case profile, notifications, privacy, theme, language, about, help, contact, logout
}

// MARK: - Custom Cell
class SettingsCell: UITableViewCell {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with item: SettingsItem) {
        iconImageView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
    }
}

#Preview {
    SettingsViewController(viewModel: .init(userService: AppDIContainer.shared.makeUserService()))
}
