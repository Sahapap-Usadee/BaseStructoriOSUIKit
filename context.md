# เอกสารข้อกำหนดผลิตภัณฑ์: BaseStructoriOSUIKit

## 1. ภาพรวมโปรเจกต์
BaseStructoriOSUIKit คือโปรเจกต์แอป iOS แบบโมดูลาร์ที่ใช้ UIKit, สถาปัตยกรรม MVVM-C (Model-View-ViewModel-Coordinator), Clean Architecture และ Dependency Injection ออกแบบมาเพื่อรองรับการขยาย ดูแล และทดสอบได้ง่าย เหมาะกับแอประดับองค์กรที่มีหลายโมดูลและหลายสภาพแวดล้อม

## 2. สถาปัตยกรรมและเทคโนโลยีหลัก

### 2.1 Clean Architecture

- **Domain Layer**: Entities, Use Cases, Repository Protocols
- **Data Layer**: DTOs, Data Sources, Repository Implementations
- **Presentation Layer**: Views, ViewModels, Coordinators

### 2.2 ฟีเจอร์หลัก

- โครงสร้างแบบโมดูล: Home, List, Loading, Main, Settings
- สถาปัตยกรรม MVVM-C พร้อม Coordinator pattern
- ใช้ Dependency Injection ผ่าน DIContainer
- ระบบนำทางแบบกำหนดเอง (NavigationManager, NavigationConfiguration)
- Flow โหลดข้อมูลด้วย LoadingCoordinator
- Flow หลักด้วย MainCoordinator และ TabBar
- รองรับหลายสภาพแวดล้อม (Debug, Dev, PreProd, Release, UAT)
- จัดการ Asset (Assets.xcassets)
- Network Layer ด้วย async/await
- Image Loading ด้วย Kingfisher
- Combine Framework สำหรับ Reactive Programming
- ครบครันด้วย Extensions และ Utilities

## 3. โครงสร้างโปรเจกต์

```text
BaseStructoriOSUIKit/
├── BaseStructoriOSUIKit/
│   ├── Application/
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Assets.xcassets/
│   │   ├── AccentColor.colorset/
│   │   └── AppIcon.appiconset/
│   ├── Core/
│   │   ├── Base/
│   │   │   ├── BaseCoordinator.swift
│   │   │   └── BaseViewController.swift
│   │   ├── DI/
│   │   │   └── DIContainer.swift
│   │   ├── Extensions/
│   │   │   ├── Kingfisher+Extensions.swift
│   │   │   ├── String+Extensions.swift
│   │   │   ├── UIView+Extensions.swift
│   │   │   └── UIViewController+Extensions.swift
│   │   ├── Managers/
│   │   │   ├── NavigationConfiguration.swift
│   │   │   ├── NavigationManager.swift
│   │   │   ├── SessionManager.swift
│   │   │   └── UserManager.swift
│   │   ├── Models/
│   │   │   └── ListItem.swift
│   │   ├── Navigation/
│   │   │   └── AppCoordinator.swift
│   │   └── Services/
│   │       └── NetworkService.swift
│   ├── Data/
│   │   ├── DataSources/
│   │   │   ├── PokemonDataSource.swift
│   │   │   └── UserDefaultsDataSource.swift
│   │   ├── DTO/
│   │   │   └── PokemonDTO.swift
│   │   └── Repositories/
│   │       └── PokemonRepositoryImpl.swift
│   ├── Domain/
│   │   ├── Entities/
│   │   │   └── Pokemon.swift
│   │   ├── Repositories/
│   │   │   └── PokemonRepository.swift
│   │   └── UseCases/
│   │       ├── GetPokemonDetailUseCase.swift
│   │       └── GetPokemonListUseCase.swift
│   ├── Modules/
│   │   ├── Home/
│   │   │   ├── DI/
│   │   │   │   └── HomeDIContainer.swift
│   │   │   ├── Navigation/
│   │   │   │   └── HomeCoordinator.swift
│   │   │   └── Presentation/
│   │   │       ├── HomeDetail/
│   │   │       │   ├── HomeDetailViewController.swift
│   │   │       │   └── HomeDetailViewModel.swift
│   │   │       └── HomeMain/
│   │   │           ├── HomeViewController.swift
│   │   │           └── HomeViewModel.swift
│   │   ├── List/
│   │   │   ├── DI/
│   │   │   │   └── ListDIContainer.swift
│   │   │   ├── Navigation/
│   │   │   │   └── ListCoordinator.swift
│   │   │   └── Presentation/
│   │   │       ├── ViewModels/
│   │   │       │   └── ListViewModel.swift
│   │   │       └── Views/
│   │   │           ├── ListModalViewController.swift
│   │   │           └── ListViewController.swift
│   │   ├── Loading/
│   │   │   ├── DI/
│   │   │   │   └── LoadingDIContainer.swift
│   │   │   ├── Navigation/
│   │   │   │   └── LoadingCoordinator.swift
│   │   │   └── Presentation/
│   │   │       ├── LoadingViewController.swift
│   │   │       └── LoadingViewModel.swift
│   │   ├── Main/
│   │   │   ├── DI/
│   │   │   │   └── MainDIContainer.swift
│   │   │   ├── Navigation/
│   │   │   │   └── MainCoordinator.swift
│   │   │   └── MainTabBarController.swift
│   │   └── Settings/
│   │       ├── DI/
│   │       │   └── SettingsDIContainer.swift
│   │       ├── Navigation/
│   │       │   └── SettingsCoordinator.swift
│   │       └── Presentation/
│   │           ├── About/
│   │           │   └── AboutViewController.swift
│   │           ├── Localization Test/
│   │           │   └── LocalizationTestViewController.swift
│   │           └── Settings Main/
│   │               ├── SettingsViewController.swift
│   │               └── SettingsViewModel.swift
│   ├── Resource/
│   │   └── Localization/
│   └── Info.plist
├── BaseStructoriOSUIKit.xcodeproj/
├── BaseStructoriOSUIKitTests/
│   ├── BaseStructoriOSUIKitTests.swift
│   ├── HomeDetailViewModelTests.swift
│   ├── HomeViewModelTests.swift
│   └── ListViewModelTests.swift
├── BaseStructoriOSUIKitUITests/
│   ├── BaseStructoriOSUIKitUITests.swift
│   └── BaseStructoriOSUIKitUITestsLaunchTests.swift
└── Tests/
    └── BaseStructoriOSUIKitTests/
        └── BaseStructoriOSUIKitTests.swift
```

