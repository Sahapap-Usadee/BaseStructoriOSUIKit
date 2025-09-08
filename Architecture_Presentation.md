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
    func performAction() async
    func selectItem(at index: Int)
    func deleteItem(at index: Int) async
    func searchItems(query: String) async
}

// MARK: - New Module ViewModel Output Protocol
protocol NewModuleViewModelOutput: ObservableObject {
    var isLoading: Bool { get }
    var title: String { get }
    var items: [NewModuleItem] { get }
    var filteredItems: [NewModuleItem] { get }
    var selectedItemId: Int? { get }
    var shouldShowDetail: Bool { get }
    var errorMessage: String? { get }
    var showError: Bool { get }
    var isEmpty: Bool { get }
}

// MARK: - New Module ViewModel
class NewModuleViewModel: NewModuleViewModelOutput {
    
    // MARK: - Services & Dependencies
    public let userManager: UserManagerProtocol
    private let getNewModuleDataUseCase: GetNewModuleDataUseCaseProtocol
    private let deleteNewModuleItemUseCase: DeleteNewModuleItemUseCaseProtocol
    private let searchNewModuleItemsUseCase: SearchNewModuleItemsUseCaseProtocol
    
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var title: String = "New Module"
    @Published var items: [NewModuleItem] = []
    @Published var filteredItems: [NewModuleItem] = []
    @Published var selectedItemId: Int?
    @Published var shouldShowDetail: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Computed Properties
    var isEmpty: Bool {
        return filteredItems.isEmpty && !isLoading
    }
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private var searchQuery: String = ""
    
    // MARK: - Initialization
    init(
        userManager: UserManagerProtocol,
        getNewModuleDataUseCase: GetNewModuleDataUseCaseProtocol,
        deleteNewModuleItemUseCase: DeleteNewModuleItemUseCaseProtocol,
        searchNewModuleItemsUseCase: SearchNewModuleItemsUseCaseProtocol
    ) {
        self.userManager = userManager
        self.getNewModuleDataUseCase = getNewModuleDataUseCase
        self.deleteNewModuleItemUseCase = deleteNewModuleItemUseCase
        self.searchNewModuleItemsUseCase = searchNewModuleItemsUseCase
        
        setupBindings()
    }
    
    // MARK: - Private Setup
    private func setupBindings() {
        // Reset shouldShowDetail after triggering navigation
        $shouldShowDetail
            .filter { $0 == true }
            .delay(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.shouldShowDetail = false
            }
            .store(in: &cancellables)
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
    
    func performAction() async {
        // Custom business logic here
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Example: Sync data or perform batch operations
            let result = try await getNewModuleDataUseCase.syncData()
            await MainActor.run {
                // Update UI state
                title = "Action Completed"
            }
        } catch {
            await MainActor.run {
                handleError(error)
            }
        }
    }
    
    func selectItem(at index: Int) {
        guard index < filteredItems.count else { return }
        let item = filteredItems[index]
        selectedItemId = item.id
        shouldShowDetail = true
    }
    
    func deleteItem(at index: Int) async {
        guard index < filteredItems.count else { return }
        let item = filteredItems[index]
        
        do {
            try await deleteNewModuleItemUseCase.execute(itemId: item.id)
            await MainActor.run {
                // Remove from local arrays
                items.removeAll { $0.id == item.id }
                updateFilteredItems()
            }
        } catch {
            await MainActor.run {
                handleError(error)
            }
        }
    }
    
    func searchItems(query: String) async {
        searchQuery = query
        
        if query.isEmpty {
            await MainActor.run {
                updateFilteredItems()
            }
            return
        }
        
        do {
            let searchResults = try await searchNewModuleItemsUseCase.execute(query: query)
            await MainActor.run {
                filteredItems = searchResults
            }
        } catch {
            await MainActor.run {
                handleError(error)
            }
        }
    }
    
    // MARK: - Private Methods
    private func loadData() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        do {
            // Use Case การดึงข้อมูล
            let fetchedItems = try await getNewModuleDataUseCase.execute()
            
            await MainActor.run {
                items = fetchedItems
                updateFilteredItems()
                isLoading = false
                title = "Loaded \(fetchedItems.count) items"
            }
        } catch {
            await MainActor.run {
                handleError(error)
            }
        }
    }
    
    private func updateFilteredItems() {
        if searchQuery.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter { item in
                item.name.localizedCaseInsensitiveContains(searchQuery) ||
                item.description.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
    
    private func handleError(_ error: Error) {
        isLoading = false
        errorMessage = error.localizedDescription
        showError = true
    }
}

// MARK: - Supporting Models
struct NewModuleItem: Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String
    let imageURL: String?
    let createdAt: Date
    let isActive: Bool
}

