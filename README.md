# BaseStructoriOSUIKit

## 📱 Modern iOS App Structure 2025

### 🏗️ Architecture Overview
This project follows **MVVM-C (Model-View-ViewModel-Coordinator)** pattern with modern iOS best practices for 2025.

### 🛠️ Technology Stack

| Layer                  | Technology / Tool                  | Purpose                                     |
| ---------------------- | ---------------------------------- | ------------------------------------------- |
| **UI Framework**       | UIKit (Programmatic)               | Native UI without Storyboards              |
| **Architecture**       | MVVM-C + Combine                   | Coordinator pattern + reactive programming  |
| **Networking**         | Alamofire + URLSession             | RESTful API with modern async/await        |
| **Dependency Injection** | Custom DI Container              | Loose coupling & testability               |
| **Local Storage**      | Core Data + UserDefaults          | Persistent data & user preferences         |
| **Image Loading**      | Kingfisher                         | Async image loading with caching           |
| **Testing**            | XCTest + Quick/Nimble              | Unit & UI testing                          |
| **Analytics**          | Firebase Analytics                 | User behavior tracking                     |
| **Crash Reporting**    | Firebase Crashlytics               | Error tracking & monitoring                |

### 📁 Project Structure

```
BaseStructoriOSUIKit/
├── Application/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── AppCoordinator.swift
│
├── Core/
│   ├── Networking/
│   │   ├── NetworkManager.swift
│   │   ├── APIClient.swift
│   │   ├── NetworkError.swift
│   │   └── Endpoints/
│   │       └── APIEndpoint.swift
│   │
│   ├── DependencyInjection/
│   │   ├── DIContainer.swift
│   │   └── ServiceRegistry.swift
│   │
│   ├── Storage/
│   │   ├── CoreDataManager.swift
│   │   ├── UserDefaultsManager.swift
│   │   └── KeychainManager.swift
│   │
│   ├── Extensions/
│   │   ├── UIView+Extensions.swift
│   │   ├── UIViewController+Extensions.swift
│   │   └── String+Extensions.swift
│   │
│   └── Utils/
│       ├── Logger.swift
│       ├── DateFormatter.swift
│       └── Constants.swift
│
├── Modules/
│   ├── Loading/
│   │   ├── LoadingCoordinator.swift
│   │   ├── LoadingViewController.swift
│   │   └── LoadingViewModel.swift
│   │
│   ├── Main/
│   │   ├── MainCoordinator.swift
│   │   ├── MainTabBarController.swift
│   │   └── MainViewModel.swift
│   │
│   ├── TabOne/
│   │   ├── TabOneCoordinator.swift
│   │   ├── TabOneViewController.swift
│   │   ├── TabOneViewModel.swift
│   │   └── Views/
│   │       └── TabOneCustomView.swift
│   │
│   ├── TabTwo/
│   │   ├── TabTwoCoordinator.swift
│   │   ├── TabTwoViewController.swift
│   │   ├── TabTwoViewModel.swift
│   │   └── Views/
│   │
│   └── TabThree/
│       ├── TabThreeCoordinator.swift
│       ├── TabThreeViewController.swift
│       ├── TabThreeViewModel.swift
│       └── Views/
│
├── Models/
│   ├── Domain/
│   │   └── User.swift
│   │
│   └── API/
│       ├── UserResponse.swift
│       └── ErrorResponse.swift
│
├── Resources/
│   ├── Assets.xcassets/
│   ├── Colors.xcassets/
│   ├── Localizable.strings
│   └── Info.plist
│
└── Supporting Files/
    └── LaunchScreen.storyboard (เฉพาะ Launch Screen เท่านั้น)
```

### 🎯 App Flow Description

**Demo App: Tab-Based Navigation with Loading Screen**

1. **Loading Screen** → แสดงหน้าโหลด พร้อม animation
2. **Main Tab Bar** → 3 tabs สำหรับทดสอบ navigation patterns:
   - **Tab 1**: List View + Detail navigation
   - **Tab 2**: Form & Modal presentations  
   - **Tab 3**: Settings & Utility features

