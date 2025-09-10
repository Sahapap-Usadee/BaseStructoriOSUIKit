# BaseStructoriOSUIKit - GitHub Copilot Instructions

**ALWAYS follow these instructions first and only fallback to additional search and context gathering if the information here is incomplete or found to be in error.**

## 🚨 Critical Platform Requirements

This is an iOS UIKit project that **REQUIRES macOS with Xcode** to build, test, and run. 

### Mandatory Prerequisites
- **macOS 14.0+** (required for iOS development)
- **Xcode 16.0+** (confirmed working with version that supports iOS 18.5+ deployment target)
- **iOS Simulator** (included with Xcode)
- **Swift 6.1.2+** (verify with `swift --version`)

### Platform Limitations
- **CANNOT BUILD on Linux/Windows** - This is an Xcode project, not a Swift Package Manager project
- **NO Package.swift** - Uses Xcode project configuration exclusively
- **iOS Simulator Required** - Cannot validate UI functionality without iOS Simulator

## 🏗️ Build & Test Commands (CRITICAL TIMEOUTS)

### Build Commands
```bash
# Navigate to project directory
cd BaseStructoriOSUIKit/

# Clean build (NEVER CANCEL - takes 8-12 minutes on first build)
xcodebuild clean -project BaseStructoriOSUIKit.xcodeproj -scheme BaseStructoriOSUIKit
# TIMEOUT: Use 15+ minutes minimum

# Build for simulator (NEVER CANCEL - takes 5-8 minutes)
xcodebuild build -project BaseStructoriOSUIKit.xcodeproj -scheme BaseStructoriOSUIKit -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest'
# TIMEOUT: Use 10+ minutes minimum

# Build for device (NEVER CANCEL - takes 6-10 minutes) 
xcodebuild build -project BaseStructoriOSUIKit.xcodeproj -scheme BaseStructoriOSUIKit -destination 'generic/platform=iOS'
# TIMEOUT: Use 12+ minutes minimum
```

### Test Commands  
```bash
# Run unit tests (NEVER CANCEL - takes 2-4 minutes)
xcodebuild test -project BaseStructoriOSUIKit.xcodeproj -scheme BaseStructoriOSUIKit -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' -only-testing:BaseStructoriOSUIKitTests
# TIMEOUT: Use 6+ minutes minimum

# Run UI tests (NEVER CANCEL - takes 8-15 minutes)
xcodebuild test -project BaseStructoriOSUIKit.xcodeproj -scheme BaseStructoriOSUIKit -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' -only-testing:BaseStructoriOSUIKitUITests  
# TIMEOUT: Use 20+ minutes minimum

# Run all tests (NEVER CANCEL - takes 10-20 minutes)
xcodebuild test -project BaseStructoriOSUIKit.xcodeproj -scheme BaseStructoriOSUIKit -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest'
# TIMEOUT: Use 25+ minutes minimum
```

### Launch App for Testing
```bash
# Build and run in simulator (for manual validation)
xcodebuild build -project BaseStructoriOSUIKit.xcodeproj -scheme BaseStructoriOSUIKit -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' && open -a Simulator
# Then manually launch the app in simulator for validation
```

## ✅ MANDATORY Validation Scenarios

After ANY code changes, ALWAYS test these complete user flows:

### Core User Flows (Test ALL after changes)
1. **App Launch Flow**: Launch app → Loading screen appears → Transitions to Main TabBar
2. **Home Tab Navigation**: Home tab → Tap "Random Pokemon" → Detail screen opens → Back navigation works
3. **List Tab Functionality**: List tab → Pokemon list loads → Tap any item → Detail view opens → Back navigation works  
4. **Settings Tab Access**: Settings tab → All settings options accessible → Navigation works
5. **Tab Switching**: Switch between all 3 tabs → State preserved → No crashes
6. **Memory Safety**: Navigate through app extensively → No memory warnings → App remains responsive

### Validation Commands (Required After Changes)
```bash
# 1. Build succeeds
xcodebuild build -project BaseStructoriOSUIKit.xcodeproj -scheme BaseStructoriOSUIKit -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest'

# 2. All tests pass
xcodebuild test -project BaseStructoriOSUIKit.xcodeproj -scheme BaseStructoriOSUIKit -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest'

# 3. Launch in simulator and manually test all user flows above
# (This step is CRITICAL - build success ≠ functional app)
```

