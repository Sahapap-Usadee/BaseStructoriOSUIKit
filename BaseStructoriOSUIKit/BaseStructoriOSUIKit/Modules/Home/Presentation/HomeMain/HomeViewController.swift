//
//  HomeViewController.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit
import Combine
import Kingfisher

class HomeViewController: BaseViewController<HomeViewModel>, NavigationConfigurable {

    // MARK: - Properties
    weak var coordinator: HomeCoordinator?

    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Pokemon List"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "ยินดีต้อนรับสู่ Pokemon App ที่ใช้ Clean Architecture"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var showDetailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Random Pokemon", for: .normal)
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
        tableView.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Navigation Configuration    
    var navigationConfiguration: NavigationConfiguration {
        return NavigationBuilder()
            .title("Pokemon List")
            .style(.colored(.systemBlue))
            .build()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        // Load initial data
        viewModel.loadInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(showDetailButton)
        view.addSubview(listTableView)
        
        setupConstraints()
        setupTableView()
    }
    
    private func setupTableView() {
        listTableView.refreshControl = UIRefreshControl()
        listTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func bindViewModel() {
        // Bind pokemon list
        viewModel.$pokemonList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.listTableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Bind loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if !isLoading {
                    self?.listTableView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        // Bind error state
        viewModel.$showError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showError in
                if showError, let errorMessage = self?.viewModel.errorMessage {
                    self?.showErrorAlert(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "เกิดข้อผิดพลาด", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
        present(alert, animated: true)
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
        // Navigate to a random pokemon detail
        let randomId = Int.random(in: 1...150)
        coordinator?.showDetail(pokemonId: randomId)
    }
    
    @objc private func refreshData() {
        viewModel.refreshData()
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
        return viewModel.pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }
        
        let pokemon = viewModel.pokemonList[indexPath.row]
        cell.configure(with: pokemon)
        
        // Load more data when near the end
        if indexPath.row == viewModel.pokemonList.count - 3 {
            viewModel.loadMoreData()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let pokemon = viewModel.pokemonList[indexPath.row]
        if let pokemonId = pokemon.id {
            coordinator?.showDetail(pokemonId: pokemonId)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Pokemon Cell
class PokemonCell: UITableViewCell {
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Cancel any ongoing image loading
        pokemonImageView.kf.cancelDownloadTask()
        pokemonImageView.image = nil
    }
    
    private func setupUI() {
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(idLabel)
        
        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pokemonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 60),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            idLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            idLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            idLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with pokemon: PokemonListItem) {
        nameLabel.text = pokemon.name.capitalized
        if let id = pokemon.id {
            idLabel.text = "#\(String(format: "%03d", id))"
        } else {
            idLabel.text = ""
        }
        
        // Load Pokemon image
        loadPokemonImage(id: pokemon.id)
    }
    
    private func loadPokemonImage(id: Int?) {
        pokemonImageView.loadPokemonImage(by: id)
    }
}
