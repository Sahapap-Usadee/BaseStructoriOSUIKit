# iOS Development Quick Reference Guide
## For BaseStructoriOSUIKit Project

---

## 🎯 Key Architecture Rules

### ✅ DO
- Use **UIKit only** (no SwiftUI)
- Follow **MVVM-C pattern** strictly
- Inject all dependencies through **DIContainer**
- Navigate through **Coordinators only**
- Use **Protocol-based architecture**
- Keep **ViewControllers UI-only**
- Use **weak references** for coordinators

### ❌ DON'T
- Put business logic in ViewControllers
- Use global singletons (except DIContainer)
- Navigate directly between ViewControllers
- Add third-party frameworks
- Use SwiftUI or Combine (unless already in project)

---

## 📁 Quick File Templates

### 1. ViewModel Template
```swift
import Foundation
import Combine

// MARK: - [ModuleName] ViewModel Input Protocol
protocol [ModuleName]ViewModelInput {
    func loadInitialData()
    func refreshData()
    func performAction()
}

// MARK: - [ModuleName] ViewModel Output Protocol
protocol [ModuleName]ViewModelOutput: ObservableObject {
    var isLoading: Bool { get }
    var title: String { get }
    var errorMessage: String? { get }
    var showError: Bool { get }
}

// MARK: - [ModuleName] ViewModel
class [ModuleName]ViewModel: [ModuleName]ViewModelOutput {
    
    // MARK: - Services & Dependencies
    public let userManager: UserManagerProtocol
    // Add other dependencies here
    
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var title: String = ""
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(userManager: UserManagerProtocol) {
        self.userManager = userManager
    }
}

// MARK: - [ModuleName] ViewModel Input Implementation
extension [ModuleName]ViewModel: [ModuleName]ViewModelInput {
    
    func loadInitialData() {
        loadData()
    }
    
    func refreshData() {
        loadData()
    }
    
    func performAction() {
        // Business logic here
    }
    
    // MARK: - Private Methods
    private func loadData() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                // Perform async operations here
                
                await MainActor.run {
                    self.title = "Data Loaded"
                    self.isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    self.handleError(error)
                }
            }
        }
    }
    
    private func handleError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.errorMessage = error.localizedDescription
            self?.showError = true
        }
    }
}
```

### 2. ViewController Template

```swift
import UIKit
import Combine

class [ModuleName]ViewController: BaseViewController<[ModuleName]ViewModel>, NavigationConfigurable {
    
    // MARK: - Properties
    weak var coordinator: [ModuleName]Coordinator?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Navigation Configuration
    var navigationConfiguration: NavigationConfiguration {
        return NavigationBuilder()
            .title("[Module Title]")
            .style(.default)
            .build()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        // Use input protocol
        let input = viewModel as [ModuleName]ViewModelInput
        input.loadInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        // Use output protocol
        let output = viewModel as [ModuleName]ViewModelOutput
        
        output.$title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.titleLabel.text = title
            }
            .store(in: &cancellables)
        
        output.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                // Handle loading state
            }
            .store(in: &cancellables)
        
        output.$showError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showError in
                if showError, let message = output.errorMessage {
                    self?.showAlert(message: message)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func refreshAction() {
        let input = viewModel as [ModuleName]ViewModelInput
        input.refreshData()
    }
}
```

### 3. Coordinator Template
```swift
import UIKit

class [ModuleName]Coordinator: BaseCoordinator {
    private let container: [ModuleName]DIContainer
    
    init(navigationController: UINavigationController, container: [ModuleName]DIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let viewController = container.make[ModuleName]ViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Navigation Methods
    func showDetail() {
        // Navigate to detail screen
    }
    
    func showModal() {
        // Present modal
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
```