### 🔄 Key Features & Patterns

#### **1. Coordinator Pattern**
- ✅ No Storyboard dependencies (เฉพาะ LaunchScreen)
- ✅ Centralized navigation logic
- ✅ Loose coupling between ViewControllers

#### **2. Modern Networking**
- ✅ Async/await support
- ✅ Generic API client with Repository pattern
- ✅ Automatic retry logic & timeout handling
- ✅ Response caching & offline support
- ✅ Use Case pattern for business logic
- ✅ Protocol-based architecture for testing

#### **3. Dependency Injection**
- ✅ Protocol-based services
- ✅ Easy testing & mocking
- ✅ Clean architecture

#### **4. UI Best Practices**
- ✅ Programmatic Auto Layout
- ✅ Reusable UI components
- ✅ Dark mode support
- ✅ Accessibility compliance
- ✅ Custom Navigation Bar styling per screen
- ✅ Centralized navigation appearance management

### 🧪 Testing Strategy

```
Tests/
├── UnitTests/
│   ├── ViewModelTests/
│   ├── NetworkingTests/
│   └── UtilsTests/
│
├── IntegrationTests/
│   └── APIIntegrationTests/
│
└── UITests/
    ├── LoadingFlowTests/
    └── MainTabFlowTests/
```

### 🧭 Navigation Bar Management

#### **Navigation Architecture**
```
Core/Navigation/
├── NavigationBarManager.swift       // Global navigation styling
├── NavigationBarConfigurator.swift  // Per-screen configuration
├── NavigationBarStyle.swift         // Style definitions
└── Extensions/
    ├── UIViewController+Navigation.swift
    └── UINavigationController+Styling.swift
```

#### **Navigation Bar Patterns**

**1. Global Navigation Appearance**
```swift
class NavigationBarManager {
    static let shared = NavigationBarManager()
    
    func setupGlobalAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
```

**2. Per-Screen Navigation Configuration**
```swift
protocol NavigationConfigurable {
    func configureNavigationBar()
    var navigationBarStyle: NavigationBarStyle { get }
}

enum NavigationBarStyle {
    case `default`
    case transparent
    case colored(UIColor)
    case gradient([UIColor])
    case hidden
    
    case custom(NavigationBarConfiguration)
}

struct NavigationBarConfiguration {
    let backgroundColor: UIColor?
    let titleColor: UIColor?
    let titleFont: UIFont?
    let isTranslucent: Bool
    let prefersLargeTitles: Bool
    let hideBackButtonText: Bool
    let customBackButton: UIImage?
}
```

**3. Screen-Specific Implementation**
```swift
class TabOneViewController: UIViewController, NavigationConfigurable {
    
    var navigationBarStyle: NavigationBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        title = "หน้าแรก"
        
        // Right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        // Custom back button (if needed)
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    @objc private func addButtonTapped() {
        // Handle add action
    }
}

// Special cases
class TransparentNavViewController: UIViewController, NavigationConfigurable {
    var navigationBarStyle: NavigationBarStyle {
        return .transparent
    }
    
    func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
```

**4. Coordinator Navigation Management**
```swift
class TabOneCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    func start() {
        let viewController = TabOneViewController()
        
        // Apply navigation styling through coordinator
        applyNavigationStyling(to: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func applyNavigationStyling(to viewController: NavigationConfigurable) {
        switch viewController.navigationBarStyle {
        case .default:
            setDefaultNavigationStyle()
        case .transparent:
            setTransparentNavigationStyle()
        case .colored(let color):
            setColoredNavigationStyle(color)
        case .hidden:
            navigationController.setNavigationBarHidden(true, animated: true)
        case .custom(let config):
            setCustomNavigationStyle(config)
        }
    }
}
```

#### **Advanced Navigation Patterns**

