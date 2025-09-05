# BaseStructoriOSUIKit - Architecture Overview
## Visual Guide for Development Team

---

## 🏗️ Application Architecture Layers

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              PRESENTATION LAYER                            │
├─────────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐              │
│ │   Coordinator   │  │ ViewController  │  │   ViewModel     │              │
│ │                 │  │                 │  │                 │              │
│ │ • Navigation    │  │ • UI Logic      │  │ • Business      │              │
│ │ • Flow Control  │  │ • User Input    │  │   Logic         │              │
│ │                 │  │ • View Updates  │  │ • Data Binding  │              │
│ └─────────────────┘  └─────────────────┘  └─────────────────┘              │
└─────────────────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────────────────┐
│                               DOMAIN LAYER                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐              │
│ │    Use Cases    │  │   Entities      │  │  Repositories   │              │
│ │                 │  │                 │  │   (Protocols)   │              │
│ │ • GetUser       │  │ • User          │  │ • User          │              │
│ │   DetailUsecase │  │   DetailUsecase │  │   Repository    │              │
│ │                 │  │                 │  │                 │              │
│ │                 │  │                 │  │                 │              │
│ └─────────────────┘  └─────────────────┘  └─────────────────┘              │
└─────────────────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────────────────┐
│                                DATA LAYER                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐              │
│ │  Repositories   │  │  Data Sources   │  │      DTOs       │              │
│ │(Implementation) │  │                 │  │                 │              │
│ │ • User Repo Imp │  │  • Remote API   │  │ • UserDTO       │              │
│ │                 │  │  • Local Cache  │  │                 │              │
│ │ • Local Cache   │  │  • UserDefaults │  │                 │              │
│ │                 │  │                 │  │                 │              │
│ │                 │  │                 │  │                 │              │
│ └─────────────────┘  └─────────────────┘  └─────────────────┘              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔄 MVVM-C Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              USER INTERACTION                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                             VIEW CONTROLLER                                │
├─────────────────────────────────────────────────────────────────────────────┤
│ • Handles UI Events                                                         │
│ • Updates UI Based on ViewModel                                             │
│ • NO Business Logic                                                         │
└─────────────────────────────────────────────────────────────────────────────┘
                         │                              ▲
                         │ User Action                  │ UI Update
                         ▼                              │
┌─────────────────────────────────────────────────────────────────────────────┐
│                               VIEW MODEL                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│ • Business Logic                                                            │
│ • Data Transformation                                                       │
│ • State Management                                                          │
│ • Uses Use Cases                                                            │
└─────────────────────────────────────────────────────────────────────────────┘
                         │                              ▲
                         │ Data Request                 │ Data Response
                         ▼                              │
┌─────────────────────────────────────────────────────────────────────────────┐
│                              USE CASES                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│ • Single Responsibility                                                     │
│ • Business Rules                                                            │
│ • Uses Repositories                                                         │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                              COORDINATOR                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│ • Navigation Logic                                    ┌─────────────────────┐│
│ • Screen Transitions                ◄─────────────────┤ Navigation Request  ││
│ • Flow Management                                     └─────────────────────┘│
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🏗️ Module Structure Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                               MODULE NAME                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│ ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐              │
│ │       DI        │  │   Navigation    │  │  Presentation   │              │
│ │                 │  │                 │  │                 │              │
│ │ ┌─────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │              │
│ │ │   Factory   │ │  │ │ Coordinator │ │  │ │ViewModels   │ │              │
│ │ │  Protocol   │ │  │ │             │ │  │ │             │ │              │
│ │ └─────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │              │
│ │                 │  │                 │  │                 │              │
│ │ ┌─────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │              │
│ │ │DIContainer  │ │  │ │ Navigation  │ │  │ │ViewCont.    │ │              │
│ │ │             │ │  │ │   Logic     │ │  │ │             │ │              │
│ │ └─────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │              │
│ └─────────────────┘  └─────────────────┘  └─────────────────┘              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Navigation Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              APP COORDINATOR                               │
├─────────────────────────────────────────────────────────────────────────────┤
│ • App Lifecycle Management                                                  │
│ • Root Navigation                                                           │
│ • Session Management                                                        │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           LOADING COORDINATOR                              │
├─────────────────────────────────────────────────────────────────────────────┤
│ • Initial App Loading                                                       │
│ • Splash Screen                                                             │
│ • Data Initialization                                                       │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            MAIN COORDINATOR                                │
├─────────────────────────────────────────────────────────────────────────────┤
│ • TabBar Management                                                         │
│ • Tab Coordination                                                          │
│ • Sign Out Handling                                                         │
└─────────────────────────────────────────────────────────────────────────────┘
               │                       │                       │
               ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│      HOME       │    │      LIST       │    │   SETTINGS      │