// MARK: - Use Case Protocols
protocol GetNewModuleDataUseCaseProtocol {
    func execute() async throws -> [NewModuleItem]
    func syncData() async throws -> Bool
}

protocol DeleteNewModuleItemUseCaseProtocol {
    func execute(itemId: Int) async throws
}

protocol SearchNewModuleItemsUseCaseProtocol {
    func execute(query: String) async throws -> [NewModuleItem]
}

// MARK: - Use Case Implementations Example
class GetNewModuleDataUseCase: GetNewModuleDataUseCaseProtocol {
    private let repository: NewModuleRepositoryProtocol
    
    init(repository: NewModuleRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [NewModuleItem] {
        // Business logic here - validation, transformation, etc.
        let items = try await repository.fetchItems()
        
        // Apply business rules
        let activeItems = items.filter { $0.isActive }
        let sortedItems = activeItems.sorted { $0.createdAt > $1.createdAt }
        
        return sortedItems
    }
    
    func syncData() async throws -> Bool {
        // Sync logic
        try await repository.syncWithRemote()
        return true
    }
}

class DeleteNewModuleItemUseCase: DeleteNewModuleItemUseCaseProtocol {
    private let repository: NewModuleRepositoryProtocol
    
    init(repository: NewModuleRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(itemId: Int) async throws {
        // Business validation
        let item = try await repository.getItem(id: itemId)
        
        guard item.isActive else {
            throw NewModuleError.cannotDeleteInactiveItem
        }
        
        // Perform deletion
        try await repository.deleteItem(id: itemId)
        
        // Additional business logic (e.g., logging, notifications)
        // Analytics.track("item_deleted", parameters: ["item_id": itemId])
    }
}

class SearchNewModuleItemsUseCase: SearchNewModuleItemsUseCaseProtocol {
    private let repository: NewModuleRepositoryProtocol
    
    init(repository: NewModuleRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [NewModuleItem] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }
        
        // Business logic for search
        let searchResults = try await repository.searchItems(query: query)
        
        // Apply business rules - e.g., relevance scoring
        let relevantResults = searchResults.filter { item in
            let score = calculateRelevanceScore(item: item, query: query)
            return score > 0.3
        }
        
        return relevantResults.sorted { 
            calculateRelevanceScore(item: $0, query: query) > 
            calculateRelevanceScore(item: $1, query: query) 
        }
    }
    
    private func calculateRelevanceScore(item: NewModuleItem, query: String) -> Double {
        // Simple relevance scoring algorithm
        let nameScore = item.name.localizedCaseInsensitiveContains(query) ? 1.0 : 0.0
        let descScore = item.description.localizedCaseInsensitiveContains(query) ? 0.5 : 0.0
        return nameScore + descScore
    }
}

// MARK: - Custom Errors
enum NewModuleError: LocalizedError {
    case cannotDeleteInactiveItem
    case itemNotFound
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .cannotDeleteInactiveItem:
            return "Cannot delete inactive item"
        case .itemNotFound:
            return "Item not found"
        case .networkError:
            return "Network connection error"
        }
    }
}
```

#### Step 3: Create ViewController

```swift
class NewModuleViewController: BaseViewController<NewModuleViewModel> {
    weak var coordinator: NewModuleCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
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
        viewModel.$title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.title = title
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                // Handle loading state
            }
            .store(in: &cancellables)
        
        viewModel.$showError
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

## 🧪 Testing Guidelines & Examples

### Testing Strategy

- **ViewModels**: Unit tests with mock dependencies
- **Use Cases**: Unit tests with mock repositories  
- **Coordinators**: Navigation flow tests
- **Integration**: End-to-end workflow tests

### Swift Testing Framework Examples

#### Simple ViewModel Testing with Mock Use Case

```swift
import Testing
@testable import BaseStructoriOSUIKit

// MARK: - Mock Use Case
class MockGetDataListUseCase: GetNewModuleDataUseCaseProtocol {
    var mockResult: Result<[NewModuleItem], Error>?
    
    func execute() async throws -> [NewModuleItem] {
        switch mockResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        case .none:
            throw NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock not configured"])
        }
    }
    
    func syncData() async throws -> Bool {
        return true
    }
}

// MARK: - Test Suite
@Suite("NewModuleViewModel Tests")
struct NewModuleViewModelTests {
    
    let mockUserManager: MockUserManager
    let mockGetDataListUseCase: MockGetDataListUseCase
    let sut: NewModuleViewModel

    init() {
        mockUserManager = MockUserManager()
        mockGetDataListUseCase = MockGetDataListUseCase()
        sut = NewModuleViewModel(
            userManager: mockUserManager,
            getNewModuleDataUseCase: mockGetDataListUseCase,
            deleteNewModuleItemUseCase: MockDeleteNewModuleItemUseCase(),
            searchNewModuleItemsUseCase: MockSearchNewModuleItemsUseCase()
        )
    }
    
    @Test("Load data should update items")
    func testLoadDataSuccess() async {
        // Given
        let expectedItems = [
            NewModuleItem(id: 1, name: "Item 1", description: "Description 1", imageURL: nil, createdAt: Date(), isActive: true)
        ]
        mockGetDataListUseCase.mockResult = .success(expectedItems)
        
        // When
        await sut.loadInitialData()
        
        // Then
        #expect(sut.isLoading == false)
        #expect(sut.items.count == 1)
        #expect(sut.title == "Loaded 1 items")
    }
}
```

