# Module Structure Template
## สำหรับการสร้าง Module ใหม่ในระบบ MVVM-C

---

## 📁 โครงสร้าง Folder ที่ต้องมี (Mandatory)

```
ModuleName/
├── DI/                          # ✅ ต้องมีเสมอ
│   └── ModuleNameDIContainer.swift
├── Navigation/                  # ✅ ต้องมีเสมอ  
│   └── ModuleNameCoordinator.swift
└── Presentation/                # ✅ ต้องมีเสมอ
    ├── ViewModels/
    │   └── ModuleNameViewModel.swift
    └── Views/
        └── ModuleNameViewController.swift
```

---

## 🏗️ DI Container Template (Standardized)

### 1. **Factory Protocols**
```swift
// MARK: - [ModuleName] Factory Protocol
protocol [ModuleName]FactoryProtocol {
    func make[ModuleName]ViewModel() -> [ModuleName]ViewModel
    func make[ModuleName]ViewController() -> [ModuleName]ViewController
    // เพิ่ม methods อื่น ๆ ตามความต้องการของ module
}

protocol [ModuleName]CoordinatorFactory {
    func make[ModuleName]FlowCoordinator(navigationController: UINavigationController) -> [ModuleName]Coordinator
}
```

### 2. **DI Container Class**
```swift
// MARK: - [ModuleName] DI Container
class [ModuleName]DIContainer {
    
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    // MARK: - Dependencies (ถ้ามี)
    // private lazy var someRepository: SomeRepositoryProtocol = ...
    // private lazy var someUseCase: SomeUseCaseProtocol = ...
}
```

### 3. **Factory Extensions**
```swift
// MARK: - Coordinator Factory
extension [ModuleName]DIContainer: [ModuleName]CoordinatorFactory {
    func make[ModuleName]FlowCoordinator(navigationController: UINavigationController) -> [ModuleName]Coordinator {
        return [ModuleName]Coordinator(navigationController: navigationController, container: self)
    }
}

// MARK: - Factory Implementation
extension [ModuleName]DIContainer: [ModuleName]FactoryProtocol {
    
    func make[ModuleName]ViewModel() -> [ModuleName]ViewModel {
        return [ModuleName]ViewModel(
            userManager: appDIContainer.makeUserManager()
            // เพิ่ม dependencies อื่น ๆ ที่ต้องการ
        )
    }
    
    func make[ModuleName]ViewController() -> [ModuleName]ViewController {
        let viewModel = make[ModuleName]ViewModel()
        return [ModuleName]ViewController(viewModel: viewModel)
    }
}
```

---

## 🧩 Integration ใน MainDIContainer

### 1. **เพิ่มใน MainModuleContainerFactory**
```swift
protocol MainModuleContainerFactory {
    // ... existing methods ...
    func make[ModuleName]DIContainer() -> [ModuleName]DIContainer
}
```

### 2. **เพิ่มใน MainDIContainer**
```swift
class MainDIContainer {
    // ... existing properties ...
    private lazy var [moduleName]DIContainer: [ModuleName]DIContainer = [ModuleName]DIContainer(appDIContainer: appDIContainer)
    
    // ... existing methods ...
    func make[ModuleName]DIContainer() -> [ModuleName]DIContainer {
        return [moduleName]DIContainer
    }
}
```

---

## ✅ Checklist การสร้าง Module ใหม่

### Phase 1: Structure Setup
- [ ] สร้าง folder structure: `ModuleName/DI/`, `ModuleName/Navigation/`, `ModuleName/Presentation/`
- [ ] สร้างไฟล์ `ModuleNameDIContainer.swift`
- [ ] สร้างไฟล์ `ModuleNameCoordinator.swift`  
- [ ] สร้างไฟล์ `ModuleNameViewModel.swift`
- [ ] สร้างไฟล์ `ModuleNameViewController.swift`

### Phase 2: DI Container Implementation
- [ ] สร้าง Factory Protocols (แยก FactoryProtocol และ CoordinatorFactory)
- [ ] สร้าง DI Container class
- [ ] Implement Factory Extensions
- [ ] เพิ่ม dependencies ที่จำเป็น (repositories, use cases)

### Phase 3: Integration
- [ ] เพิ่ม module ใน MainModuleContainerFactory protocol
- [ ] เพิ่ม lazy property ใน MainDIContainer
- [ ] เพิ่ม factory method ใน MainDIContainer extension

### Phase 4: Testing
- [ ] ทดสอบการสร้าง coordinator ผ่าน DI
- [ ] ทดสอบการสร้าง view controller ผ่าน DI
- [ ] ทดสอบ navigation flow
- [ ] ตรวจสอบ memory management

---

## 🎯 Best Practices

### ✅ DO:
- แยก Factory Protocols ชัดเจน (FactoryProtocol แยกจาก CoordinatorFactory)
- ใช้ lazy properties สำหรับ dependencies
- Inject AppDIContainer ผ่าน constructor
- ใช้ protocol types แทน concrete types
- สร้าง dependencies ใน DI Container

### ❌ DON'T:
- สร้าง dependencies โดยตรงใน ViewController หรือ ViewModel
- ใช้ global singletons
- ข้าม DI Container ในการสร้าง objects
- ใส่ business logic ใน DI Container
- สร้าง circular dependencies

---

## 🔧 Migration Guide (สำหรับ module เก่า)

ถ้ามี module เก่าที่ไม่ตรงกับ standard:

1. **เพิ่ม CoordinatorFactory Protocol** (ถ้ายังไม่มี)
2. **แยก Factory methods เป็น Extensions**
3. **เพิ่ม DI folder** (ถ้ายังไม่มี)
4. **ปรับปรุง constructor** ให้รับ DI Container
5. **อัปเดต parent coordinator** ให้ใช้ DI Container

นี่คือมาตรฐานใหม่ที่ทุก module ควรทำตาม!