│   COORDINATOR   │    │   COORDINATOR   │    │   COORDINATOR   │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Pokemon List  │    │ • List Items    │    │ • User Profile  │
│ • Pokemon Detail│    │ • Modal Pres.   │    │ • App Settings  │
│ • Navigation    │    │ • Action Sheets │    │ • Sign Out      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

## 💉 Dependency Injection Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              APP DI CONTAINER                              │
├─────────────────────────────────────────────────────────────────────────────┤
│ • Global Services (NetworkService, UserManager, SessionManager)            │
│ • App-level Dependencies                                                    │
│ • Module DI Container Factories                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                         │                │                │
                         ▼                ▼                ▼
    ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
    │     HOME DI     │     │     LIST DI     │     │   SETTINGS DI   │
    │   CONTAINER     │     │   CONTAINER     │     │   CONTAINER     │
    ├─────────────────┤     ├─────────────────┤     ├─────────────────┤
    │ • Home Services │     │ • List Services │     │ • Settings      │
    │ • Pokemon Use   │     │ • List Use      │     │   Services      │
    │   Cases         │     │   Cases         │     │ • User Use      │
    │ • Repositories  │     │ • View Models   │     │   Cases         │
    │ • View Models   │     │ • Controllers   │     │ • View Models   │
    │ • Controllers   │     │ • Coordinators  │     │ • Controllers   │
    │ • Coordinators  │     │                 │     │ • Coordinators  │
    └─────────────────┘     └─────────────────┘     └─────────────────┘
```

---

## 🧩 Component Dependencies

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                             VIEW CONTROLLER                                │
├─────────────────────────────────────────────────────────────────────────────┤
│ Depends on:                                                                 │
│ • ViewModel (Strong Reference)                                              │
│ • Coordinator (Weak Reference)                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                      ▲
                                      │
┌─────────────────────────────────────────────────────────────────────────────┐
│                               VIEW MODEL                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│ Depends on:                                                                 │
│ • Use Cases (Protocol References)                                           │
│ • Services (Protocol References)                                            │
│ • NO UI Dependencies                                                        │
└─────────────────────────────────────────────────────────────────────────────┘
                                      ▲
                                      │
┌─────────────────────────────────────────────────────────────────────────────┐
│                               USE CASES                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│ Depends on:                                                                 │
│ • Repository Protocols                                                      │
│ • Domain Entities                                                           │
│ • NO Framework Dependencies                                                 │
└─────────────────────────────────────────────────────────────────────────────┘
                                      ▲
                                      │
┌─────────────────────────────────────────────────────────────────────────────┐
│                              REPOSITORIES                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│ Depends on:                                                                 │
│ • Data Sources (Protocol References)                                        │
│ • DTOs for Data Mapping                                                     │
│ • Domain Entities                                                           │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Data Flow Example

```
USER TAPS BUTTON
       │
       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                   HomeViewController.buttonTapped()                        │