**1. Custom Navigation Bar Components**
```swift
class CustomNavigationBarView: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let profileImageView = UIImageView()
    
    func configure(title: String, subtitle: String?, profileImage: UIImage?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        profileImageView.image = profileImage
        
        setupLayout()
    }
}

// ใช้ใน ViewController
override func viewDidLoad() {
    super.viewDidLoad()
    
    let customView = CustomNavigationBarView()
    customView.configure(
        title: "สวัสดี สหภาพ",
        subtitle: "ออนไลน์",
        profileImage: UIImage(named: "profile")
    )
    navigationItem.titleView = customView
}
```

**2. Animated Navigation Transitions**
```swift
extension UIViewController {
    func setNavigationBarStyle(_ style: NavigationBarStyle, animated: Bool = true) {
        guard let navigationController = navigationController else { return }
        
        if animated {
            UIView.transition(
                with: navigationController.navigationBar,
                duration: 0.3,
                options: .transitionCrossDissolve
            ) {
                self.applyNavigationStyle(style)
            }
        } else {
            applyNavigationStyle(style)
        }
    }
}
```

**3. Tab-Specific Navigation Styling**
```swift
class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabSpecificNavigation()
    }
    
    private func setupTabSpecificNavigation() {
        // Tab 1: Default style
        let tab1Nav = createNavigationController(
            rootViewController: TabOneViewController(),
            title: "หน้าแรก",
            image: UIImage(systemName: "house")
        )
        
        // Tab 2: Custom colored navigation
        let tab2Nav = createNavigationController(
            rootViewController: TabTwoViewController(),
            title: "รายการ",
            image: UIImage(systemName: "list.bullet")
        )
        tab2Nav.navigationBar.tintColor = .systemBlue
        
        // Tab 3: Large title style
        let tab3Nav = createNavigationController(
            rootViewController: TabThreeViewController(),
            title: "ตั้งค่า",
            image: UIImage(systemName: "gearshape")
        )
        tab3Nav.navigationBar.prefersLargeTitles = true
        
        viewControllers = [tab1Nav, tab2Nav, tab3Nav]
    }
}
```

**4. Navigation Bar Extensions**
```swift
extension UIViewController {
    
    // ซ่อน navigation bar เมื่อ scroll
    func hideNavigationBarOnSwipe() {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    // Custom back button
    func setCustomBackButton(image: UIImage? = nil, title: String? = nil) {
        let backButton = UIBarButtonItem()
        backButton.title = title ?? ""
        backButton.image = image
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    // Navigation bar gradient
    func setNavigationBarGradient(colors: [UIColor]) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = navigationBar.bounds
        
        navigationBar.setBackgroundImage(gradientLayer.toImage(), for: .default)
    }
}
```

#### **Navigation Best Practices**

**1. Consistent Styling**
- ใช้ NavigationBarManager สำหรับ global styling
- แต่ละหน้าจอควรมี consistent style ภายใน flow เดียวกัน

**2. Accessibility**
```swift
func configureAccessibility() {
    navigationItem.rightBarButtonItem?.accessibilityLabel = "เพิ่มรายการใหม่"
    navigationItem.leftBarButtonItem?.accessibilityLabel = "ย้อนกลับ"
}
```

**3. State Management**
```swift
class NavigationState: ObservableObject {
    @Published var title: String = ""
    @Published var isLoading: Bool = false
    @Published var rightButtonEnabled: Bool = true
    
    func updateNavigationBar(in viewController: UIViewController) {
        viewController.title = title
        viewController.navigationItem.rightBarButtonItem?.isEnabled = rightButtonEnabled
    }
}
```

### 🌐 Network Architecture Details