## 4. สภาพแวดล้อม (Environments)

- Debug
- Dev
- PreProd
- Release
- UAT

## 5. การตั้งค่า Build

- Product Module Name: BaseStructorDGA
- Product Name: BaseStructorDGA
- ทุกสภาพแวดล้อมใช้ชื่อ module และ product name เดียวกัน

## 6. ระบบนำทางและ Flow

- แอปเริ่มต้นด้วย AppCoordinator
- แสดง LoadingCoordinator (ใช้ closure/callback ไม่ใช้ delegate)
- หลังโหลดเสร็จ แสดง MainCoordinator (TabBar: Home, List, Settings)
- MainCoordinator จัดการ sign out โดยย้อนกลับไป LoadingCoordinator

## 7. มาตรฐานการเขียนโค้ดและ Architecture Patterns

### 7.1 MVVM-C Pattern
- ใช้ UIKit เท่านั้น (ไม่ใช้ SwiftUI)
- MVVM-C pattern สำหรับทุกโมดูล
- ทุก service และ module ต้อง Inject ผ่าน DIContainer
- ห้ามมี business logic ใน ViewController
- การนำทางทั้งหมดต้องผ่าน Coordinator
- ห้ามใช้ global singleton ยกเว้น DIContainer

### 7.2 Base Classes
- **BaseViewController<VM: ObservableObject>**: Base class สำหรับ ViewController
- **BaseCoordinator**: Base class สำหรับ Coordinator พร้อม child coordinator management
- Protocol **NavigationConfigurable**: สำหรับ navigation configuration

### 7.3 DI Container Pattern
- **AppDIContainer**: Composition root สำหรับ global services
- **ModuleDIContainer**: แต่ละโมดูลมี DI Container ของตัวเอง
- Factory protocols แยกสำหรับ ViewModels, ViewControllers และ Coordinators
- Lazy initialization สำหรับทุก dependencies

### 7.4 Navigation System
- **NavigationManager**: จัดการ navigation styles และ appearance
- **NavigationConfiguration**: Configuration object สำหรับ navigation
- **NavigationBuilder**: Builder pattern สำหรับสร้าง navigation config
- Support navigation styles: default, transparent, colored, gradient, hidden, custom

### 7.5 Data Flow (Clean Architecture)
```text
UI Layer → ViewModel → UseCase → Repository → DataSource → Network/Local
```

- **Entities**: Domain models (Pokemon, PokemonList, PokemonType, etc.)
- **Use Cases**: Business logic (GetPokemonListUseCase, GetPokemonDetailUseCase)
- **Repository Protocol**: Abstract data access (PokemonRepositoryProtocol)
- **Repository Implementation**: Concrete data access (PokemonRepositoryImpl)
- **Data Sources**: Remote/Local data sources (PokemonRemoteDataSource)
- **DTOs**: Data transfer objects (PokemonDetailDTO, PokemonListResponseDTO)

