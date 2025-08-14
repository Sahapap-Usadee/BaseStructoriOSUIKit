//
//  TodayViewController.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import UIKit
import Combine

class TodayViewController: UIViewController {
    
    // MARK: - Properties
    var coordinator: TodayCoordinator?
    private let viewModel: TodayViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        // ⚡ App Store style settings
        collectionView.delaysContentTouches = false
        collectionView.allowsSelection = true
        collectionView.selectionFollowsFocus = false
        collectionView.allowsMultipleSelection = false
        
        // Register cells
        collectionView.register(TodayCardCell.self, forCellWithReuseIdentifier: TodayCardCell.identifier)
        collectionView.register(DateHeaderCell.self, forCellWithReuseIdentifier: "DateHeaderCell")
        
        return collectionView
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .systemBlue
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    init(viewModel: TodayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🔍 TodayViewController: viewDidLoad called")
        setupUI()
        setupBindings()
        
        // ✅ Listen for tap gesture from cells
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCardTapped(_:)),
            name: NSNotification.Name("TodayCardTapped"),
            object: nil
        )
    }
    
    @objc private func handleCardTapped(_ notification: Notification) {
        guard let indexPath = notification.object as? IndexPath else { return }
        print("🔍 TodayViewController: Card tapped at indexPath: \(indexPath)")
        
        let card = viewModel.todayCards[indexPath.item]
        print("🔍 TodayViewController: Card selected: \(card.title)")
        
        showCardDetail(card)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("🔍 TodayViewController: viewWillAppear called")
        setupNavigationBar()
        
        // ✅ Reset animations เมื่อ view จะปรากฏ
        resetAllCellAnimations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("🔍 TodayViewController: viewDidAppear - cards count: \(viewModel.todayCards.count)")
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        // ✅ App Store iOS ล่าสุด style
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // ✅ ใช้ "Today" เหมือน App Store จริง ๆ (ไม่ใช่วันที่)
        title = "Today"
        
        // ✅ Account button แบบ App Store ล่าสุด
        let accountButton = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle"),
            style: .plain,
            target: self,
            action: #selector(profileTapped)
        )
        accountButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = accountButton
        
        // ✅ App Store style navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        // ✅ Clean back button
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func setupBindings() {
        // Bind loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingView.startAnimating()
                } else {
                    self?.loadingView.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        // Bind data changes
        viewModel.$todayCards
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        // Bind error messages
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let error = errorMessage {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
        
        // Handle card selection
        viewModel.cardSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] card in
                self?.showCardDetail(card)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func profileTapped() {
        // Navigate to profile or settings
        coordinator?.showProfile()
    }
    
    // MARK: - Helper Methods
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showCardDetail(_ card: TodayCard) {
        print("🔍 TodayViewController: showCardDetail called with card: \(card.title)")
        print("🔍 TodayViewController: coordinator is: \(coordinator)")
        
        // ✅ เรียก coordinator โดยตรง - ไม่ใช้ alert แล้ว
        coordinator?.showCardDetail(card)
    }
}

// MARK: - Collection View Layout
extension TodayViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            if sectionIndex == 0 {
                return self.createDateHeaderSection(for: layoutEnvironment)
            } else {
                return self.createTodaySection(for: layoutEnvironment)
            }
        }
        
        // Add section background decoration
        layout.register(
            TodaySectionBackgroundView.self,
            forDecorationViewOfKind: "SectionBackground"
        )
        
        return layout
    }
    
    // ✅ เพิ่ม Date Header Section เหมือน App Store
    private func createDateHeaderSection(for environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 20,
            bottom: 10,
            trailing: 20
        )
        
        return section
    }
    
    private func createTodaySection(for environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        
        return section
    }
}

// MARK: - Collection View Data Source
extension TodayViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("🔍 TodayViewController: numberOfSections = 2") // Header + Cards
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // Date header
        } else {
            let count = viewModel.todayCards.count
            print("🔍 TodayViewController: numberOfItemsInSection = \(count)")
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("🔍 TodayViewController: cellForItemAt indexPath: \(indexPath)")
        
        if indexPath.section == 0 {
            // Date header cell
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DateHeaderCell",
                for: indexPath
            ) as! DateHeaderCell
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM d"
            let currentDate = dateFormatter.string(from: Date())
            cell.configure(with: currentDate)
            
            return cell
        } else {
            // Today card cell
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TodayCardCell.identifier,
                for: indexPath
            ) as! TodayCardCell
            
            let card = viewModel.todayCards[indexPath.item]
            print("🔍 TodayViewController: Configuring cell with card: \(card.title)")
            cell.configure(with: card)
            
            return cell
        }
    }
}

// MARK: - Collection View Delegate
extension TodayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        // ✅ อนุญาตให้กดได้ แต่ไม่มี visual highlight เพราะ cell จัดการเอง
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("🔍 TodayViewController: didSelectItemAt called! IndexPath: \(indexPath)")
        
        // ✅ Deselect ทันที เพื่อไม่ให้ค้าง
        collectionView.deselectItem(at: indexPath, animated: false)
        
        // ✅ Only handle card selection, not date header
        if indexPath.section == 1 {
            let card = viewModel.todayCards[indexPath.item]
            print("🔍 TodayViewController: Card selected: \(card.title)")
            
            showCardDetail(card)
        }
    }
    
    // ✅ เพิ่ม method สำหรับ reset animations ที่ค้าง
    private func resetAllCellAnimations() {
        for case let cell as TodayCardCell in collectionView.visibleCells {
            cell.layer.removeAllAnimations()
            cell.transform = .identity
            cell.alpha = 1.0
        }
    }
}

// MARK: - Date Header Cell
class DateHeaderCell: UICollectionViewCell {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with dateString: String) {
        dateLabel.text = dateString
    }
}

// MARK: - Section Background View
class TodaySectionBackgroundView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
