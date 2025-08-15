//
//  LoadingViewController.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit
import Combine

class LoadingViewController: UIViewController, NavigationConfigurable {
    
    // MARK: - Properties
    weak var coordinator: LoadingCoordinator?
    private let viewModel = LoadingViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "app.badge")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "BaseStructor iOS"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "กำลังโหลด..."
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = .systemBlue
        progress.trackTintColor = .systemGray5
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Navigation Configuration
    var navigationConfiguration: NavigationConfiguration {
        return NavigationBuilder()
            .style(.hidden)
            .build()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLoading()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(loadingLabel)
        view.addSubview(progressView)
        view.addSubview(activityIndicator)
        
        setupConstraints()
        
        // Start animations
        activityIndicator.startAnimating()
        
        // Add logo animation
        logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Loading Label
            loadingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            loadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Progress View
            progressView.topAnchor.constraint(equalTo: loadingLabel.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            
            // Activity Indicator
            activityIndicator.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 30),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$loadingProgress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                self?.progressView.setProgress(progress, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.$loadingText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.loadingLabel.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if !isLoading {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        // Subscribe to loading completed
        viewModel.loadingCompleted
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.coordinator?.didFinishLoading()
            }
            .store(in: &cancellables)
    }
    
    private func startLoading() {
        viewModel.startLoading()
            .sink { _ in
                // Loading started
            }
            .store(in: &cancellables)
    }
}