#### **Network Layer Structure**
```
Core/Networking/
├── Base/
│   ├── NetworkService.swift          // Main network service
│   ├── EndpointType.swift           // Endpoint protocol
│   ├── HTTPMethod.swift             // HTTP methods enum
│   └── NetworkError.swift           // Custom error types
│
├── Repositories/
│   ├── UserRepository.swift         // User data repository
│   ├── AuthRepository.swift         // Authentication repository
│   └── ConfigRepository.swift       // App config repository
│
├── UseCases/
│   ├── FetchUsersUseCase.swift      // Business logic
│   ├── LoginUseCase.swift           // Login flow
│   └── RefreshTokenUseCase.swift    // Token refresh
│
├── Endpoints/
│   ├── UserEndpoint.swift           // User API endpoints
│   ├── AuthEndpoint.swift           // Auth endpoints
│   └── ConfigEndpoint.swift         // Config endpoints
│
└── Models/
    ├── API/
    │   ├── UserResponse.swift        // API response models
    │   ├── LoginResponse.swift
    │   └── ErrorResponse.swift
    │
    └── Domain/
        ├── User.swift               // Domain models
        ├── AuthToken.swift
        └── AppConfig.swift
```

#### **Real-World Use Cases Examples**

**1. User Management Flow**
```swift
// Use Case: Fetch user profile
class FetchUserProfileUseCase {
    private let userRepository: UserRepositoryProtocol
    
    func execute(userId: String) async throws -> User {
        // Business logic: validation, transformation
        return try await userRepository.fetchUser(id: userId)
    }
}

// Repository Implementation
class UserRepository: UserRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    func fetchUser(id: String) async throws -> User {
        let endpoint = UserEndpoint.getUser(id: id)
        let response: UserResponse = try await networkService.request(endpoint)
        return response.toDomainModel()
    }
}
```

**2. Authentication Flow**
```swift
// Use Case: Login with automatic token refresh
class LoginUseCase {
    private let authRepository: AuthRepositoryProtocol
    private let keychainManager: KeychainManagerProtocol
    
    func execute(email: String, password: String) async throws -> AuthResult {
        let authData = try await authRepository.login(email: email, password: password)
        await keychainManager.store(token: authData.token)
        return authData
    }
}
```

**3. Data Synchronization**
```swift
// Use Case: Sync app data with offline support
class SyncDataUseCase {
    private let repositories: [SyncableRepository]
    private let connectivityService: ConnectivityServiceProtocol
    
    func execute() async throws {
        guard await connectivityService.isConnected else {
            throw NetworkError.noConnection
        }
        
        for repository in repositories {
            try await repository.sync()
        }
    }
}
```

#### **Network Service Features**

**1. Automatic Retry Logic**
```swift
class NetworkService: NetworkServiceProtocol {
    func request<T: Codable>(_ endpoint: EndpointType) async throws -> T {
        return try await withRetry(maxAttempts: 3) {
            // Network request implementation
        }
    }
}
```

**2. Response Caching**
```swift
protocol CacheServiceProtocol {
    func cache<T: Codable>(_ object: T, for key: String)
    func retrieve<T: Codable>(_ type: T.Type, for key: String) -> T?
}
```

**3. Request/Response Logging**
```swift
class NetworkLogger {
    static func logRequest(_ endpoint: EndpointType) { }
    static func logResponse(_ data: Data, _ response: URLResponse) { }
    static func logError(_ error: Error) { }
}
```

### 📱 Demo App Features

- **Loading Screen**: Animated loading with progress indication
- **Tab Navigation**: 3 main tabs with different interaction patterns
- **Modal Presentations**: Various modal styles (fullscreen, card, etc.)
- **Navigation Patterns**: Push/pop, present/dismiss examples
- **Error Handling**: Graceful error states and user feedback

### 💡 Network Implementation Examples

#### **Common API Patterns**

**1. RESTful CRUD Operations**
```swift
enum UserEndpoint: EndpointType {
    case getUsers
    case getUser(id: String)
    case createUser(User)
    case updateUser(id: String, User)
    case deleteUser(id: String)
    
    var method: HTTPMethod {
        switch self {
        case .getUsers, .getUser: return .GET
        case .createUser: return .POST
        case .updateUser: return .PUT
        case .deleteUser: return .DELETE
        }
    }
}
```

