//
//  HomeViewModelTests.swift
//  BaseStructoriOSUIKitTests
//
//  Created by sahapap on 2/9/2568 BE.
//

import XCTest
import Combine
@testable import BaseStructoriOSUIKit

class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    var mockuserManager: MockUserManager!
    var mockGetPokemonListUseCase: MockGetPokemonListUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockuserManager = MockUserManager()
        mockGetPokemonListUseCase = MockGetPokemonListUseCase()
        sut = HomeViewModel(
            userManager: mockuserManager,
            getPokemonListUseCase: mockGetPokemonListUseCase
        )
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        mockuserManager = nil
        mockGetPokemonListUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        // Assert
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.pokemonList.isEmpty)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.showError)
        XCTAssertTrue(sut.hasMoreData)
    }
    
    // MARK: - LoadInitialData Tests
    
    func testLoadInitialData_ShouldUpdateLoadingState() {
        // Arrange
        mockGetPokemonListUseCase.mockResult = .success(
            PokemonList(
                count: 2,
                next: nil,
                previous: nil,
                results: [
                    PokemonListItem(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
                    PokemonListItem(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/")
                ]
            )
        )
        
        let expectation = XCTestExpectation(description: "Loading state should be updated")
        
        // Act
        sut.$isLoading
            .dropFirst() // Skip initial value
            .sink { isLoading in
                if isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadInitialData()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadInitialData_Success_ShouldUpdatePokemonList() {
        // Arrange
        let expectedPokemon = [
            PokemonListItem(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            PokemonListItem(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/")
        ]
        
        mockGetPokemonListUseCase.mockResult = .success(
            PokemonList(
                count: 2,
                next: nil,
                previous: nil,
                results: expectedPokemon
            )
        )
        
        let expectation = XCTestExpectation(description: "Pokemon list should be updated")
        
        // Act
        sut.$pokemonList
            .dropFirst() // Skip initial empty array
            .sink { pokemonList in
                if !pokemonList.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadInitialData()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.pokemonList.count, 2)
        XCTAssertEqual(sut.pokemonList[0].name, "pikachu")
        XCTAssertEqual(sut.pokemonList[1].name, "charmander")
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLoadInitialData_Failure_ShouldShowError() {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockGetPokemonListUseCase.mockResult = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Error should be shown")
        
        // Act
        sut.$showError
            .dropFirst() // Skip initial false value
            .sink { showError in
                if showError {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadInitialData()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(sut.errorMessage, "Network error")
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - RefreshData Tests
    
    func testRefreshData_ShouldResetStateAndReload() {
        // Arrange
        sut.pokemonList = [
            PokemonListItem(name: "old", url: "https://pokeapi.co/api/v2/pokemon/1/")
        ]
        
        mockGetPokemonListUseCase.mockResult = .success(
            PokemonList(
                count: 1,
                next: nil,
                previous: nil,
                results: [
                    PokemonListItem(name: "new", url: "https://pokeapi.co/api/v2/pokemon/2/")
                ]
            )
        )
        
        let expectation = XCTestExpectation(description: "Data should be refreshed")
        
        // Act
        sut.$pokemonList
            .dropFirst() // Skip initial state
            .sink { pokemonList in
                if pokemonList.count == 1 && pokemonList[0].name == "new" {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.refreshData()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.pokemonList.count, 1)
        XCTAssertEqual(sut.pokemonList[0].name, "new")
    }
    
    // MARK: - LoadMoreData Tests
    
    func testLoadMoreData_WhenHasMoreData_ShouldAppendToPokemonList() {
        // Arrange
        sut.pokemonList = [
            PokemonListItem(name: "existing", url: "https://pokeapi.co/api/v2/pokemon/1/")
        ]
        sut.hasMoreData = true
        
        mockGetPokemonListUseCase.mockResult = .success(
            PokemonList(
                count: 2,
                next: nil,
                previous: nil,
                results: [
                    PokemonListItem(name: "new", url: "https://pokeapi.co/api/v2/pokemon/2/")
                ]
            )
        )
        
        let expectation = XCTestExpectation(description: "More data should be appended")
        
        // Act
        sut.$pokemonList
            .dropFirst() // Skip initial state
            .sink { pokemonList in
                if pokemonList.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadMoreData()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.pokemonList.count, 2)
        XCTAssertEqual(sut.pokemonList[0].name, "existing")
        XCTAssertEqual(sut.pokemonList[1].name, "new")
    }
    
    func testLoadMoreData_WhenNoMoreData_ShouldNotLoad() {
        // Arrange
        sut.hasMoreData = false
        
        // Act
        sut.loadMoreData()
        
        // Assert
        XCTAssertFalse(mockGetPokemonListUseCase.executeWasCalled)
    }
}

// MARK: - Mock Classes

class MockUserManager: UserManagerProtocol {

    func updatecurrentUser(_ userData: UserData) {}

    func getUserData() -> UserData? {
        return.init(id: "", username: "", email: "", fullName: "", profileImageURL: "")
    }
}

class MockGetPokemonListUseCase: GetPokemonListUseCaseProtocol {
    var mockResult: Result<PokemonList, Error>!
    var executeWasCalled = false
    
    func execute(limit: Int, offset: Int) async throws -> PokemonList {
        executeWasCalled = true
        
        switch mockResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        case .none:
            throw NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock not configured"])
        }
    }
}
