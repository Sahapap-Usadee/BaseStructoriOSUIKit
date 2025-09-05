# BaseStructoriOSUIKit - iOS Application Architecture
## Presentation for Outsource Development Team

---

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture Pattern](#architecture-pattern)
3. [Project Structure](#project-structure)
4. [Core Components](#core-components)
5. [Module Structure](#module-structure)
6. [Navigation Flow](#navigation-flow)
7. [Development Guidelines](#development-guidelines)
8. [Code Examples](#code-examples)
9. [Checklist for Implementation](#checklist-for-implementation)

---

## 🎯 Project Overview

**BaseStructoriOSUIKit** is a modular iOS application template using:
- **UIKit** (NO SwiftUI)
- **MVVM-C** (Model-View-ViewModel-Coordinator)
- **Clean Architecture** principles
- **Dependency Injection** pattern
- **Modular structure** for scalability

### Key Features
- ✅ Modular architecture (Home, List, Loading, Main, Settings)
- ✅ Custom navigation system
- ✅ Environment configuration (Debug, Dev, PreProd, Release, UAT)
- ✅ Dependency injection container
- ✅ Memory-safe coordinator pattern

---

## 🏗️ Architecture Pattern

### MVVM-C Architecture
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Coordinator   │◄──►│   ViewController │◄──►│    ViewModel    │
│   (Navigation)  │    │     (View)       │    │   (Business)    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                        │
                                                        ▼
                                                ┌─────────────────┐
                                                │     Model       │
                                                │   (Data Layer)  │
                                                └─────────────────┘
```

### Clean Architecture Layers
```
┌─────────────────────────────────────────────────────────────────┐
│                        Presentation Layer                       │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │   Coordinator   │ │  ViewController │ │   ViewModel     │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────┐
│                         Domain Layer                            │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │    Use Cases    │ │    Entities     │ │  Repositories   │   │
│  │                 │ │                 │ │  (Protocols)    │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────┐
│                          Data Layer                             │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │  Repositories   │ │  Data Sources   │ │      DTOs       │   │
│  │(Implementation) │ │                 │ │                 │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
BaseStructoriOSUIKit/
├── Application/                 # App lifecycle only
│   ├── AppDelegate.swift       # App delegate
│   └── SceneDelegate.swift     # Scene delegate
│
├── Core/                       # Shared components
│   ├── Base/                   # Base classes
│   │   ├── BaseCoordinator.swift
│   │   └── BaseViewController.swift
│   ├── DI/                     # Main Dependency Injection
│   │   └── DIContainer.swift
│   ├── Extensions/             # Swift extensions
│   ├── Managers/               # ex. Shared managers
│   │   ├── NavigationManager.swift
│   │   ├── SessionManager.swift
│   │   └── UserManager.swift
│   ├── Models/                 # Shared models
│   ├── Navigation/             # Navigation system
│   │   └── AppCoordinator.swift      # Main app coordinator
│   └── Services/               # Shared services
│       └── NetworkService.swift
│
├── Data/                       # Data layer (Clean Architecture)
│   ├── DataSources/           # Remote/Local data sources
│   ├── DTO/                   # Data Transfer Objects
│   └── Repositories/          # Repository implementations
│
├── Domain/                     # Domain layer (Clean Architecture)
│   ├── Entities/              # Business entities
│   ├── Repositories/          # Repository protocols
│   └── UseCases/              # Business use cases
│
├── Modules/                    # Feature modules
│   ├── Home/                  # Home module
│   │   ├── DI/                # Module dependency injection
│   │   ├── Navigation/        # Module coordinator
│   │   └── Presentation/      # Views & ViewModels
│   │       ├── HomeMain/
│   │       └── HomeDetail/
│   ├── List/                  # List module
│   ├── Loading/               # Loading module
│   ├── Main/                  # Main tab controller module
│   └── Settings/              # Settings module
│
├── Resource/                   # Resources
│   └── Localization/          # Localization files
│       ├── Localizable.xcstrings
│       └── InfoPlist.xcstrings

```

---

## 🔧 Core Components

### 1. Coordinator Pattern

```swift
// Base coordinator protocol
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }

    /// เริ่มต้น coordinator และแสดงหน้าจอแรก
    func start()

    /// ลบ child coordinator เมื่อทำงานเสร็จ
    func childDidFinish(_ child: Coordinator)

    /// ตัวเลือก: ทำความสะอาดก่อน coordinator จะถูกปิด
    func finish()
}

// Base Coordinator Implementation
class BaseCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start() {
        fatalError("Subclasses must implement start method")
    }

    // Helper Methods สำหรับการนำทาง
    func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    func popViewController(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
}
```

### 2. Dependency Injection Container

```swift
// Service Factory Protocols
protocol ServiceFactory {
    func makeNetworkService() -> NetworkServiceProtocol
    func makeSessionManager() -> SessionManagerProtocol
    func makeUserManager() -> UserManagerProtocol
}

protocol CoordinatorFactory {
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator
}

protocol ModuleContainerFactory {
    func makeMainDIContainer() -> MainDIContainer
}

// App DI Container (Composition Root)
class AppDIContainer {
    static let shared = AppDIContainer()
    
    private init() {}
    
    // Lazy Services
    private lazy var sessionManager: SessionManagerProtocol = SessionManager()
    private lazy var networkService: NetworkServiceProtocol = NetworkService(sessionManager: sessionManager)
    private lazy var userManager: UserManagerProtocol = UserManager()
    
    // Module Containers
    private lazy var mainDIContainer: MainDIContainer = MainDIContainer(appDIContainer: self)
}

// Factory Implementations
extension AppDIContainer: ServiceFactory {
    func makeNetworkService() -> NetworkServiceProtocol {
        return networkService
    }
    
    func makeSessionManager() -> SessionManagerProtocol {
        return sessionManager
    }
    
    func makeUserManager() -> UserManagerProtocol {
        return userManager
    }
}
```

### 3. Base View Controller

```swift
// Base class for all view controllers
class BaseViewController<VM: ObservableObject>: UIViewController {
    public var viewModel: VM

    public init(viewModel: VM, bundle: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: bundle)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

---

## 📱 Module Structure

Each module follows the same structure:

```text
ModuleName/
├── DI/
│   └── ModuleDIContainer.swift    # Module dependencies
├── Navigation/
│   └── ModuleCoordinator.swift    # Module navigation
└── Presentation/
    ├── ModuleMain/
    │   ├── ModuleViewController.swift
    │   └── ModuleViewModel.swift
    └── ModuleDetail/
        ├── ModuleDetailViewController.swift
        └── ModuleDetailViewModel.swift
```

**Example: Home Module Structure**
```text
Home/
├── DI/
│   └── HomeDIContainer.swift      # Factory protocols & container
├── Navigation/
│   └── HomeCoordinator.swift      # Navigation logic
└── Presentation/
    ├── HomeMain/
    │   ├── HomeViewController.swift    # Main list view
    │   └── HomeViewModel.swift         # Main list logic
    └── HomeDetail/
        ├── HomeDetailViewController.swift  # Detail view
        └── HomeDetailViewModel.swift       # Detail logic
```

### Module DI Container Pattern

```swift
// MARK: - Home Factory Protocol
protocol HomeFactoryProtocol {
    func makeHomeViewModel() -> HomeViewModel
    func makeHomeViewController() -> HomeViewController
    func makeHomeDetailViewModel(pokemonId: Int) -> HomeDetailViewModel
    func makeHomeDetailViewController(pokemonId: Int) -> HomeDetailViewController
}

protocol HomeCoordinatorFactory {
    func makeHomeFlowCoordinator(navigationController: UINavigationController) -> HomeCoordinator
}

// MARK: - Home DI Container
class HomeDIContainer {
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    // MARK: - Pokemon Data Layer 
    private lazy var pokemonRemoteDataSource: PokemonRemoteDataSourceProtocol = 
        PokemonRemoteDataSource(networkService: appDIContainer.makeNetworkService())
    private lazy var pokemonRepository: PokemonRepositoryProtocol = 
        PokemonRepositoryImpl(remoteDataSource: pokemonRemoteDataSource)
    private lazy var getPokemonListUseCase: GetPokemonListUseCaseProtocol = 
        GetPokemonListUseCase(repository: pokemonRepository)
    private lazy var getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol = 
        GetPokemonDetailUseCase(repository: pokemonRepository)
}

// MARK: - Coordinator Factory
extension HomeDIContainer: HomeCoordinatorFactory {
    func makeHomeFlowCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        return HomeCoordinator(navigationController: navigationController, container: self)
    }
}

// MARK: - Factory Implementation
extension HomeDIContainer: HomeFactoryProtocol {
    func makeHomeViewModel() -> HomeViewModel {
        let userManager = appDIContainer.makeUserManager()
        return HomeViewModel(
            userManager: userManager,
            getPokemonListUseCase: getPokemonListUseCase
        )
    }
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = makeHomeViewModel()
        return HomeViewController(viewModel: viewModel)
    }
    
    func makeHomeDetailViewModel(pokemonId: Int) -> HomeDetailViewModel {
        return HomeDetailViewModel(
            pokemonId: pokemonId,
            getPokemonDetailUseCase: getPokemonDetailUseCase
        )
    }
    
    func makeHomeDetailViewController(pokemonId: Int) -> HomeDetailViewController {
        let viewModel = makeHomeDetailViewModel(pokemonId: pokemonId)
        return HomeDetailViewController(viewModel: viewModel)
    }
}
```

---

## 🚀 Navigation Flow

### App Flow Hierarchy

```text
AppCoordinator
    ├── LoadingCoordinator (Initial loading)
    └── MainCoordinator (Main app)
            ├── HomeCoordinator (Tab 1)
            ├── ListCoordinator (Tab 2)
            └── SettingsCoordinator (Tab 3)
```

### Flow Sequence

1. **App Launch** → `AppCoordinator.start()`
2. **Loading Phase** → `LoadingCoordinator` shows loading screen
3. **Main App** → `MainCoordinator` shows tab bar with 3 tabs
4. **Navigation** → Each tab has its own coordinator for navigation

### Example Navigation Implementation

```swift
class HomeCoordinator: BaseCoordinator {
    private let container: HomeDIContainer

    init(navigationController: UINavigationController, container: HomeDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let homeViewController = container.makeHomeViewController()
        homeViewController.coordinator = self
        pushViewController(homeViewController, animated: false)
    }
    
    func showDetail(pokemonId: Int, hidesBottomBar: Bool = true) {
        // สร้าง DetailViewController ผ่าน Module DI Container
        let detailViewController = container.makeHomeDetailViewController(pokemonId: pokemonId)
        detailViewController.coordinator = self
        // Hide TabBar when pushing (full screen)
        detailViewController.hidesBottomBarWhenPushed = hidesBottomBar
        
        pushViewController(detailViewController, animated: true)
    }
    
    func showDetailModal(pokemonId: Int) {
        let detailViewController = container.makeHomeDetailViewController(pokemonId: pokemonId)
        detailViewController.coordinator = self
        
        // Wrap in NavigationController for modal presentation
        let modalNavController = UINavigationController(rootViewController: detailViewController)
        modalNavController.modalPresentationStyle = .fullScreen
        presentViewController(modalNavController)
    }
}
```

---

## 📝 Development Guidelines

### ❌ FORBIDDEN

- **SwiftUI** (Use UIKit only)
- **Storyboards** (Use programmatic UI)
- **Direct View-to-View navigation**
- **Massive ViewControllers**

### ✅ REQUIRED

- **MVVM-C pattern** for all modules
- **Dependency Injection** for all dependencies
- **Protocol-based abstractions**
- **Unit testing** for ViewModels and Use Cases
- **Localization** for all user-facing strings

### Code Style Standards

#### ✅ Naming Conventions
```swift
// Classes: PascalCase
class HomeViewController: BaseViewController<HomeViewModel> { }
class UserManager: UserManagerProtocol { }

// Properties & Variables: camelCase
private let networkService: NetworkServiceProtocol
var isLoading: Bool = false
@Published var pokemonList: [Pokemon] = []

// Constants: camelCase or UPPER_CASE for static
let maxRetryCount = 3
static let DEFAULT_TIMEOUT: TimeInterval = 30.0

// Functions: camelCase with descriptive names
func loadPokemonList() async { }
func showDetailScreen(pokemonId: Int) { }
func handleError(_ error: Error) { }

// Protocols: PascalCase with "Protocol" suffix
protocol NetworkServiceProtocol { }
protocol HomeViewModelInput { }
protocol HomeViewModelOutput: ObservableObject { }
```

#### ✅ Code Organization
```swift
// MARK: - Protocol conformance grouping
class HomeViewController: BaseViewController<HomeViewModel> {
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = { }()
    private lazy var refreshControl: UIRefreshControl = { }()
    
    // MARK: - Properties
    weak var coordinator: HomeCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Setup Methods
    private func setupUI() { }
    private func bindViewModel() { }
    
    // MARK: - Actions
    @objc private func refreshAction() { }
}

// MARK: - Protocol Conformance
extension HomeViewController: UITableViewDataSource {
    // Implementation here
}
```

#### ✅ Dependency Injection Style
```swift
// Constructor injection (Preferred)
class HomeViewModel {
    private let userManager: UserManagerProtocol
    private let getPokemonListUseCase: GetPokemonListUseCaseProtocol
    
    init(
        userManager: UserManagerProtocol,
        getPokemonListUseCase: GetPokemonListUseCaseProtocol
    ) {
        self.userManager = userManager
        self.getPokemonListUseCase = getPokemonListUseCase
    }
}
```

#### ✅ Async/Await Pattern
```swift
// Use async/await for asynchronous operations
func loadData() async {
    guard !isLoading else { return }
    
    isLoading = true
    defer { isLoading = false }
    
    do {
        let result = try await useCase.execute()
        // Handle success
    } catch {
        handleError(error)
    }
}

// UI updates with @MainActor
Task { @MainActor in
    await viewModel.loadInitialData()
}
```

#### ✅ Memory Management
```swift
// Weak references for coordinators
weak var coordinator: HomeCoordinator?

// Proper Combine cancellables
private var cancellables = Set<AnyCancellable>()

// Weak self in closures
.sink { [weak self] value in
    self?.handleValue(value)
}
.store(in: &cancellables)
```

#### ✅ Error Handling
```swift
// Structured error handling
enum NetworkError: LocalizedError {
    case noConnection
    case serverError(Int)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "No internet connection"
        case .serverError(let code):
            return "Server error: \(code)"
        case .decodingError:
            return "Data parsing error"
        }
    }
}

// Error handling in ViewModels
private func handleError(_ error: Error) {
    isLoading = false
    errorMessage = error.localizedDescription
    showError = true
}
```

---

## 💻 Code Examples

### 1. Creating a New Module

#### Step 1: Create DI Container (Complete Example)

```swift
// MARK: - Factory Protocols
protocol NewModuleFactoryProtocol {
    func makeNewModuleViewModel() -> NewModuleViewModel
    func makeNewModuleViewController() -> NewModuleViewController
    func makeNewModuleDetailViewModel(itemId: Int) -> NewModuleDetailViewModel
    func makeNewModuleDetailViewController(itemId: Int) -> NewModuleDetailViewController
}

protocol NewModuleCoordinatorFactory {
    func makeNewModuleFlowCoordinator(navigationController: UINavigationController) -> NewModuleCoordinator
}

// MARK: - DI Container
class NewModuleDIContainer {
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    // MARK: - Use Cases (if needed)
    private lazy var getNewModuleDataUseCase: GetNewModuleDataUseCaseProtocol = {
        // Create use case with repository
        return GetNewModuleDataUseCase(repository: newModuleRepository)
    }()
    
    // MARK: - Repository (if needed)
    private lazy var newModuleRepository: NewModuleRepositoryProtocol = {
        // Create repository with data source
        return NewModuleRepositoryImpl(
            remoteDataSource: newModuleRemoteDataSource,
            localDataSource: newModuleLocalDataSource
        )
    }()
    
    // MARK: - Data Sources (if needed)
    private lazy var newModuleRemoteDataSource: NewModuleRemoteDataSourceProtocol = {
        return NewModuleRemoteDataSource(networkService: appDIContainer.makeNetworkService())
    }()
    
    private lazy var newModuleLocalDataSource: NewModuleLocalDataSourceProtocol = {
        return NewModuleLocalDataSource()
    }()
}

// MARK: - Coordinator Factory Implementation
extension NewModuleDIContainer: NewModuleCoordinatorFactory {
    func makeNewModuleFlowCoordinator(navigationController: UINavigationController) -> NewModuleCoordinator {
        return NewModuleCoordinator(navigationController: navigationController, container: self)
    }
}

// MARK: - Factory Implementation
extension NewModuleDIContainer: NewModuleFactoryProtocol {
    func makeNewModuleViewModel() -> NewModuleViewModel {
        return NewModuleViewModel(
            userManager: appDIContainer.makeUserManager(),
            getNewModuleDataUseCase: getNewModuleDataUseCase
        )
    }
    
    func makeNewModuleViewController() -> NewModuleViewController {
        let viewModel = makeNewModuleViewModel()
        return NewModuleViewController(viewModel: viewModel)
    }
    
    func makeNewModuleDetailViewModel(itemId: Int) -> NewModuleDetailViewModel {
        return NewModuleDetailViewModel(
            itemId: itemId,
            getNewModuleDataUseCase: getNewModuleDataUseCase
        )
    }
    
    func makeNewModuleDetailViewController(itemId: Int) -> NewModuleDetailViewController {
        let viewModel = makeNewModuleDetailViewModel(itemId: itemId)
        return NewModuleDetailViewController(viewModel: viewModel)
    }
}
```

#### Step 2: Create ViewModel

```swift
// MARK: - New Module ViewModel Input Protocol
protocol NewModuleViewModelInput {
    func loadInitialData() async
    func refreshData() async
}

// MARK: - New Module ViewModel Output Protocol
protocol NewModuleViewModelOutput: ObservableObject {
    var isLoading: Bool { get }
    var title: String { get }
    var errorMessage: String? { get }
    var showError: Bool { get }
}

// MARK: - New Module ViewModel
class NewModuleViewModel: NewModuleViewModelOutput {
    
    // MARK: - Services & Dependencies
    public let userManager: UserManagerProtocol
    private let dataUseCase: DataUseCaseProtocol

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var title: String = "New Module"
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Initialization
    init(userManager: UserManagerProtocol, dataUseCase: DataUseCaseProtocol) {
        self.userManager = userManager
        self.dataUseCase = dataUseCase
    }
}

// MARK: - New Module ViewModel Input Implementation
extension NewModuleViewModel: NewModuleViewModelInput {
    
    func loadInitialData() async {
        await loadData()
    }
    
    func refreshData() async {
        await loadData()
    }
    
    // MARK: - Private Methods
    private func loadData() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        do {
            let dataDetail = try await getPokemonDetailUseCase.execute(id: pokemonId)
            print(dataDetail)
            title = "Data Loaded"
            isLoading = false
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        isLoading = false
        errorMessage = error.localizedDescription
        showError = true
    }
}
```

#### Step 3: Create ViewController

```swift
class NewModuleViewController: BaseViewController<NewModuleViewModel>, NavigationConfigurable {
    weak var coordinator: NewModuleCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    var navigationConfiguration: NavigationConfiguration {
        return NavigationBuilder()
            .title("New Module")
            .style(.default)
            .build()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        // Use input protocol with @MainActor in Task
        Task { @MainActor in
            await viewModel.loadInitialData()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        // UI setup
    }
    
    private func bindViewModel() {
        // Use output protocol
        let output = viewModel as NewModuleViewModelOutput
        
        output.$title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.title = title
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
        Task { @MainActor in
            await viewModel.refreshData()
        }
    }
}
```

#### Step 4: Create Coordinator (Complete Example)

```swift
class NewModuleCoordinator: BaseCoordinator {
    private let container: NewModuleDIContainer
    
    init(navigationController: UINavigationController, container: NewModuleDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let viewController = container.makeNewModuleViewController()
        viewController.coordinator = self
        pushViewController(viewController, animated: false)
    }
    
    // MARK: - Navigation Methods
    func showDetail(itemId: Int, hidesBottomBar: Bool = true) {
        let detailViewController = container.makeNewModuleDetailViewController(itemId: itemId)
        detailViewController.coordinator = self
        detailViewController.hidesBottomBarWhenPushed = hidesBottomBar
        pushViewController(detailViewController, animated: true)
    }
}
```

#### Step 5: Integrate with Main DI Container

```swift
// Add to MainDIContainer.swift
extension MainDIContainer {
    func makeNewModuleDIContainer() -> NewModuleDIContainer {
        return NewModuleDIContainer(appDIContainer: appDIContainer)
    }
}

// Add to MainCoordinator.swift
class MainCoordinator: BaseCoordinator {
    
    func showNewModuleFlow() {
        let newModuleContainer = container.makeNewModuleDIContainer()
        let newModuleCoordinator = newModuleContainer.makeNewModuleFlowCoordinator(
            navigationController: UINavigationController()
        )
        
        newModuleCoordinator.parentCoordinator = self
        childCoordinators.append(newModuleCoordinator)
        newModuleCoordinator.start()
        
        // Present as modal or add to tab bar
        presentViewController(newModuleCoordinator.navigationController, animated: true)
    }
}
```

#### Step 6: How to Use Coordinator in ViewController

```swift
class NewModuleViewController: BaseViewController<NewModuleViewModel> {
    weak var coordinator: NewModuleCoordinator?
    
    // MARK: - Navigation Actions
    @objc private func showDetailAction() {
        // Get selected item ID
        let selectedItemId = 123
        coordinator?.showDetail(itemId: selectedItemId)
    }
    
    @objc private func showModalAction() {
        let selectedItemId = 456
        coordinator?.showDetailModal(itemId: selectedItemId)
    }
    
    @objc private func showOptionsAction() {
        let actions = ["Edit", "Delete", "Share"]
        coordinator?.showActionSheet(title: "Options", actions: actions) { [weak self] selectedIndex in
            switch selectedIndex {
            case 0: // Edit
                self?.handleEdit()
            case 1: // Delete
                self?.handleDelete()
            case 2: // Share
                self?.handleShare()
            default:
                break
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        coordinator?.showAlert(title: "Error", message: message)
    }
    
    private func handleNavigationFromViewModel() {
        // Bind to ViewModel navigation triggers
        viewModel.$shouldShowDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldShow in
                if shouldShow, let itemId = self?.viewModel.selectedItemId {
                    self?.coordinator?.showDetail(itemId: itemId)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDelegate
extension NewModuleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get item ID from data source
        let item = viewModel.items[indexPath.row]
        coordinator?.showDetail(itemId: item.id)
    }
}
```

---

## ✅ Checklist for Implementation

### Before Starting Development

- [ ] Read and understand this architecture document
- [ ] Set up your development environment with Xcode
- [ ] Clone the project and run it successfully
- [ ] Explore the existing code to understand the patterns

### For Each New Feature/Module

- [ ] Create module folder structure (DI, Navigation, Presentation)
- [ ] Follow the MVVM-C pattern strictly
- [ ] Write unit tests for ViewModels
- [ ] Test navigation flows thoroughly
- [ ] Add proper localization
- [ ] Update documentation if needed
- [ ] Get code review approval

### Code Review Checklist

- [ ] No business logic in ViewController
- [ ] All dependencies injected through constructor
- [ ] Navigation handled by Coordinator
- [ ] Memory safety (weak references for coordinators)
- [ ] Protocol-based architecture
- [ ] Proper error handling
- [ ] Consistent naming conventions

---

## 🚨 Common Mistakes to Avoid

1. **Direct ViewController Navigation**
   ```swift
   // ❌ Wrong
   let nextVC = NextViewController()
   navigationController.pushViewController(nextVC, animated: true)
   
   // ✅ Correct
   coordinator.showNextScreen()
   ```

2. **Business Logic in ViewController**
   ```swift
   // ❌ Wrong
   class ViewController: UIViewController {
       func buttonTapped() {
           // API call logic here
       }
   }
   
   // ✅ Correct
   class ViewController: UIViewController {
       func buttonTapped() {
           viewModel.handleButtonTap()
       }
   }
   ```

3. **Global Singletons**
   ```swift
   // ❌ Wrong
   NetworkManager.shared.fetchData()
   
   // ✅ Correct
   networkService.fetchData()
   ```

4. **Strong Reference Cycles**
   ```swift
   // ❌ Wrong
   var coordinator: SomeCoordinator?
   
   // ✅ Correct
   weak var coordinator: SomeCoordinator?
   ```

---

## 📞 Support & Questions

For any questions about this architecture:

1. Refer to existing code examples in the project
2. Follow the patterns established in Home/List/Settings modules
3. Ensure all new code follows the MVVM-C pattern
4. Use dependency injection for all services
5. Test navigation flows thoroughly

**Remember: This architecture is designed for scalability, maintainability, and testability. Following these patterns will ensure consistent, high-quality code.**