**2. File Upload with Progress**
```swift
class FileUploadUseCase {
    func uploadImage(_ image: UIImage) async throws -> UploadResult {
        let data = image.jpegData(compressionQuality: 0.8)
        return try await networkService.upload(data, to: .uploadImage) { progress in
            // Update UI with progress
        }
    }
}
```

**3. Real-time Data (WebSocket/Server-Sent Events)**
```swift
protocol RealTimeServiceProtocol {
    func connect() async throws
    func subscribe(to channel: String) async throws
    var messageStream: AsyncStream<Message> { get }
}
```

#### **Error Handling Strategy**

```swift
enum NetworkError: Error {
    case noConnection
    case timeout
    case unauthorized
    case serverError(Int)
    case decodingError
    case unknown(Error)
    
    var userMessage: String {
        switch self {
        case .noConnection: return "ไม่มีการเชื่อมต่ออินเทอร์เน็ต"
        case .timeout: return "หมดเวลาในการเชื่อมต่อ"
        case .unauthorized: return "กรุณาเข้าสู่ระบบใหม่"
        case .serverError: return "เซิร์ฟเวอร์ขัดข้อง กรุณาลองใหม่"
        default: return "เกิดข้อผิดพลาด กรุณาลองใหม่"
        }
    }
}
```

#### **Testing Network Layer**

```swift
// Mock Network Service for Testing
class MockNetworkService: NetworkServiceProtocol {
    var shouldFail = false
    var mockResponse: Any?
    
    func request<T: Codable>(_ endpoint: EndpointType) async throws -> T {
        if shouldFail {
            throw NetworkError.serverError(500)
        }
        return mockResponse as! T
    }
}

// Unit Test Example
func testFetchUsers() async throws {
    // Given
    let mockService = MockNetworkService()
    mockService.mockResponse = [User(id: "1", name: "Test")]
    let useCase = FetchUsersUseCase(repository: UserRepository(networkService: mockService))
    
    // When
    let users = try await useCase.execute()
    
    // Then
    XCTAssertEqual(users.count, 1)
    XCTAssertEqual(users.first?.name, "Test")
}
```

### 🚀 Getting Started

1. Clone the repository
2. Open `BaseStructoriOSUIKit.xcodeproj`
3. Build and run the project
4. Explore different navigation patterns in each tab

### 📋 TODO Implementation Plan

- [ ] Setup Coordinator pattern structure
- [ ] Implement Loading screen with animations
- [ ] Create Main TabBar with 3 tabs
- [ ] Setup Networking layer with modern patterns
- [ ] Add Dependency Injection container
- [ ] Implement navigation examples in each tab
- [ ] Add unit tests for core components
- [ ] Setup UI tests for main flows

### 🎯 Advanced Architecture Recommendations 2025

#### **1. Class-Based Navigation Manager**

```swift
// Central Navigation Manager
class NavigationManager {
    static let shared = NavigationManager()
    private var navigationStacks: [String: UINavigationController] = [:]
    
    // Navigation factory methods
    func createNavigationController(
        rootViewController: UIViewController,
        style: NavigationBarStyle = .default
    ) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        applyNavigationStyle(style, to: navController)
        return navController
    }
    
    // Smart navigation methods
    func push<T: UIViewController>(_ viewControllerType: T.Type, 
                                   from coordinator: Coordinator,
                                   animated: Bool = true) {
        let viewController = createViewController(type: viewControllerType, coordinator: coordinator)
        coordinator.navigationController.pushViewController(viewController, animated: animated)
    }
    
    func present<T: UIViewController>(_ viewControllerType: T.Type,
                                      from coordinator: Coordinator,
                                      style: UIModalPresentationStyle = .automatic) {
        let viewController = createViewController(type: viewControllerType, coordinator: coordinator)
        coordinator.navigationController.present(viewController, animated: true)
    }
}

// Navigation Builder Pattern
class NavigationBuilder {
    private var configuration = NavigationConfiguration()
    
    func title(_ title: String) -> NavigationBuilder {
        configuration.title = title
        return self
    }
    
    func style(_ style: NavigationBarStyle) -> NavigationBuilder {
        configuration.style = style
        return self
    }
    
    func rightButton(image: UIImage?, action: @escaping () -> Void) -> NavigationBuilder {
        configuration.rightButtonConfig = (image, action)
        return self
    }
    
    func build() -> NavigationConfiguration {
        return configuration
    }
}
```