├─────────────────────────────────────────────────────────────────────────────┤
│ coordinator?.showDetail(pokemonId: id)                                      │
└─────────────────────────────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                   HomeCoordinator.showDetail()                             │
├─────────────────────────────────────────────────────────────────────────────┤
│ let detailVC = container.makeHomeDetailViewController(pokemonId: id)        │
│ navigationController.pushViewController(detailVC, animated: true)           │
└─────────────────────────────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│               HomeDetailViewController.viewDidLoad()                       │
├─────────────────────────────────────────────────────────────────────────────┤
│ viewModel.loadPokemonDetail()                                               │
└─────────────────────────────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│               HomeDetailViewModel.loadPokemonDetail()                      │
├─────────────────────────────────────────────────────────────────────────────┤
│ let pokemon = try await getPokemonDetailUseCase.execute(id: pokemonId)      │
│ @Published var pokemon: Pokemon? → UI Updates                               │
└─────────────────────────────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│            GetPokemonDetailUseCase.execute()                               │
├─────────────────────────────────────────────────────────────────────────────┤
│ return try await repository.getPokemonDetail(id: id)                       │
└─────────────────────────────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│            PokemonRepositoryImpl.getPokemonDetail()                        │
├─────────────────────────────────────────────────────────────────────────────┤
│ let dto = try await remoteDataSource.fetchPokemonDetail(id: id)             │
│ return dto.toDomainEntity()                                                 │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🏭 Factory Pattern Usage

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              DI CONTAINER                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│ func makeHomeViewController() -> HomeViewController {                       │
│     let viewModel = makeHomeViewModel()                    ┌──────────────┐ │
│     return HomeViewController(viewModel: viewModel) ──────►│ ViewController│ │
│ }                                                          └──────────────┘ │
│                                                                    │         │
│ func makeHomeViewModel() -> HomeViewModel {                        │         │
│     return HomeViewModel(                              ┌──────────────┐     │
│         userManager: makeUserManager(),               │              │     │
│         getPokemonListUseCase: makeGetPokemon...  ────┤   ViewModel  │     │
│     )                                                 │              │     │
│ }                                                     └──────────────┘     │
│                                                                │             │
│ func makeHomeCoordinator(...) -> HomeCoordinator {             │             │
│     return HomeCoordinator(                         ┌──────────────┐       │
│         navigationController: navController,        │              │       │
│         container: self                        ─────┤  Coordinator │       │
│     )                                               │              │       │
│ }                                                   └──────────────┘       │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 📱 Screen Lifecycle

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           SCREEN CREATION                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│ 1. Coordinator creates ViewController via DI Container                     │
│ 2. DI Container creates ViewModel with dependencies                        │
│ 3. ViewController receives ViewModel in initializer                        │
│ 4. Coordinator sets itself as weak reference in ViewController             │
│ 5. ViewController calls viewDidLoad()                                       │
│ 6. ViewController binds to ViewModel @Published properties                  │
│ 7. ViewModel loads initial data                                             │
│ 8. UI updates automatically via Combine bindings                           │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           SCREEN DESTRUCTION                               │
├─────────────────────────────────────────────────────────────────────────────┤
│ 1. User navigates away or closes screen                                    │
│ 2. ViewController gets deallocated                                          │
│ 3. ViewModel gets deallocated (if no other references)                     │
│ 4. Coordinator removes itself from parent's childCoordinators              │
│ 5. Coordinator gets deallocated                                             │
│ 6. All cancellables get automatically cancelled                            │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Key Architecture Benefits

### ✅ Separation of Concerns
- **View**: Only UI and user interaction
- **ViewModel**: Business logic and data transformation  
- **Coordinator**: Navigation and flow control
- **Use Cases**: Single-responsibility business operations

### ✅ Testability
- **ViewModels**: Pure logic, easy to unit test
- **Use Cases**: Isolated business rules testing
- **Repositories**: Data layer testing with mocks
- **Coordinators**: Navigation flow testing

### ✅ Scalability
- **Modular Structure**: Each feature is self-contained
- **Dependency Injection**: Easy to swap implementations
- **Protocol-based**: Flexible and extensible architecture
- **Clean Dependencies**: Clear separation between layers

### ✅ Maintainability
- **Single Responsibility**: Each class has one job
- **Predictable Patterns**: Consistent structure across modules
- **Memory Safety**: Proper weak reference management
- **Error Handling**: Centralized error management

---

This visual guide provides a comprehensive overview of the BaseStructoriOSUIKit architecture. Use it as a reference when implementing new features or modules.