### Testing Best Practices

#### ✅ Key Points
- Use descriptive test names with Given-When-Then pattern
- Mock external dependencies (Use Cases, Repositories)
- Test async operations with `async throws`
- Use `#expect` for assertions in Swift Testing

---

---

## 📋 Complete Clean Architecture Example

### 1. Domain Layer (Core Business Logic)

#### Domain Entities

```swift
// MARK: - User Entity (Domain Layer)
struct User {
    let id: Int
    let email: String
    let firstName: String
    let profileImage: String?
    let isActive: Bool
}

// MARK: - Product Entity (Domain Layer)
struct Product {
    let id: Int
    let name: String
    let price: Double
    let imageURL: String?
    let category: String
}
```

#### Repository Protocols (Domain Layer)

```swift
// MARK: - Repository Protocols (Domain Layer)
protocol UserRepositoryProtocol {
    func getUsers() async throws -> [User]
    func getUser(id: Int) async throws -> User
    func updateUser(_ user: User) async throws -> User
    func saveUsersLocally(_ users: [User]) async throws
}

protocol ProductRepositoryProtocol {
    func getProducts() async throws -> [Product]
    func getProduct(id: Int) async throws -> Product
    func searchProducts(query: String) async throws -> [Product]
}
```

### 2. Data Layer (External Concerns)

#### DTO (Data Transfer Objects)

```swift
// MARK: - User DTO
struct UserDTO: Codable {
    let id: Int
    let email: String
    let firstName: String
    let profileImage: String?
    let isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, email, isActive
        case firstName = "first_name"
        case profileImage = "profile_image"
    }
}

// MARK: - Product DTO
struct ProductDTO: Codable {
    let id: Int
    let name: String
    let price: Double
    let imageURL: String?
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, price, category
        case imageURL = "image_url"
    }
}

// MARK: - DTO to Domain Mapping
extension UserDTO {
    func toDomain() -> User {
        return User(
            id: id,
            email: email,
            firstName: firstName,
            profileImage: profileImage,
            isActive: isActive
        )
    }
}

extension ProductDTO {
    func toDomain() -> Product {
        return Product(
            id: id,
            name: name,
            price: price,
            imageURL: imageURL,
            category: category
        )
    }
}
```

#### 2. Data Source Protocols & Implementation

```swift
// MARK: - Data Source Protocols
protocol UserRemoteDataSourceProtocol {
    func fetchUsers() async throws -> [UserDTO]
    func fetchUser(id: Int) async throws -> UserDTO
    func updateUser(_ user: UserDTO) async throws -> UserDTO
}

protocol ProductRemoteDataSourceProtocol {
    func fetchProducts() async throws -> [ProductDTO]
    func fetchProduct(id: Int) async throws -> ProductDTO
}

// MARK: - Remote Data Source Implementation
class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchUsers() async throws -> [UserDTO] {
        let response: [UserDTO] = try await networkService.request(
            endpoint: "users",
            method: .GET
        )
        return response
    }
    
    func fetchUser(id: Int) async throws -> UserDTO {
        let response: UserDTO = try await networkService.request(
            endpoint: "users/\(id)",
            method: .GET
        )
        return response
    }
    
    func updateUser(_ user: UserDTO) async throws -> UserDTO {
        let response: UserDTO = try await networkService.request(
            endpoint: "users/\(user.id)",
            method: .PUT,
            body: user
        )
        return response
    }
}
```

#### 3. Repository Implementation (Data Layer)