#### **2. Enhanced Project Structure**

```
BaseStructoriOSUIKit/
├── Application/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── AppCoordinator.swift
│   └── Configuration/
│       ├── AppConfiguration.swift
│       └── Environment.swift
│
├── Core/
│   ├── Networking/
│   │   ├── Base/
│   │   ├── Repositories/
│   │   ├── UseCases/
│   │   └── Interceptors/              // 🆕 Request/Response interceptors
│   │       ├── AuthInterceptor.swift
│   │       └── LoggingInterceptor.swift
│   │
│   ├── Navigation/                     // 🆕 Enhanced Navigation
│   │   ├── NavigationManager.swift
│   │   ├── NavigationBuilder.swift
│   │   ├── TransitionAnimator.swift
│   │   └── DeepLinkHandler.swift
│   │
│   ├── UI/                             // 🆕 Reusable UI Components
│   │   ├── Components/
│   │   │   ├── CustomButton.swift
│   │   │   ├── LoadingView.swift
│   │   │   └── EmptyStateView.swift
│   │   ├── Themes/
│   │   │   ├── AppTheme.swift
│   │   │   └── ColorPalette.swift
│   │   └── Layout/
│   │       ├── LayoutConstants.swift
│   │       └── AutoLayoutHelpers.swift
│   │
│   ├── Analytics/                      // 🆕 Analytics Layer
│   │   ├── AnalyticsManager.swift
│   │   ├── EventTracker.swift
│   │   └── Events/
│   │       └── UserEvents.swift
│   │
│   └── Security/                       // 🆕 Security Layer
│       ├── BiometricManager.swift
│       ├── CertificatePinning.swift
│       └── DataProtection.swift
```

#### **3. Modern Navigation Flow Manager**

```swift
// Advanced Coordinator with Navigation Management
protocol NavigationFlowManager {
    var navigationManager: NavigationManager { get }
    func showScreen<T: ScreenProtocol>(_ screen: T, transition: TransitionType)
    func showModal<T: ModalProtocol>(_ modal: T, style: ModalStyle)
    func dismissToRoot()
}

// Screen Protocol for type-safe navigation
protocol ScreenProtocol {
    associatedtype ViewControllerType: UIViewController
    var viewController: ViewControllerType { get }
    var navigationConfig: NavigationConfiguration { get }
}

// Example Implementation
struct UserProfileScreen: ScreenProtocol {
    let userId: String
    
    var viewController: UserProfileViewController {
        let vc = UserProfileViewController()
        vc.userId = userId
        return vc
    }
    
    var navigationConfig: NavigationConfiguration {
        return NavigationBuilder()
            .title("โปรไฟล์ผู้ใช้")
            .style(.default)
            .rightButton(image: UIImage(systemName: "square.and.arrow.up")) {
                // Share action
            }
            .build()
    }
}

// Usage in Coordinator
class UserCoordinator: NavigationFlowManager {
    let navigationManager = NavigationManager.shared
    
    func showUserProfile(userId: String) {
        let screen = UserProfileScreen(userId: userId)
        showScreen(screen, transition: .push)
    }
}
```

#### **4. Reactive Navigation State**