## 📁 Project Architecture Overview

### Framework & Patterns
- **UIKit Only** (NO SwiftUI)
- **MVVM-C** (Model-View-ViewModel-Coordinator) 
- **Clean Architecture** (Domain, Data, Presentation layers)
- **Dependency Injection** via DIContainer
- **Swift Testing Framework** (import Testing, not XCTest)

### Module Structure (Follow This Pattern)
```
Modules/[ModuleName]/
├── DI/
│   └── [ModuleName]DIContainer.swift          # Factory protocols & container
├── Navigation/  
│   └── [ModuleName]Coordinator.swift          # Navigation logic
└── Presentation/
    ├── [FeatureName]/
    │   ├── [Feature]ViewController.swift      # UI only
    │   └── [Feature]ViewModel.swift           # Business logic
    └── [OtherFeature]/
        ├── [Other]ViewController.swift
        └── [Other]ViewModel.swift
```

### Existing Modules (Reference These)
- **Home**: Pokemon list and detail views
- **List**: Alternative list presentation  
- **Loading**: Initial app loading screen
- **Main**: Tab bar controller
- **Settings**: App settings and about screens

### Core Dependencies
- **Kingfisher 8.5.0**: Image caching (only external dependency)
- **Swift Testing**: Unit testing framework
- **iOS 18.5+**: Minimum deployment target

## 🔧 Development Rules (MUST FOLLOW)

### ✅ REQUIRED Patterns
- **All navigation via Coordinators** - Never direct ViewController → ViewController
- **All business logic in ViewModels** - ViewControllers handle UI only
- **Dependency injection for everything** - No global singletons except AppDIContainer  
- **Protocol-based architecture** - Use protocols for all services/managers
- **Memory safety** - Always use `weak var coordinator` in ViewControllers
- **Swift Testing** - Use `import Testing` and `@Test` for unit tests

### ❌ FORBIDDEN
- **SwiftUI usage** (UIKit only)
- **Business logic in ViewControllers** 
- **Direct ViewController navigation**
- **Global singletons** (except AppDIContainer.shared)
- **Third-party frameworks** (except existing Kingfisher)
- **XCTest framework** (use Swift Testing only)

## 📝 Quick Templates

### 1. New ViewModel Template
```swift
import Foundation
import Combine

// MARK: - [ModuleName] ViewModel Input Protocol
protocol [ModuleName]ViewModelInput {
    func loadInitialData() async
    func refreshData() async
    func performAction() async
}

// MARK: - [ModuleName] ViewModel Output Protocol  
protocol [ModuleName]ViewModelOutput: ObservableObject {
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var showError: Bool { get }
}

// MARK: - [ModuleName] ViewModel
class [ModuleName]ViewModel: [ModuleName]ViewModelOutput {
    
    // MARK: - Dependencies
    public let userManager: UserManagerProtocol
    
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(userManager: UserManagerProtocol) {
        self.userManager = userManager
    }
}

// MARK: - Input Implementation
extension [ModuleName]ViewModel: [ModuleName]ViewModelInput {
    func loadInitialData() async {
        // Implementation here
    }
    
    func refreshData() async {
        // Implementation here  
    }
    
    func performAction() async {
        // Implementation here
    }
}
```

### 2. New ViewController Template
```swift
import UIKit
import Combine

class [ModuleName]ViewController: BaseViewController<[ModuleName]ViewModel>, NavigationConfigurable {
    
    // MARK: - Properties
    weak var coordinator: [ModuleName]Coordinator?
    private var cancellables = Set<AnyCancellable>()
    
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
        
        Task { @MainActor in
            await viewModel.loadInitialData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        // Add UI components
    }
    
    private func bindViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                // Handle loading state
            }
            .store(in: &cancellables)
            
        viewModel.$showError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showError in
                if showError, let message = self?.viewModel.errorMessage {
                    self?.showAlert(message: message)
                }
            }
            .store(in: &cancellables)
    }
}
```

### 3. New Coordinator Template
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
}
```

### 4. New DI Container Template
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

### 5. Unit Test Template (Swift Testing)
```swift
import Testing
import Combine
import Foundation
@testable import BaseStructoriOSUIKit

@Suite("[ModuleName]ViewModel Tests")
struct [ModuleName]ViewModelTests {
    
