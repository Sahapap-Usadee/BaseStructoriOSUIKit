//
//  ListViewController.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit
import Combine

class ListViewController: UIViewController, NavigationConfigurable {
    
    // MARK: - Properties
    weak var coordinator: ListCoordinator?
    private let viewModel: ListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "รายการและ Modal"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "นี่คือตัวอย่าง Tab ที่สองที่แสดงการใช้งาน\nModal Presentations แบบต่างๆ"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var showModalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("แสดง Modal", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showModalTapped), for: .touchUpInside)
        return button
    }()

    private lazy var showModalFullButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("แสดง Modal Full", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showModalFullTapped), for: .touchUpInside)
        return button
    }()

    private lazy var showActionSheetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("แสดง Action Sheet", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showActionSheetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var showAlertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("แสดง Alert", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showAlertTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Navigation Configuration
    var navigationConfiguration: NavigationConfiguration {
        return NavigationBuilder()
            .title("รายการ")
            .style(.gradient([.init(hex: "cc2b5e"), .init(hex: "753a88")]))
            .rightButton(image: UIImage(systemName: "info.circle")) { [weak self] in
                self?.infoButtonTapped()
            }
            .build()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.userService.updatecurrentUser(user: .init(id: "2", name: "ter2 change", email: ""))
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(showModalButton)
        view.addSubview(showModalFullButton)
        view.addSubview(showActionSheetButton)
        view.addSubview(showAlertButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Show Modal Button
            showModalButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            showModalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showModalButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showModalButton.heightAnchor.constraint(equalToConstant: 50),

            // Show Modal Full Button
            showModalFullButton.topAnchor.constraint(equalTo: showModalButton.bottomAnchor, constant: 16),
            showModalFullButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showModalFullButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showModalFullButton.heightAnchor.constraint(equalToConstant: 50),

            // Show Action Sheet Button
            showActionSheetButton.topAnchor.constraint(equalTo: showModalFullButton.bottomAnchor, constant: 16),
            showActionSheetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showActionSheetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showActionSheetButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Show Alert Button
            showAlertButton.topAnchor.constraint(equalTo: showActionSheetButton.bottomAnchor, constant: 16),
            showAlertButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showAlertButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showAlertButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc private func showModalTapped() {
        coordinator?.showModal()
    }

    @objc private func showModalFullTapped() {
        coordinator?.showModalFull()
    }

    @objc private func showActionSheetTapped() {
        let actionSheet = UIAlertController(title: "เลือกตัวเลือก", message: "เลือกสิ่งที่คุณต้องการทำ", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "ตัวเลือก 1", style: .default) { _ in
            self.showAlert(title: "เลือกแล้ว", message: "คุณเลือกตัวเลือก 1")
        })
        
        actionSheet.addAction(UIAlertAction(title: "ตัวเลือก 2", style: .default) { _ in
            self.showAlert(title: "เลือกแล้ว", message: "คุณเลือกตัวเลือก 2")
        })
        
        actionSheet.addAction(UIAlertAction(title: "ลบ", style: .destructive) { _ in
            self.showAlert(title: "ลบแล้ว", message: "ดำเนินการลบเรียบร้อย")
        })
        
        actionSheet.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        
        // สำหรับ iPad
        if let popover = actionSheet.popoverPresentationController {
            popover.sourceView = showActionSheetButton
            popover.sourceRect = showActionSheetButton.bounds
        }
        
        present(actionSheet, animated: true)
    }
    
    @objc private func showAlertTapped() {
        let alert = UIAlertController(
            title: "ตัวอย่าง Alert",
            message: "นี่คือตัวอย่าง Alert ธรรมดา",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func infoButtonTapped() {
        let alert = UIAlertController(
            title: "ข้อมูล Tab 2",
            message: "Tab นี้แสดงตัวอย่างการใช้งาน Modal Presentations แบบต่างๆ ใน iOS",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "เข้าใจแล้ว", style: .default))
        present(alert, animated: true)
    }
}