```swift
// Navigation State Management with Combine
class NavigationStateManager: ObservableObject {
    @Published var currentScreen: ScreenIdentifier?
    @Published var navigationStack: [ScreenIdentifier] = []
    @Published var modalStack: [ModalIdentifier] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func trackNavigation() {
        // Track navigation changes
        $currentScreen
            .sink { screen in
                AnalyticsManager.shared.track(.screenViewed(screen?.rawValue ?? "unknown"))
            }
            .store(in: &cancellables)
    }
}

// Deep Link Handler
class DeepLinkHandler {
    static let shared = DeepLinkHandler()
    
    func handle(url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = components.host else { return false }
        
        switch host {
        case "user":
            handleUserDeepLink(components: components)
            return true
        case "product":
            handleProductDeepLink(components: components)
            return true
        default:
            return false
        }
    }
    
    private func handleUserDeepLink(components: URLComponents) {
        // Navigate to user screen
    }
}
```

#### **5. Enhanced UI Components System**

```swift
// Theme Management
class AppTheme {
    static let current = AppTheme()
    
    struct Colors {
        static let primary = UIColor.systemBlue
        static let secondary = UIColor.systemGray
        static let background = UIColor.systemBackground
        static let surface = UIColor.secondarySystemBackground
    }
    
    struct Typography {
        static let heading1 = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let heading2 = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let body = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let caption = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }
}

// Reusable Button Component
class AppButton: UIButton {
    enum Style {
        case primary, secondary, tertiary, destructive
    }
    
    private let style: Style
    
    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setupAppearance()
    }
    
    private func setupAppearance() {
        switch style {
        case .primary:
            backgroundColor = AppTheme.Colors.primary
            setTitleColor(.white, for: .normal)
        case .secondary:
            backgroundColor = AppTheme.Colors.secondary
            setTitleColor(.label, for: .normal)
        // ... other cases
        }
        
        layer.cornerRadius = 8
        titleLabel?.font = AppTheme.Typography.body
    }
}
```

#### **6. Performance & Monitoring**

```swift
// Performance Monitor
class PerformanceMonitor {
    static let shared = PerformanceMonitor()
    
    func trackScreenLoadTime(for screen: String) {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Track completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let loadTime = CFAbsoluteTimeGetCurrent() - startTime
            AnalyticsManager.shared.track(.performanceMetric(screen: screen, loadTime: loadTime))
        }
    }
    
    func trackMemoryUsage() {
        let memoryUsage = getMemoryUsage()
        if memoryUsage > 100 { // MB threshold
            Logger.shared.warning("High memory usage: \(memoryUsage)MB")
        }
    }
}

// Error Boundary Pattern
class ErrorBoundary {
    static func handle(_ error: Error, in context: String) {
        Logger.shared.error("Error in \(context): \(error)")
        CrashlyticsManager.shared.record(error, context: context)
        
        // Show user-friendly error
        NotificationCenter.default.post(
            name: .showErrorMessage,
            object: error.localizedDescription
        )
    }
}
```

#### **7. Advanced Testing Infrastructure**

```swift
// Test Helpers
class NavigationTestHelper {
    static func mockNavigationController() -> UINavigationController {
        let mockVC = UIViewController()
        return UINavigationController(rootViewController: mockVC)
    }
    
    static func assertNavigationStack(
        _ navigationController: UINavigationController,
        contains viewControllerTypes: [UIViewController.Type]
    ) {
        let actualTypes = navigationController.viewControllers.map { type(of: $0) }
        XCTAssertEqual(actualTypes.count, viewControllerTypes.count)
        
        for (index, expectedType) in viewControllerTypes.enumerated() {
            XCTAssertTrue(actualTypes[index] == expectedType)
        }
    }
}

// Integration Test Base Class
class BaseIntegrationTest: XCTestCase {
    var app: XCUIApplication!
    var navigationHelper: NavigationTestHelper!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        navigationHelper = NavigationTestHelper()
        app.launch()
    }
    
    func testCompleteUserFlow() {
        // Test loading -> main -> tab navigation
        navigationHelper.waitForLoadingScreen()
        navigationHelper.waitForMainScreen()
        navigationHelper.tapTab(.first)
        navigationHelper.assertCurrentScreen(.tabOne)
    }
}
```
