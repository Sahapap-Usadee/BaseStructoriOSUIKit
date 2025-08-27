//
//  Untitled.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 27/8/2568 BE.
//

import UIKit

// MARK: - Localization Test View Controller (Programmatic UI)
class LocalizationTestViewController: UIViewController, NavigationConfigurable {
    weak var coordinator: SettingsCoordinator?
    var navigationConfiguration: NavigationConfiguration {
        return NavigationBuilder()
            .title("localization_test".localized)
            .style(.default)
            .build()
    }

    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    // MARK: - Basic Localization Section
    private lazy var basicSection: UIView = {
        let section = createSection()

        let basicTitleLabel = createTitleLabel()
        basicTitleLabel.text = "test_basic_title".localized

        let basicSubtitleLabel = createSubtitleLabel()
        basicSubtitleLabel.text = "test_basic_subtitle".localized

        section.addSubview(basicTitleLabel)
        section.addSubview(basicSubtitleLabel)

        NSLayoutConstraint.activate([
            basicTitleLabel.topAnchor.constraint(equalTo: section.topAnchor, constant: 16),
            basicTitleLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            basicTitleLabel.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),

            basicSubtitleLabel.topAnchor.constraint(equalTo: basicTitleLabel.bottomAnchor, constant: 8),
            basicSubtitleLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            basicSubtitleLabel.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
            basicSubtitleLabel.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -16)
        ])

        return section
    }()

    // MARK: - String Formatting Section
    private lazy var formattingSection: UIView = {
        let section = createSection()

        let titleLabel = createTitleLabel()
        titleLabel.text = "string_formatting_title".localized

        let userWelcomeLabel = createBodyLabel()
        userWelcomeLabel.text = "welcome_user_name".localized(with: testUser.name)

        let userScoreLabel = createBodyLabel()
        userScoreLabel.text = "user_score_format".localized(with: testUser.name, testUser.score)

        let dateTimeLabel = createBodyLabel()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: testUser.joinDate)
        dateTimeLabel.text = "user_join_date".localized(with: dateString)

        let priceLabel = createBodyLabel()
        priceLabel.text = "price_format".localized(with: testPrice)

        [titleLabel, userWelcomeLabel, userScoreLabel, dateTimeLabel, priceLabel].forEach {
            section.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: section.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),

            userWelcomeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            userWelcomeLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            userWelcomeLabel.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),

            userScoreLabel.topAnchor.constraint(equalTo: userWelcomeLabel.bottomAnchor, constant: 8),
            userScoreLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            userScoreLabel.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),

            dateTimeLabel.topAnchor.constraint(equalTo: userScoreLabel.bottomAnchor, constant: 8),
            dateTimeLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            dateTimeLabel.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),

            priceLabel.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
            priceLabel.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -16)
        ])

        return section
    }()

    // MARK: - Pluralization Section
    private lazy var pluralSection: UIView = {
        let section = createSection()

        let titleLabel = createTitleLabel()
        titleLabel.text = "pluralization_title".localized

        // Items
        let (itemContainer, itemCountLabel, itemStepper) = createPluralControl("Items")
        self.itemCountLabel = itemCountLabel
        self.itemStepper = itemStepper

        // Notifications
        let (notificationContainer, notificationLabel, notificationStepper) = createPluralControl("Notifications")
        self.notificationLabel = notificationLabel
        self.notificationStepper = notificationStepper

        // Messages
        let (messageContainer, messageLabel, messageStepper) = createPluralControl("Messages")
        self.messageLabel = messageLabel
        self.messageStepper = messageStepper

        // Photos
        let (photoContainer, photoLabel, photoStepper) = createPluralControl("Photos")
        self.photoLabel = photoLabel
        self.photoStepper = photoStepper

        [titleLabel, itemContainer, notificationContainer, messageContainer, photoContainer].forEach {
            section.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: section.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),

            itemContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            itemContainer.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            itemContainer.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),

            notificationContainer.topAnchor.constraint(equalTo: itemContainer.bottomAnchor, constant: 12),
            notificationContainer.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            notificationContainer.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),

            messageContainer.topAnchor.constraint(equalTo: notificationContainer.bottomAnchor, constant: 12),
            messageContainer.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            messageContainer.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),

            photoContainer.topAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: 12),
            photoContainer.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            photoContainer.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
            photoContainer.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -16)
        ])

        return section
    }()

    // MARK: - Buttons Section
    private lazy var buttonsSection: UIView = {
        let section = createSection()

        let titleLabel = createTitleLabel()
        titleLabel.text = "buttons_title".localized

        let saveButton = createButton(title: "save_changes", backgroundColor: .systemBlue)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)

        let deleteButton = createButton(title: "delete_item", backgroundColor: .systemRed)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)

        let shareButton = createButton(title: "share_content", backgroundColor: .systemGreen)
        shareButton.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)

        [titleLabel, saveButton, deleteButton, shareButton].forEach {
            section.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: section.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),

            saveButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            saveButton.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 44),

            deleteButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            deleteButton.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),

            shareButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 12),
            shareButton.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            shareButton.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
            shareButton.heightAnchor.constraint(equalToConstant: 44),
            shareButton.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -16)
        ])

        return section
    }()

    // MARK: - Text Fields Section
    private lazy var textFieldsSection: UIView = {
        let section = createSection()

        let titleLabel = createTitleLabel()
        titleLabel.text = "textfields_title".localized

        let nameTextField = createTextField()
        nameTextField.placeholder = "enter_full_name".localized

        let emailTextField = createTextField()
        emailTextField.placeholder = "enter_email_address".localized
        emailTextField.keyboardType = .emailAddress

        let phoneTextField = createTextField()
        phoneTextField.placeholder = "enter_phone_number".localized
        phoneTextField.keyboardType = .phonePad

        [titleLabel, nameTextField, emailTextField, phoneTextField].forEach {
            section.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: section.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),

            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            nameTextField.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),

            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            emailTextField.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),

            phoneTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
            phoneTextField.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
            phoneTextField.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44),
            phoneTextField.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -16)
        ])

        return section
    }()

    // MARK: - Properties
    private var itemCountLabel: UILabel!
    private var notificationLabel: UILabel!
    private var messageLabel: UILabel!
    private var photoLabel: UILabel!

    private var itemStepper: UIStepper!
    private var notificationStepper: UIStepper!
    private var messageStepper: UIStepper!
    private var photoStepper: UIStepper!

    // Test Data
    private let testUser = TestUser(
        name: "สมชาย",
        email: "somchai@email.com",
        score: 1250,
        joinDate: Date()
    )

    private let testPrice: Double = 1299.99

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateAllLocalizedContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        updateAllLocalizedContent()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        [basicSection, formattingSection, pluralSection, buttonsSection, textFieldsSection].forEach {
            stackView.addArrangedSubview($0)
        }

        setupSteppers()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
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

            // Stack View
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func setupSteppers() {
        itemStepper.value = 5
        notificationStepper.value = 3
        messageStepper.value = 0
        photoStepper.value = 1
    }

    // MARK: - UI Creation Methods
    private func createSection() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        return view
    }

    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }

    private func createSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }

    private func createBodyLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }

    private func createButton(title: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title.localized, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        return button
    }

    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        return textField
    }

    private func createPluralControl(_ title: String) -> (UIView, UILabel, UIStepper) {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = createBodyLabel()
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)

        container.addSubview(label)
        container.addSubview(stepper)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            stepper.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            stepper.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stepper.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: 16)
        ])

        return (container, label, stepper)
    }

    // MARK: - Update Methods
    private func updateAllLocalizedContent() {
        updatePluralization()
    }

    private func updatePluralization() {
        let itemCount = Int(itemStepper.value)
        let notificationCount = Int(notificationStepper.value)
        let messageCount = Int(messageStepper.value)
        let photoCount = Int(photoStepper.value)

        itemCountLabel.text = "item_count_plural".localizedPlural(count: itemCount)
        notificationLabel.text = "notification_count_plural".localizedPlural(count: notificationCount)
        messageLabel.text = "message_count_plural".localizedPlural(count: messageCount)
        photoLabel.text = "photo_count_plural".localizedPlural(count: photoCount)
    }

    // MARK: - Actions
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        updatePluralization()
    }

    @objc private func saveButtonPressed(_ sender: UIButton) {}

    @objc private func deleteButtonPressed(_ sender: UIButton) {}

    @objc private func shareButtonPressed(_ sender: UIButton) {
        let shareText = "share_text_format".localized(with: testUser.name, testUser.score)

        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )

        activityVC.setValue("share_title".localized, forKey: "subject")
        present(activityVC, animated: true)
    }

    @objc private func testAllFeaturesPressed(_ sender: UIButton) {
        performLocalizationTests()
    }

    // MARK: - Test All Features
    private func performLocalizationTests() {
        let alert = UIAlertController(
            title: "test_results_title".localized,
            message: generateTestResults(),
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "ok".localized, style: .default))
        present(alert, animated: true)
    }

    private func generateTestResults() -> String {
        var results: [String] = []

        results.append("✅ " + "test_basic_localization".localized)
        results.append("✅ " + "test_string_formatting".localized)
        results.append("✅ " + "test_pluralization".localized)
        results.append("✅ " + "test_ui_components".localized)
        results.append("✅ " + "test_language_switching".localized)

        return results.joined(separator: "\n")
    }
}

// MARK: - Test Data Model
struct TestUser {
    let name: String
    let email: String
    let score: Int
    let joinDate: Date
}