```swift
// MARK: - Repository Implementation (Data Layer)
class UserRepositoryImpl: UserRepositoryProtocol {
    private let remoteDataSource: UserRemoteDataSourceProtocol
    
    init(remoteDataSource: UserRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getUsers() async throws -> [User] {
        let userDTOs = try await remoteDataSource.fetchUsers()
        return userDTOs.map { $0.toDomain() }
    }
    
    func getUser(id: Int) async throws -> User {
        let userDTO = try await remoteDataSource.fetchUser(id: id)
        return userDTO.toDomain()
    }
    
    func updateUser(_ user: User) async throws -> User {
        let userDTO = user.toDTO()
        let updatedDTO = try await remoteDataSource.updateUser(userDTO)
        return updatedDTO.toDomain()
    }
}

class ProductRepositoryImpl: ProductRepositoryProtocol {
    private let remoteDataSource: ProductRemoteDataSourceProtocol
    
    init(remoteDataSource: ProductRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getProducts() async throws -> [Product] {
        let productDTOs = try await remoteDataSource.fetchProducts()
        return productDTOs.map { $0.toDomain() }
    }
    
    func getProduct(id: Int) async throws -> Product {
        let productDTO = try await remoteDataSource.fetchProduct(id: id)
        return productDTO.toDomain()
    }
    
    func searchProducts(query: String) async throws -> [Product] {
        // For simple example - filter all products
        let allProducts = try await getProducts()
        return allProducts.filter { product in
            product.name.localizedCaseInsensitiveContains(query) ||
            product.category.localizedCaseInsensitiveContains(query)
        }
    }
}

// MARK: - Domain to DTO Mapping Extensions
extension User {
    func toDTO() -> UserDTO {
        return UserDTO(
            id: id,
            email: email,
            firstName: firstName,
            profileImage: profileImage,
            isActive: isActive
        )
    }
}

extension Product {
    func toDTO() -> ProductDTO {
        return ProductDTO(
            id: id,
            name: name,
            price: price,
            imageURL: imageURL,
            category: category
        )
    }
}
```

### 3. Use Case Layer (Application Business Rules)

#### Use Case Protocols & Implementations

```swift
// MARK: - User Use Case Protocols
protocol GetUsersUseCaseProtocol {
    func execute() async throws -> [User]
}

protocol GetUserDetailUseCaseProtocol {
    func execute(id: Int) async throws -> User
}

protocol UpdateUserUseCaseProtocol {
    func execute(_ user: User) async throws -> User
}

// MARK: - Product Use Case Protocols
protocol GetProductsUseCaseProtocol {
    func execute() async throws -> [Product]
}

protocol SearchProductsUseCaseProtocol {
    func execute(query: String) async throws -> [Product]
}

// MARK: - User Use Case Implementations
class GetUsersUseCase: GetUsersUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [User] {
        let users = try await repository.getUsers()
        
        // Business logic: Filter active users only
        let activeUsers = users.filter { $0.isActive }
        
        // Business logic: Sort by first name
        return activeUsers.sorted { $0.firstName < $1.firstName }
    }
}

class UpdateUserUseCase: UpdateUserUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ user: User) async throws -> User {
        // Business validation
        guard !user.email.isEmpty else {
            throw UserUseCaseError.invalidEmail
        }
        
        guard !user.firstName.isEmpty else {
            throw UserUseCaseError.invalidName
        }
        
        return try await repository.updateUser(user)
    }
}

// MARK: - Product Use Case Implementations
class GetProductsUseCase: GetProductsUseCaseProtocol {
    private let repository: ProductRepositoryProtocol
    
    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Product] {
        let products = try await repository.getProducts()
        
        // Business logic: Sort by price (low to high)
        return products.sorted { $0.price < $1.price }
    }
}

class SearchProductsUseCase: SearchProductsUseCaseProtocol {
    private let repository: ProductRepositoryProtocol
    
    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [Product] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ProductUseCaseError.emptySearchQuery
        }
        
        let searchResults = try await repository.searchProducts(query: query)
        
        // Business logic: Sort by relevance
        return searchResults.sorted { $0.name.localizedCaseInsensitiveContains(query) && !$1.name.localizedCaseInsensitiveContains(query) }
    }
}

// MARK: - Use Case Errors
enum UserUseCaseError: LocalizedError {
    case invalidEmail
    case invalidName
    case updateFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Email cannot be empty"
        case .invalidName:
            return "First name cannot be empty"
        case .updateFailed:
            return "Failed to update user"
        }
    }
}

enum ProductUseCaseError: LocalizedError {
    case emptySearchQuery
    case searchFailed
    
    var errorDescription: String? {
        switch self {
        case .emptySearchQuery:
            return "Search query cannot be empty"
        case .searchFailed:
            return "Product search failed"
        }
    }
}
```

---

## 📞 Support & Questions

For any questions about this architecture:

1. Refer to existing code examples in the project
2. Follow the patterns established in Home/List/Settings modules
3. Ensure all new code follows the MVVM-C pattern
4. Use dependency injection for all services
**Remember: This architecture is designed for scalability, maintainability, and testability. Following these patterns will ensure consistent, high-quality code.**
