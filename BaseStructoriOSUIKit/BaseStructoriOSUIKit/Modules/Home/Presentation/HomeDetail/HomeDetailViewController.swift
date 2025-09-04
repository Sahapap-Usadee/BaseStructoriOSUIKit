//
//  HomeDetailViewController.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit
import Combine
import Kingfisher

class HomeDetailViewController: BaseViewController<HomeDetailViewModel>, NavigationConfigurable {
    
    weak var coordinator: HomeCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var navigationConfiguration: NavigationConfiguration {
        return NavigationBuilder()
            .title(viewModel.pokemonName)
            .style(.default)
            .rightButton(image: UIImage(systemName: "square.and.arrow.up")) { [weak self] in
                self?.shareButtonTapped()
            }
            .build()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        // Load pokemon detail
        Task {
            await viewModel.loadPokemonDetail()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(infoStackView)
        view.addSubview(loadingIndicator)
        
        setupConstraints()
        setupInfoCards()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Pokemon Image
            pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            pokemonImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 200),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // ID Label
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            idLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Info Stack View
            infoStackView.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 30),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupInfoCards() {
        let heightCard = createInfoCard(title: "Height", value: viewModel.pokemonHeight)
        let weightCard = createInfoCard(title: "Weight", value: viewModel.pokemonWeight)
        let typesCard = createInfoCard(title: "Types", value: viewModel.pokemonTypes)
        let abilitiesCard = createInfoCard(title: "Abilities", value: viewModel.pokemonAbilities)
        let expCard = createInfoCard(title: "Base Experience", value: viewModel.baseExperience)
        
        infoStackView.addArrangedSubview(heightCard)
        infoStackView.addArrangedSubview(weightCard)
        infoStackView.addArrangedSubview(typesCard)
        infoStackView.addArrangedSubview(abilitiesCard)
        infoStackView.addArrangedSubview(expCard)
    }
    
    private func createInfoCard(title: String, value: String) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        valueLabel.textColor = .label
        valueLabel.numberOfLines = 0
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(titleLabel)
        card.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        return card
    }
    
    private func bindViewModel() {
        // Bind loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                    self?.contentView.alpha = 0.3
                } else {
                    self?.loadingIndicator.stopAnimating()
                    self?.contentView.alpha = 1.0
                }
            }
            .store(in: &cancellables)
        
        // Bind pokemon data
        viewModel.$pokemon
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pokemon in
                self?.updateUI()
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
    
    private func updateUI() {
        nameLabel.text = viewModel.pokemonName
        idLabel.text = viewModel.pokemonIdString
        
        // Update info cards
        updateInfoCards()
        
        // Load pokemon image
        loadPokemonImage()
        
        // Update navigation title
        configureNavigationBar()
    }
    
    private func updateInfoCards() {
        let cards = infoStackView.arrangedSubviews
        let values = [
            viewModel.pokemonHeight,
            viewModel.pokemonWeight,
            viewModel.pokemonTypes,
            viewModel.pokemonAbilities,
            viewModel.baseExperience
        ]
        
        for (index, card) in cards.enumerated() {
            if index < values.count,
               let valueLabel = card.subviews.compactMap({ $0 as? UILabel }).last {
                valueLabel.text = values[index]
            }
        }
    }
    
    private func loadPokemonImage() {
        let imageURL = viewModel.pokemonImageURL
        pokemonImageView.loadPokemonImage(from: imageURL)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "เกิดข้อผิดพลาด", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ลองใหม่", style: .default) { [weak self] _ in
            Task {
                await self?.viewModel.refreshData()
            }
        })
        
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func shareButtonTapped() {
        let shareText = "Check out \(viewModel.pokemonName) (\(viewModel.pokemonId))!"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }
        
        present(activityVC, animated: true)
    }
}
