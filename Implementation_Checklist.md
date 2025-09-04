# Implementation Checklist for Outsource Team
## BaseStructoriOSUIKit Development Guide

---

## 📋 Pre-Development Setup

### ✅ Understanding Requirements
- [ ] Read `Architecture_Presentation.md` completely
- [ ] Study `Architecture_Visual_Guide.md` for visual understanding
- [ ] Review `Quick_Reference_Guide.md` for templates
- [ ] Examine existing modules (Home, List, Settings) as examples
- [ ] Understand MVVM-C pattern thoroughly
- [ ] Understand Clean Architecture principles
- [ ] Understand Dependency Injection pattern

### ✅ Project Familiarization
- [ ] Clone and build the project successfully
- [ ] Run the app and navigate through all tabs
- [ ] Examine folder structure and naming conventions
- [ ] Study existing coordinator navigation flows
- [ ] Review DI container implementations
- [ ] Check memory management patterns (weak references)

---

## 🏗️ New Module Development Checklist

### Phase 1: Planning
- [ ] Define module requirements clearly
- [ ] Design data models and entities
- [ ] Plan navigation flow and user interactions
- [ ] Identify required services and dependencies
- [ ] Create module structure plan

### Phase 2: Folder Structure
Create the following folder structure:
```
Modules/[ModuleName]/
├── DI/
│   └── [ModuleName]DIContainer.swift
├── Navigation/
│   └── [ModuleName]Coordinator.swift
└── Presentation/
    ├── ViewModels/
    │   └── [ModuleName]ViewModel.swift
    └── Views/
        └── [ModuleName]ViewController.swift
```

**Checklist:**
- [ ] Create module folder under `Modules/`
- [ ] Create `DI/` subfolder
- [ ] Create `Navigation/` subfolder  
- [ ] Create `Presentation/ViewModels/` subfolder
- [ ] Create `Presentation/Views/` subfolder

### Phase 3: DI Container Implementation
- [ ] Create `[ModuleName]DIContainer.swift`
- [ ] Define factory protocols
- [ ] Implement dependency injection methods
- [ ] Add lazy properties for use cases/repositories
- [ ] Implement factory protocol methods
- [ ] Add coordinator factory method
- [ ] Add module container to main `DIContainer`

**Required Methods:**
```swift
// Factory Protocol
func make[ModuleName]ViewModel() -> [ModuleName]ViewModel
func make[ModuleName]ViewController() -> [ModuleName]ViewController

// Coordinator Factory
func make[ModuleName]FlowCoordinator(navigationController: UINavigationController) -> [ModuleName]Coordinator
```

### Phase 4: ViewModel Implementation
- [ ] Create `[ModuleName]ViewModel.swift`
- [ ] Inherit from `ObservableObject`
- [ ] Define `@Published` properties for UI state
- [ ] Create async Input protocol methods
- [ ] Inject dependencies through initializer
- [ ] Implement business logic methods using async/await
- [ ] Handle loading states
- [ ] Implement error handling
- [ ] Add data transformation logic

**Required Elements:**
```swift
class [ModuleName]ViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
}

protocol [ModuleName]ViewModelInput {
    func loadInitialData() async
    func refreshData() async
    func performAction() async
}

protocol [ModuleName]ViewModelOutput {
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var showError: Bool{ get }
}
```

### Phase 5: ViewController Implementation
- [ ] Create `[ModuleName]ViewController.swift`
- [ ] Inherit from `BaseViewController<[ModuleName]ViewModel>`
- [ ] Conform to `NavigationConfigurable`
- [ ] Add weak coordinator reference
- [ ] Implement UI components with Auto Layout
- [ ] Implement `navigationConfiguration`
- [ ] Bind ViewModel to UI using Combine
- [ ] Handle user interactions with Task wrapper for async calls
- [ ] Call `configureNavigationBar()` in `viewWillAppear`

**Required Elements:**
```swift
weak var coordinator: [ModuleName]Coordinator?
private var cancellables = Set<AnyCancellable>()
var navigationConfiguration: NavigationConfiguration { }

// Example async call in viewDidLoad
override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindViewModel()
    
    Task { @MainActor in
        await viewModel.loadInitialData()
    }
}
```

### Phase 6: Coordinator Implementation
- [ ] Create `[ModuleName]Coordinator.swift`
- [ ] Inherit from `BaseCoordinator`
- [ ] Store DI container reference
- [ ] Implement `start()` method
- [ ] Add navigation methods for module flows
- [ ] Handle modal presentations
- [ ] Implement back navigation
- [ ] Set coordinator references in view controllers

**Required Methods:**
```swift
override func start()
// Navigation methods specific to module
```

### Phase 7: Integration
- [ ] Add module DI container factory to main `DIContainer`
- [ ] Update parent coordinator to include new module
- [ ] Test module creation and navigation
- [ ] Verify memory management (no leaks)
- [ ] Test all navigation flows

---

## 🧪 Testing Checklist

### Unit Testing
- [ ] Test ViewModel business logic
- [ ] Test Use Cases with mock repositories
- [ ] Test Repository implementations with mock data sources
- [ ] Test error handling scenarios
- [ ] Test data transformation logic

### Integration Testing
- [ ] Test navigation flows end-to-end
- [ ] Test DI container dependency resolution
- [ ] Test coordinator memory management
- [ ] Test UI binding with ViewModel changes

### Manual Testing
- [ ] Navigate to all screens in the module
- [ ] Test all user interactions
- [ ] Test error scenarios
- [ ] Test memory usage (no leaks)
- [ ] Test on different devices/orientations

---

## 🔍 Code Review Checklist