### 7.6 Network Layer
- **NetworkService**: HTTP client with async/await
- **SessionManager**: Authentication and session management
- Support HTTP methods: GET, POST, PUT, DELETE
- Error handling และ response parsing

### 7.7 Extensions และ Utilities
- **String+Extensions**: Localization, validation, formatting
- **UIView+Extensions**: Auto layout helpers, animations, styling
- **UIViewController+Extensions**: Alert helpers, loading, navigation
- **Kingfisher+Extensions**: Pokemon image loading utilities

## 8. โมดูลและ Components

### 8.1 Application Layer
- **AppDelegate**: App lifecycle management
- **SceneDelegate**: Scene lifecycle management

### 8.2 Core Layer
- **Base/**: BaseViewController, BaseCoordinator
- **DI/**: AppDIContainer และ protocols
- **Extensions/**: ทุก extension files
- **Managers/**: NavigationManager, SessionManager, UserManager
- **Models/**: Shared models (ListItem)
- **Navigation/**: AppCoordinator
- **Services/**: NetworkService

### 8.3 Data Layer
- **DataSources/**: PokemonDataSource, UserDefaultsDataSource
- **DTO/**: PokemonDTO และ data transfer objects
- **Repositories/**: Repository implementations

### 8.4 Domain Layer
- **Entities/**: Domain models (Pokemon)
- **Repositories/**: Repository protocols
- **UseCases/**: Business logic use cases

### 8.5 Modules Layer
แต่ละโมดูลมีโครงสร้าง:
```text
ModuleName/
├── DI/
│   └── ModuleNameDIContainer.swift
├── Navigation/
│   └── ModuleNameCoordinator.swift
└── Presentation/
    ├── Views/
    │   └── ModuleNameViewController.swift
    └── ViewModels/
        └── ModuleNameViewModel.swift
```

#### 8.5.1 Loading Module
- **LoadingCoordinator**: จัดการ loading flow
- **LoadingViewController**: แสดง loading screen
- **LoadingViewModel**: Loading logic
- **LoadingDIContainer**: Dependencies สำหรับ loading

#### 8.5.2 Main Module  
- **MainCoordinator**: จัดการ TabBar และ main flow
- **MainTabBarController**: TabBar controller
- **MainDIContainer**: จัดการ module containers

#### 8.5.3 Home Module
- **HomeCoordinator**: Navigation สำหรับ home flow
- **HomeViewController**: Pokemon list screen
- **HomeDetailViewController**: Pokemon detail screen
- **HomeViewModel**: Home business logic
- **HomeDetailViewModel**: Detail business logic
- **HomeDIContainer**: Dependencies สำหรับ home

#### 8.5.4 List Module
- **ListCoordinator**: Navigation สำหรับ list flow
- **ListViewController**: List interface screen
- **ListModalViewController**: Modal presentations
- **ListViewModel**: List business logic
- **ListDIContainer**: Dependencies สำหรับ list

#### 8.5.5 Settings Module
- **SettingsCoordinator**: Navigation สำหรับ settings flow
- **SettingsViewController**: Settings main screen
- **LocalizationTestViewController**: Localization testing
- **AboutViewController**: About screen
- **SettingsViewModel**: Settings business logic
- **SettingsDIContainer**: Dependencies สำหรับ settings

## 9. Testing Strategy
- **Unit Tests**: ViewModel testing with mocked dependencies
- **Mock Classes**: สำหรับ Use Cases, Repositories, Managers
- **Test Structure**: แยก test files ตาม modules
- **Naming Convention**: Test method names แบบ descriptive

## 10. Code Templates และ Standards

### 10.1 ViewModel Template
```swift
class YourModuleViewModel: ObservableObject {
    // MARK: - Services
    private let yourService: YourServiceProtocol
    
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: - Initialization
    init(yourService: YourServiceProtocol) {
        self.yourService = yourService
    }
    
    // MARK: - Public Methods
    @MainActor
    func loadData() async {
        // Implementation
    }
}
```

### 10.2 ViewController Template
```swift
class YourModuleViewController: BaseViewController<YourModuleViewModel>, NavigationConfigurable {
    // MARK: - Properties
    weak var coordinator: YourModuleCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Navigation Configuration
    var navigationConfiguration: NavigationConfiguration {
        return NavigationBuilder()
            .title("Your Title")
            .style(.default)
            .build()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}
```

### 10.3 Coordinator Template
```swift
class YourModuleCoordinator: BaseCoordinator {
    private let container: YourModuleDIContainer
    
    init(navigationController: UINavigationController, container: YourModuleDIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let viewController = container.makeYourModuleViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
```

### 10.4 DI Container Template
```swift
// MARK: - Factory Protocols
protocol YourModuleFactoryProtocol {
    func makeYourModuleViewModel() -> YourModuleViewModel
    func makeYourModuleViewController() -> YourModuleViewController
}

protocol YourModuleCoordinatorFactory {
    func makeYourModuleFlowCoordinator(navigationController: UINavigationController) -> YourModuleCoordinator
}

// MARK: - DI Container
class YourModuleDIContainer {
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
}

// MARK: - Factory Extensions
extension YourModuleDIContainer: YourModuleCoordinatorFactory {
    func makeYourModuleFlowCoordinator(navigationController: UINavigationController) -> YourModuleCoordinator {
        return YourModuleCoordinator(navigationController: navigationController, container: self)
    }
}

extension YourModuleDIContainer: YourModuleFactoryProtocol {
    func makeYourModuleViewModel() -> YourModuleViewModel {
        return YourModuleViewModel(
            yourService: appDIContainer.makeYourService()
        )
    }
    
    func makeYourModuleViewController() -> YourModuleViewController {
        let viewModel = makeYourModuleViewModel()
        return YourModuleViewController(viewModel: viewModel)
    }
}
```

## 11. Localization & Assets

- ใช้ Assets.xcassets สำหรับรูปภาพ สี และไอคอน
- String localization ผ่าน String+Extensions
- Support Thai และ English languages
- Localization testing ใน LocalizationTestViewController

## 12. Dependencies และ Third-party Libraries

- **Kingfisher**: Image loading และ caching
- **Combine**: Reactive programming framework
- **Foundation**: Core iOS framework
- **UIKit**: UI framework (ไม่ใช้ SwiftUI)

## 13. Build Configuration

- Product Module Name: BaseStructorDGA
- Product Name: BaseStructorDGA
- ทุกสภาพแวดล้อมใช้ชื่อ module และ product name เดียวกัน
- Support iOS 13.0+

## 14. Application Flow

```text
AppDelegate → SceneDelegate → AppCoordinator
    ↓
LoadingCoordinator (แสดง loading screen)
    ↓ (หลังโหลดเสร็จ)
MainCoordinator → MainTabBarController
    ├── HomeTab (HomeCoordinator)
    ├── ListTab (ListCoordinator)  
    └── SettingsTab (SettingsCoordinator)
```

### 14.1 Navigation Flow
- แอปเริ่มต้นด้วย AppCoordinator
- แสดง LoadingCoordinator (ใช้ closure/callback ไม่ใช้ delegate)
- หลังโหลดเสร็จ แสดง MainCoordinator (TabBar: Home, List, Settings)
- MainCoordinator จัดการ sign out โดยย้อนกลับไป LoadingCoordinator
- แต่ละ tab มี Coordinator ของตัวเองที่จัดการ navigation ภายใน module

### 14.2 Example Pokemon API Integration
- Pokemon List API: `/pokemon?limit={limit}&offset={offset}`
- Pokemon Detail API: `/pokemon/{id}` หรือ `/pokemon/{name}`
- Image URLs: `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/{id}.png`

## 15. ขอบเขตที่ไม่รวม (Out of Scope)

- ห้ามเพิ่มฟีเจอร์ โมดูล หรือไลบรารีใด ๆ ที่นอกเหนือจากที่มีในโปรเจกต์นี้
- ไม่ใช้ SwiftUI, Combine หรือ third-party framework ใด ๆ เว้นแต่มีอยู่แล้ว
- ไม่มี local database หรือ Core Data
- ไม่มี authentication flow (ใช้ mock token)
- ไม่มี push notifications
- ไม่มี background processing

## 16. Key Implementation Notes

### 16.1 Coordinator Pattern
- ทุก Coordinator สืบทอดมาจาก BaseCoordinator
- Support child coordinator management
- Memory management ด้วย weak references
- Navigation ผ่าน NavigationController

### 16.2 Dependency Injection
- AppDIContainer เป็น singleton composition root
- แต่ละ module มี DIContainer ของตัวเอง
- Factory protocols แยกออกจาก implementation
- Lazy initialization ป้องกัน retain cycles

### 16.3 Error Handling
- Network errors ผ่าน async/await throws
- UI error display ผ่าน alerts
- Graceful fallbacks สำหรับ image loading
- Loading states ใน ViewModels

### 16.4 Memory Management
- Weak references สำหรับ coordinators
- AnyCancellable sets สำหรับ Combine subscriptions
- Proper cleanup ใน deinit methods
- Avoid retain cycles ใน closures

---

> **เอกสารนี้เป็นแหล่งข้อมูลหลักสำหรับ AI agent ในการสร้าง ดูแล หรือขยายโครงสร้างและโค้ดของโปรเจกต์นี้ ห้ามเพิ่มหรือลดฟีเจอร์ใด ๆ ที่นอกเหนือจากที่ระบุไว้ในเอกสารนี้**
