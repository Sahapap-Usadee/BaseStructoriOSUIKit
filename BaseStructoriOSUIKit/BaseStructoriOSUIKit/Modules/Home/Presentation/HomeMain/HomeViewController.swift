//
//  HomeViewController.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit
import Combine

class HomeViewController: BaseViewController<HomeViewModel>, NavigationConfigurable {

    // MARK: - Properties
    weak var coordinator: HomeCoordinator? {
        didSet {
            print("🔍 HomeViewController coordinator set to: \(coordinator)")
        }
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "หน้าแรก"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "นี่คือตัวอย่างหน้าจอแรกที่ใช้ Coordinator pattern\nและ MVVM architecture"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var showDetailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("แสดงหน้ารายละเอียด", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showDetailTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var listTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Sample Data
    private let sampleItems = [
        "Navigation Example 1",
        "Navigation Example 2", 
        "Navigation Example 3",
        "Modal Presentation",
        "Custom Transition"
    ]
    
    // MARK: - Navigation Configuration    
    var navigationConfiguration: NavigationConfiguration {
        return NavigationBuilder()
            .title("หน้าแรก")
            .style(.colored(.systemBlue))
            .build()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        print("🔍 HomeViewController viewDidLoad")
        print("🔍 navigationController: \(navigationController)")
        print("🔍 navigationController?.viewControllers: \(navigationController?.viewControllers)")
        print("🔍 coordinator in viewDidLoad: \(coordinator)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        viewModel.userService.updatecurrentUser(user: .init(id: "1", name: "ter change", email: ""))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("🔍 HomeViewController viewDidAppear - coordinator: \(coordinator)")
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(showDetailButton)
        view.addSubview(listTableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Show Detail Button
            showDetailButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            showDetailButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showDetailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showDetailButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Table View
            listTableView.topAnchor.constraint(equalTo: showDetailButton.bottomAnchor, constant: 20),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func showDetailTapped() {
        print("🔍 HomeViewController showDetailTapped called")
        print("🔍 Self: \(self)")
        print("🔍 Coordinator reference: \(coordinator)")
        print("🔍 Coordinator address: \(coordinator.map { "\($0)" } ?? "nil")")
        
        if let coordinator = coordinator {
            print("🔍 Calling coordinator.showDetail()")
            coordinator.showDetail()
        } else {
            print("❌ Coordinator is nil!")
        }
    }
    
    private func rightButtonTapped() {
        let alert = UIAlertController(title: "เพิ่มรายการ", message: "ฟีเจอร์นี้จะพัฒนาต่อไป", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sampleItems[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            coordinator?.showDetail(hidesBottomBar: false)
        } else {
            let alert = UIAlertController(
                title: "เลือก: \(sampleItems[indexPath.row])",
                message: "คุณเลือกรายการที่ \(indexPath.row + 1)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
            present(alert, animated: true)
            }
    }
}


#Preview {
    HomeViewController(viewModel: .init(userService: AppDIContainer.shared.makeUserService()))
}

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