    let mockUserManager: MockUserManager
    let sut: [ModuleName]ViewModel
    
    init() {
        mockUserManager = MockUserManager()
        sut = [ModuleName]ViewModel(userManager: mockUserManager)
    }
    
    @Test("Initial state should have correct default values")
    func initialState() {
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
        #expect(!sut.showError)
    }
    
    @Test("Load initial data should update loading state")
    func loadInitialDataSuccess() async {
        // Arrange
        mockUserManager.mockResult = .success(/* mock data */)
        
        // Act
        await sut.loadInitialData()
        
        // Assert
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
    }
}
```

## 🚀 Quick Checklist for New Features

### Before Starting
- [ ] Read `Architecture_Presentation.md` for detailed architecture info
- [ ] Study existing modules (Home, List, Settings) as examples  
- [ ] Understand MVVM-C coordinator pattern
- [ ] Verify macOS + Xcode setup

### Development Process
- [ ] Create module folder structure following existing pattern
- [ ] Implement DI Container with factory protocols
- [ ] Create ViewModel with Input/Output protocols
- [ ] Create ViewController extending BaseViewController
- [ ] Create Coordinator extending BaseCoordinator
- [ ] Add module factory to main DIContainer
- [ ] Write unit tests using Swift Testing framework
- [ ] Test navigation flows thoroughly

### Before Submitting
- [ ] Build succeeds (10+ minute timeout)
- [ ] All tests pass (6+ minute timeout for unit tests)
- [ ] Manual validation of all user flows completed
- [ ] Memory safety verified (no retain cycles)
- [ ] Code follows naming conventions
- [ ] No business logic in ViewControllers
- [ ] All dependencies properly injected

## 📚 Additional Resources

### Existing Documentation (Read These First)
- `Architecture_Presentation.md` - Comprehensive architecture guide
- `Quick_Reference_Guide.md` - Templates and patterns
- `Architecture_Visual_Guide.md` - Visual diagrams
- `Implementation_Checklist.md` - Development checklist

### Key Files to Reference
- `Core/Base/BaseCoordinator.swift` - Base coordinator implementation
- `Core/Base/BaseViewController.swift` - Base view controller
- `Core/DI/DIContainer.swift` - Main dependency injection container
- `Modules/Home/` - Complete module example
- `BaseStructoriOSUIKitTests/` - Testing examples

### Useful Exploration Commands
```bash
# View project structure
find BaseStructoriOSUIKit/BaseStructoriOSUIKit -name "*.swift" | head -20

# Check dependencies
cat BaseStructoriOSUIKit/BaseStructoriOSUIKit.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved

# List available schemes
xcodebuild -list -project BaseStructoriOSUIKit.xcodeproj

# Check available simulators
xcrun simctl list devices

# Swift version verification
swift --version
```

### Common File Locations
```
# Repository root structure
BaseStructoriOSUIKit/
├── .github/                           # GitHub configuration
├── BaseStructoriOSUIKit/              # Xcode project folder
│   ├── BaseStructoriOSUIKit/          # Main source code
│   │   ├── Application/               # App lifecycle
│   │   ├── Core/                      # Shared components
│   │   ├── Domain/                    # Business logic layer
│   │   ├── Modules/                   # Feature modules
│   │   └── Resource/                  # Resources & localization
│   ├── BaseStructoriOSUIKitTests/     # Unit tests
│   ├── BaseStructoriOSUIKitUITests/   # UI tests
│   └── BaseStructoriOSUIKit.xcodeproj # Xcode project file
├── Architecture_Presentation.md       # Complete architecture guide
├── Quick_Reference_Guide.md           # Development templates
└── README.md                         # Project overview
```

## 🚨 Critical Reminders

1. **NEVER CANCEL builds or tests** - iOS builds take 5-15 minutes, tests take 2-20 minutes
2. **ALWAYS manually test in iOS Simulator** after any UI changes
3. **ALWAYS use MVVM-C pattern** - No exceptions
4. **ALWAYS inject dependencies** - No global state except AppDIContainer.shared
5. **ALWAYS use weak coordinator references** - Prevent memory leaks
6. **ALWAYS follow existing patterns** - Study Home module as the reference implementation

When in doubt, follow the patterns established in the existing Home, List, and Settings modules!