### 4. DI Container Template
```swift
import UIKit

protocol [ModuleName]FactoryProtocol {
    func make[ModuleName]ViewModel() -> [ModuleName]ViewModel
    func make[ModuleName]ViewController() -> [ModuleName]ViewController
}

protocol [ModuleName]CoordinatorFactory {
    func make[ModuleName]FlowCoordinator(navigationController: UINavigationController) -> [ModuleName]Coordinator
}

class [ModuleName]DIContainer {
    
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    // MARK: - Dependencies
    private lazy var someUseCase: SomeUseCaseProtocol = 
        SomeUseCase(repository: someRepository)
}

// MARK: - Factory Implementation
extension [ModuleName]DIContainer: [ModuleName]FactoryProtocol {
    func make[ModuleName]ViewModel() -> [ModuleName]ViewModel {
        return [ModuleName]ViewModel(
            userManager: appDIContainer.makeUserManager()
        )
    }
    
    func make[ModuleName]ViewController() -> [ModuleName]ViewController {
        let viewModel = make[ModuleName]ViewModel()
        return [ModuleName]ViewController(viewModel: viewModel)
    }
}

// MARK: - Coordinator Factory
extension [ModuleName]DIContainer: [ModuleName]CoordinatorFactory {
    func make[ModuleName]FlowCoordinator(navigationController: UINavigationController) -> [ModuleName]Coordinator {
        return [ModuleName]Coordinator(navigationController: navigationController, container: self)
    }
}
```

---

## 🔗 Common Patterns

### Navigation Pattern
```swift
// In ViewController
@objc private func buttonTapped() {
    coordinator?.showDetail()
}

// In Coordinator
func showDetail() {
    let detailVC = container.makeDetailViewController()
    detailVC.coordinator = self
    navigationController.pushViewController(detailVC, animated: true)
}
```

### Modal Presentation Pattern
```swift
func showModal() {
    let modalVC = container.makeModalViewController()
    modalVC.coordinator = self
    
    let navController = UINavigationController(rootViewController: modalVC)
    navController.modalPresentationStyle = .pageSheet
    
    presentViewController(navController)
}
```

### Data Binding Pattern
```swift
// In ViewModel
@Published var items: [Item] = []

// In ViewController
viewModel.$items
    .receive(on: DispatchQueue.main)
    .sink { [weak self] items in
        self?.tableView.reloadData()
    }
    .store(in: &cancellables)
```

---

## 🛠️ Common UI Patterns

### TableView Setup
```swift
private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
}()
```

### Auto Layout Constraints
```swift
private func setupConstraints() {
    NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
}
```

### Button Setup
```swift
private lazy var actionButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Action", for: .normal)
    button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()

@objc private func actionButtonTapped() {
    viewModel.performAction()
}
```

---

## 🚀 Quick Start Checklist

### Setting up a new module:
1. [ ] Create folder structure: `ModuleName/DI/`, `ModuleName/Navigation/`, `ModuleName/Presentation/`
2. [ ] Create `ModuleNameDIContainer.swift`
3. [ ] Create `ModuleNameViewModel.swift`
4. [ ] Create `ModuleNameViewController.swift`
5. [ ] Create `ModuleNameCoordinator.swift`
6. [ ] Add module factory to main `DIContainer`
7. [ ] Add coordinator to parent coordinator
8. [ ] Test navigation flow
9. [ ] Add unit tests

### Before submitting code:
1. [ ] No business logic in ViewControllers
2. [ ] All dependencies injected
3. [ ] Navigation through coordinators
4. [ ] Memory safety checked (no retain cycles)
5. [ ] Error handling implemented
6. [ ] UI responsive to ViewModel changes
7. [ ] Code follows naming conventions

---

## 📞 Quick Help

**Need to navigate?** → Use coordinator methods
**Need data?** → Inject through DI container
**UI not updating?** → Check `@Published` and `.sink` bindings
**Memory leaks?** → Check for `weak var coordinator` and `[weak self]`
**Business logic?** → Put it in ViewModel, not ViewController

Remember: Follow the existing patterns in Home, List, and Settings modules!
