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
│  │    Entities     │ │   Use Cases     │ │  Repositories   │   │
│  │                 │ │                 │ │  (Protocols)    │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────┐
│                          Data Layer                             │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │  Data Sources   │ │  Repositories   │ │      DTOs       │   │
│  │                 │ │ (Implementation)│ │                 │   │
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
│   ├── DI/                     # Dependency Injection
│   │   └── DIContainer.swift
│   ├── Extensions/             # Swift extensions
│   ├── Managers/               # Shared managers
│   │   ├── NavigationConfiguration.swift
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

```swift

---

## 💻 Code Examples

### 1. Creating a New Module

#### Step 1: Create DI Container
```swift
class NewModuleDIContainer {
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    func makeNewModuleViewModel() -> NewModuleViewModel {
        return NewModuleViewModel(
            userManager: appDIContainer.makeUserManager()
        )
    }
    
    func makeNewModuleViewController() -> NewModuleViewController {
        let viewModel = makeNewModuleViewModel()
        return NewModuleViewController(viewModel: viewModel)
    }
    
    func makeNewModuleCoordinator(navigationController: UINavigationController) -> NewModuleCoordinator {
        return NewModuleCoordinator(navigationController: navigationController, container: self)
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
    
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var title: String = "New Module"
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(userManager: UserManagerProtocol) {
        self.userManager = userManager
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
        // Business logic here
    }
    
    // MARK: - Private Methods
    private func loadData() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        do {
            // Perform async operations here
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

#### Step 4: Create Coordinator

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
        navigationController.pushViewController(viewController, animated: true)
    }
}
```

### 2. Adding Module to Main DI Container

```swift
extension DIContainer {
    func makeNewModuleDIContainer() -> NewModuleDIContainer {
        return NewModuleDIContainer(appDIContainer: self)
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
