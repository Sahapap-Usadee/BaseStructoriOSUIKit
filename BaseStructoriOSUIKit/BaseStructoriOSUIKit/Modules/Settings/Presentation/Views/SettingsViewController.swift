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
    
    var navigationBarStyle: NavigationBarStyle {
        return .default
    }
    
    var navigationConfiguration: NavigationConfiguration {
        return NavigationBuilder()
            .title("ตั้งค่า")
            .style(.transparent) // ✅ กลับไปใช้ default style ให้ดูปกติ
            .largeTitleMode(.always)
            .rightButton(image: UIImage(systemName: "person.circle.fill")) { [weak self] in
                self?.profileButtonTapped()
            }
            .leftButton(image: UIImage(systemName: "paintbrush.pointed.fill")) { [weak self] in
                self?.themeButtonTapped()
            }
            .build()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
        
        // ✅ Force navigation setup เพื่อให้แน่ใจว่าแสดงถูกต้อง
        //setupNavigationBarManually()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("after ter test \(viewModel.userService.getCurrentUser()?.name)")
        
        // ✅ Force navigation setup ทุกครั้งที่ view ปรากฏ
       //setupNavigationBarManually()
       
        // ✨ เพิ่ม entrance animation กลับมา
        animateTableViewEntrance()
    }
    
    // ✨ Animate table view entrance - ปรับปรุง position ให้ถูกต้อง
    private func animateTableViewEntrance() {
        // รอให้ table view load เสร็จก่อน
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            // เก็บ original transforms และ alpha ไว้ก่อน
            var originalStates: [(UITableViewCell, CGAffineTransform, CGFloat)] = []
            
            // เตรียม cells สำหรับ animation
            for section in 0..<self.tableView.numberOfSections {
                for row in 0..<self.tableView.numberOfRows(inSection: section) {
                    let indexPath = IndexPath(row: row, section: section)
                    if let cell = self.tableView.cellForRow(at: indexPath) {
                        // เก็บค่าเดิมไว้
                        originalStates.append((cell, cell.transform, cell.alpha))
                        
                        // ตั้งค่าเริ่มต้นสำหรับ animation
                        cell.transform = CGAffineTransform(translationX: -50, y: 0)
                        cell.alpha = 0
                    }
                }
            }
            
            // Animate cells เข้าที่ทีละอัน
            var delay: TimeInterval = 0
            for (cell, originalTransform, originalAlpha) in originalStates {
                UIView.animate(
                    withDuration: 0.6,
                    delay: delay,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0.4,
                    options: [.allowUserInteraction, .curveEaseOut]
                ) {
                    cell.transform = originalTransform
                    cell.alpha = originalAlpha
                } completion: { _ in
                    // ให้แน่ใจว่า reset กลับสู่ค่าปกติ
                    cell.transform = .identity
                    cell.alpha = 1.0
                }
                delay += 0.08
            }
        }
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        // ✅ ลด gradient effect ให้เบาลง
        setupSubtleGradientBackground()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // ✅ เปลี่ยนกลับเป็น normal background
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    // ✨ เพิ่ม gradient effect กลับมา - แต่เบากว่าเดิม
    private func setupSubtleGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemBackground.cgColor,
            UIColor.systemBlue.withAlphaComponent(0.05).cgColor,  // เพิ่มจาก 0.03 เป็น 0.05
            UIColor.systemPurple.withAlphaComponent(0.03).cgColor // เพิ่มจาก 0.02 เป็น 0.03
        ]
        gradientLayer.locations = [0.0, 0.7, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // ✨ เพิ่ม subtle gradient animation กลับมา
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = 4.0 // ช้าลง จาก 3.0 เป็น 4.0
        animation.fromValue = gradientLayer.colors!
        animation.toValue = [
            UIColor.systemPurple.withAlphaComponent(0.05).cgColor,
            UIColor.systemBlue.withAlphaComponent(0.03).cgColor,
            UIColor.systemBackground.cgColor
        ]
        animation.repeatCount = .infinity
        animation.autoreverses = true
        gradientLayer.add(animation, forKey: "gradientAnimation")
    }
    
    // ✅ Manual navigation setup เพื่อให้แน่ใจว่าทำงาน
    private func setupNavigationBarManually() {
        // Setup large title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "ตั้งค่า"
        
        // Setup right button (Profile)
        let profileButton = UIBarButtonItem(
            image: UIImage(systemName: "person.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(profileButtonTapped)
        )
        profileButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = profileButton
        
        // Setup left button (Theme)
        let themeButton = UIBarButtonItem(
            image: UIImage(systemName: "paintbrush.pointed.fill"),
            style: .plain,
            target: self,
            action: #selector(themeButtonTapped)
        )
        themeButton.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = themeButton
        
        // Ensure navigation bar is visible
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // ✅ Profile button action with animation
    @objc private func profileButtonTapped() {
        // เพิ่ม haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        let alert = UIAlertController(title: "👤 โปรไฟล์", message: "จัดการโปรไฟล์ของคุณ", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "✏️ แก้ไขโปรไฟล์", style: .default) { _ in
            //self.coordinator?.showProfile()
        })
        
        alert.addAction(UIAlertAction(title: "📊 ดูสถิติการใช้งาน", style: .default) { _ in
            self.showUsageStats()
        })
        
        alert.addAction(UIAlertAction(title: "🔐 ตั้งค่าความปลอดภัย", style: .default) { _ in
            self.showSecuritySettings()
        })
        
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(alert, animated: true)
    }
    
    // ✅ Theme button action with wow effect
    @objc private func themeButtonTapped() {
        // เพิ่ม haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        let alert = UIAlertController(title: "🎨 ธีมและสี", message: "ปรับแต่งรูปลักษณ์แอป", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "🌅 ธีมอ่อน", style: .default) { _ in
            self.applyTheme(.light)
        })
        
        alert.addAction(UIAlertAction(title: "🌙 ธีมมืด", style: .default) { _ in
            self.applyTheme(.dark)
        })
        
        alert.addAction(UIAlertAction(title: "🌈 ธีมสีรุ้ง", style: .default) { _ in
            self.applyTheme(.rainbow)
        })
        
        alert.addAction(UIAlertAction(title: "✨ ธีมอัตโนมัติ", style: .default) { _ in
            self.applyTheme(.automatic)
        })
        
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = navigationItem.leftBarButtonItem
        }
        
        present(alert, animated: true)
    }
    
    // ✨ เพิ่ม theme enum
    enum AppTheme {
        case light, dark, rainbow, automatic
    }
    
    // ✨ Apply theme with animation
    private func applyTheme(_ theme: AppTheme) {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve) {
            switch theme {
            case .light:
                self.overrideUserInterfaceStyle = .light
            case .dark:
                self.overrideUserInterfaceStyle = .dark
            case .rainbow:
                self.setupRainbowTheme()
            case .automatic:
                self.overrideUserInterfaceStyle = .unspecified
            }
        } completion: { _ in
            feedbackGenerator.notificationOccurred(.success)
            self.showThemeChangeMessage(theme)
        }
    }
    
    // ✨ สร้าง rainbow theme effect
    private func setupRainbowTheme() {
        let rainbowLayer = CAGradientLayer()
        rainbowLayer.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemOrange.cgColor,
            UIColor.systemYellow.cgColor,
            UIColor.systemGreen.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.systemIndigo.cgColor,
            UIColor.systemPurple.cgColor
        ]
        rainbowLayer.locations = [0.0, 0.16, 0.33, 0.5, 0.66, 0.83, 1.0]
        rainbowLayer.startPoint = CGPoint(x: 0, y: 0)
        rainbowLayer.endPoint = CGPoint(x: 1, y: 1)
        rainbowLayer.frame = view.bounds
        
        view.layer.insertSublayer(rainbowLayer, at: 0)
        
        // เพิ่ม animation
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 10.0
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi
        animation.repeatCount = .infinity
        rainbowLayer.add(animation, forKey: "rainbowRotation")
    }
    
    private func showUsageStats() {
        let alert = UIAlertController(title: "📊 สถิติการใช้งาน", message: "คุณใช้แอปนี้ไปแล้ว 42 ชั่วโมง 30 นาที", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "เยี่ยม!", style: .default))
        present(alert, animated: true)
    }
    
    private func showSecuritySettings() {
        let alert = UIAlertController(title: "🔐 ความปลอดภัย", message: "การตั้งค่าความปลอดภัยขั้นสูง", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "เปิดใช้งาน Face ID", style: .default))
        alert.addAction(UIAlertAction(title: "ตั้งรหัสผ่าน", style: .default))
        alert.addAction(UIAlertAction(title: "ปิด", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showThemeChangeMessage(_ theme: AppTheme) {
        let message: String
        switch theme {
        case .light: message = "🌅 เปลี่ยนเป็นธีมอ่อนแล้ว!"
        case .dark: message = "🌙 เปลี่ยนเป็นธีมมืดแล้ว!"
        case .rainbow: message = "🌈 เปลี่ยนเป็นธีมสีรุ้งแล้ว!"
        case .automatic: message = "✨ เปลี่ยนเป็นธีมอัตโนมัติแล้ว!"
        }
        
        let alert = UIAlertController(title: "สำเร็จ!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "เยี่ยม!", style: .default))
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
        
        // ✨ เพิ่ม haptic feedback เมื่อกด cell
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // ✨ เพิ่ม cell bounce animation
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    cell.transform = .identity
                }
            }
        }
        
        let item = settingsData[indexPath.section].items[indexPath.row]
        handleSettingsAction(item.action)
    }
    
    // ✨ เพิ่ม scroll delegate สำหรับ parallax effect - แก้ไข position
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        // ✨ Parallax effect สำหรับ navigation bar (เฉพาะตอนใช้งาน)
        if offsetY > 0, let navigationBar = navigationController?.navigationBar {
            let alpha = min(1.0, max(0.0, offsetY / 200.0)) // เพิ่ม threshold จาก 100 เป็น 200
            navigationBar.alpha = 1.0 - (alpha * 0.1) // ลดเหลือ 0.1 ให้อ่อนมาก
        }
        
        // ✨ ปรับปรุง depth effect ให้ smooth และ position ถูกต้อง
        guard offsetY >= 0 else { return } // ป้องกันการ scroll ในทิศทางผิด
        
        for cell in tableView.visibleCells {
            if let indexPath = tableView.indexPath(for: cell) {
                let cellFrame = tableView.rectForRow(at: indexPath)
                // ✅ แก้ไขการคำนวณ position ให้ถูกต้อง
                let cellTop = cellFrame.origin.y - offsetY
                let visibleHeight = scrollView.bounds.height
                
                // คำนวณ distance จากกึ่งกลางจอ
                let cellCenterY = cellTop + cellFrame.height / 2
                let screenCenterY = visibleHeight / 2
                let distanceFromCenter = abs(cellCenterY - screenCenterY)
                let normalizedDistance = min(1.0, distanceFromCenter / (visibleHeight / 2))
                
                // สร้าง scale effect ที่อ่อนลง
                let scale = max(0.95, 1.0 - normalizedDistance * 0.05) // ลดความแรงมาก
                
                // สร้าง alpha effect ที่อ่อนลง  
                let alpha = max(0.85, 1.0 - normalizedDistance * 0.15) // ลดความแรงมาก
                
                // ใช้ animation เพื่อให้ smooth
                UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
                    cell.transform = CGAffineTransform(scaleX: scale, y: scale)
                    cell.alpha = alpha
                }
            }
        }
    }
    
    // ✨ เพิ่ม header animation กลับมา
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .systemBlue
            headerView.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            
            // เพิ่ม entrance animation แบบเบา ๆ
            headerView.alpha = 0
            headerView.transform = CGAffineTransform(translationX: -30, y: 0) // ลดจาก -50
            
            UIView.animate(withDuration: 0.4, delay: 0.05) { // ลด duration และ delay
                headerView.alpha = 1.0
                headerView.transform = .identity
            }
        }
    }
    
    // ✨ เพิ่ม cell appearance animation - แก้ไข position
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // ✅ ป้องกันการ animate cells ที่แสดงอยู่แล้ว
        guard cell.alpha == 0 || cell.transform != .identity else {
            return
        }
        
        // เพิ่ม entrance animation สำหรับ cells ใหม่
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 30, y: 0) // ลดระยะ
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.02 * Double(indexPath.row), // ลด delay
            usingSpringWithDamping: 0.9, // เพิ่ม damping
            initialSpringVelocity: 0.2, // ลด velocity
            options: [.allowUserInteraction, .curveEaseOut]
        ) {
            cell.alpha = 1.0
            cell.transform = .identity
        } completion: { _ in
            // ✅ ให้แน่ใจว่า reset ค่าให้ถูกต้อง
            cell.transform = .identity
            cell.alpha = 1.0
        }
        
        // ✅ ปรับปรุง logout cell effect
        if indexPath.section == 2 && indexPath.row == 2 { // Logout cell
            cell.backgroundColor = UIColor.systemRed.withAlphaComponent(0.03) // ลดลงมาก
            
            // เพิ่ม subtle glow animation
            UIView.animate(withDuration: 4.0, delay: 1.0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
                cell.backgroundColor = UIColor.systemRed.withAlphaComponent(0.08) // ลดความแรง
            }
        }
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
            showAlert(title: "ภาษา", message: "เปลี่ยนภาษาแอปพลิเคชัน")
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
            self.showSuccessMessage("ออกจากระบบเรียบร้อย")
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