### Architecture Compliance
- [ ] Follows MVVM-C pattern strictly
- [ ] No business logic in ViewControllers
- [ ] All navigation through Coordinators
- [ ] Dependencies injected through DI Container
- [ ] Protocol-based architecture used

### Memory Management
- [ ] Coordinator references are weak
- [ ] No retain cycles in closures (use `[weak self]`)
- [ ] Cancellables properly managed
- [ ] View controllers properly deallocated

### Code Quality
- [ ] Consistent naming conventions
- [ ] Proper error handling
- [ ] Clear separation of concerns
- [ ] Single responsibility principle followed
- [ ] Code is readable and maintainable

### iOS Best Practices
- [ ] Auto Layout constraints properly set
- [ ] UI updates on main queue
- [ ] Proper lifecycle method usage
- [ ] Thread safety maintained
- [ ] Performance optimizations applied

---

## 📐 Naming Convention Standards

### Files
- **ViewModel**: `[ModuleName]ViewModel.swift`
- **ViewController**: `[ModuleName]ViewController.swift`
- **Coordinator**: `[ModuleName]Coordinator.swift`
- **DI Container**: `[ModuleName]DIContainer.swift`
- **Use Case**: `[Action][Entity]UseCase.swift`
- **Repository**: `[Entity]Repository.swift` (protocol), `[Entity]RepositoryImpl.swift` (implementation)

### Classes
- **ViewModel**: `[ModuleName]ViewModel`
- **ViewController**: `[ModuleName]ViewController`
- **Coordinator**: `[ModuleName]Coordinator`
- **DI Container**: `[ModuleName]DIContainer`

### Protocols
- **Factory**: `[ModuleName]FactoryProtocol`
- **Service**: `[ServiceName]ServiceProtocol`
- **Repository**: `[Entity]RepositoryProtocol`
- **Use Case**: `[Action][Entity]UseCaseProtocol`

### Variables and Methods
- **Published Properties**: `@Published var isLoading: Bool`
- **Coordinator Reference**: `weak var coordinator: [ModuleName]Coordinator?`
- **Factory Methods**: `make[ComponentName]() -> [ComponentName]`
- **Navigation Methods**: `show[DestinationName]()`, `go[Direction]()`

---

## 🚨 Common Mistakes to Avoid

### ❌ Architecture Violations
- **Business logic in ViewControllers**
  ```swift
  // DON'T DO THIS
  class ViewController: UIViewController {
      func buttonTapped() {
          // API call logic here - WRONG!
      }
  }
  ```

- **Direct ViewController navigation**
  ```swift
  // DON'T DO THIS
  let nextVC = NextViewController()
  navigationController?.pushViewController(nextVC, animated: true)
  ```

- **Global singletons**
  ```swift
  // DON'T DO THIS
  NetworkManager.shared.fetchData()
  ```

### ❌ Memory Management Issues
- **Strong coordinator references**
  ```swift
  // DON'T DO THIS
  var coordinator: SomeCoordinator? // Should be weak!
  ```

- **Retain cycles in closures**
  ```swift
  // DON'T DO THIS
  someMethod { self.doSomething() }
  
  // DO THIS INSTEAD
  someMethod { [weak self] in self?.doSomething() }
  ```

### ❌ UI/Threading Issues
- **UI updates off main queue**
  ```swift
  // DON'T DO THIS
  DispatchQueue.global().async {
      self.label.text = "Updated" // WRONG!
  }
  
  // DO THIS INSTEAD
  DispatchQueue.main.async {
      self.label.text = "Updated"
  }
  ```

---

## 🔧 Debugging Common Issues

### Navigation Not Working
1. Check if coordinator is properly set in ViewController
2. Verify coordinator's `start()` method is called
3. Check if coordinator is added to parent's childCoordinators
4. Verify navigation controller is properly passed

### UI Not Updating
1. Check if properties are marked with `@Published`
2. Verify Combine bindings are set up correctly
3. Ensure UI updates are on main queue
4. Check if cancellables are stored properly

### Memory Leaks
1. Use Instruments to detect leaks
2. Check for retain cycles in closures
3. Verify coordinator references are weak
4. Ensure proper cleanup in deinit methods

### DI Container Issues
1. Check if dependencies are properly injected
2. Verify lazy properties are used correctly
3. Ensure protocol types are used instead of concrete types
4. Check if container is passed correctly through hierarchy

---

## 📞 Final Checklist Before Submission

### Code Quality
- [ ] All code follows project architecture
- [ ] No compiler warnings
- [ ] No force unwrapping (`!`) without proper justification
- [ ] Proper error handling implemented
- [ ] Code is properly commented where needed

### Testing
- [ ] All unit tests pass
- [ ] Manual testing completed
- [ ] No memory leaks detected
- [ ] Performance is acceptable

### Documentation
- [ ] Code is self-documenting
- [ ] Complex logic is commented
- [ ] Public interfaces are documented
- [ ] README updated if needed

### Integration
- [ ] Module integrates properly with existing app
- [ ] No breaking changes to existing functionality
- [ ] Follows existing patterns and conventions
- [ ] Passes code review requirements

---

## 🎯 Success Criteria

Your implementation is successful when:

1. **Architecture Compliance**: Follows MVVM-C pattern strictly
2. **Memory Safety**: No memory leaks or retain cycles
3. **Navigation**: All navigation works through coordinators
4. **Dependency Injection**: All dependencies properly injected
5. **Testing**: Comprehensive test coverage
6. **Code Quality**: Clean, maintainable, and readable code
7. **Performance**: App remains responsive and efficient
8. **Integration**: Seamlessly integrates with existing codebase

Remember: This project serves as a template for future development. Quality and adherence to architecture patterns are more important than speed of delivery.
