//
//  HomeDetailViewModelTests.swift
//  BaseStructoriOSUIKitTests
//
//  Created by sahapap on 2/9/2568 BE.
//

import XCTest
import Combine
@testable import BaseStructoriOSUIKit

class HomeDetailViewModelTests: XCTestCase {
    
    var sut: HomeDetailViewModel!
    var mockGetPokemonDetailUseCase: MockGetPokemonDetailUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockGetPokemonDetailUseCase = MockGetPokemonDetailUseCase()
        sut = HomeDetailViewModel(
            pokemonId: 25,
            getPokemonDetailUseCase: mockGetPokemonDetailUseCase
        )
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        mockGetPokemonDetailUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        // Assert
        XCTAssertEqual(sut.pokemonId, 25)
        XCTAssertNil(sut.pokemon)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.showError)
        XCTAssertEqual(sut.pokemonName, "Unknown Pokemon")
        XCTAssertNil(sut.pokemonImageURL)
    }
    
    // MARK: - LoadPokemonDetail Tests
    
    func testLoadPokemonDetail_ShouldUpdateLoadingState() {
        // Arrange
        let mockPokemon = createMockPokemon(name: "pikachu")
        mockGetPokemonDetailUseCase.mockResult = .success(mockPokemon)
        
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
        
        sut.loadPokemonDetail()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadPokemonDetail_Success_ShouldUpdatePokemon() {
        // Arrange
        let mockPokemon = createMockPokemon(name: "pikachu")
        mockGetPokemonDetailUseCase.mockResult = .success(mockPokemon)
        
        let expectation = XCTestExpectation(description: "Pokemon should be updated")
        
        // Act
        sut.$pokemon
            .dropFirst() // Skip initial nil
            .sink { pokemon in
                if pokemon != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadPokemonDetail()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(sut.pokemon)
        XCTAssertEqual(sut.pokemon?.name, "pikachu")
        XCTAssertEqual(sut.pokemonName, "Pikachu")
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLoadPokemonDetail_Failure_ShouldShowError() {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Pokemon not found"])
        mockGetPokemonDetailUseCase.mockResult = .failure(expectedError)
        
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
        
        sut.loadPokemonDetail()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(sut.errorMessage, "Pokemon not found")
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - RefreshData Tests
    
    func testRefreshData_ShouldReloadPokemonDetail() {
        // Arrange
        let mockPokemon = createMockPokemon(name: "charmander")
        mockGetPokemonDetailUseCase.mockResult = .success(mockPokemon)
        
        let expectation = XCTestExpectation(description: "Data should be refreshed")
        
        // Act
        sut.$pokemon
            .dropFirst() // Skip initial nil
            .sink { pokemon in
                if pokemon?.name == "charmander" {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.refreshData()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.pokemon?.name, "charmander")
        XCTAssertEqual(sut.pokemonName, "Charmander")
    }
    
    // MARK: - Computed Properties Tests
    
    func testPokemonName_WhenPokemonIsNil_ShouldReturnUnknown() {
        // Arrange
        sut.pokemon = nil
        
        // Act & Assert
        XCTAssertEqual(sut.pokemonName, "Unknown Pokemon")
    }
    
    func testPokemonName_WhenPokemonExists_ShouldReturnCapitalizedName() {
        // Arrange
        sut.pokemon = createMockPokemon(name: "pikachu")
        
        // Act & Assert
        XCTAssertEqual(sut.pokemonName, "Pikachu")
    }
    
    func testPokemonImageURL_WhenPokemonIsNil_ShouldReturnNil() {
        // Arrange
        sut.pokemon = nil
        
        // Act & Assert
        XCTAssertNil(sut.pokemonImageURL)
    }
    
    func testPokemonImageURL_WhenPokemonExists_ShouldReturnImageURL() {
        // Arrange
        let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"
        sut.pokemon = createMockPokemon(name: "pikachu", imageURL: imageURL)
        
        // Act & Assert
        XCTAssertEqual(sut.pokemonImageURL, imageURL)
    }
    
    // MARK: - Loading Prevention Tests
    
    func testLoadPokemonDetail_WhenAlreadyLoading_ShouldNotCallUseCase() {
        // Arrange
        sut.isLoading = true
        
        // Act
        sut.loadPokemonDetail()
        
        // Assert
        XCTAssertFalse(mockGetPokemonDetailUseCase.executeWasCalled)
    }
    
    // MARK: - Helper Methods
    
    private func createMockPokemon(name: String, imageURL: String? = nil) -> Pokemon {
        return Pokemon(id: 25,
                       name: name,
                       height: 4,
                       weight: 60,
                       imageURL: imageURL ?? "",
                       types: [.init(name: "electric", slot: 1)],
                       abilities: [.init(name: "static", isHidden: false, slot: 1)],
                       baseExperience: 112)
    }
}

// MARK: - Mock Classes

class MockGetPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol {
    func execute(name: String) async throws -> Pokemon {
        executeWasCalled = true

        switch mockResult {
        case .success(let pokemon):
            return pokemon
        case .failure(let error):
            throw error
        case .none:
            throw NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock not configured"])
        }
    }
    
    var mockResult: Result<Pokemon, Error>!
    var executeWasCalled = false
    
    func execute(id: Int) async throws -> Pokemon {
        executeWasCalled = true
        
        switch mockResult {
        case .success(let pokemon):
            return pokemon
        case .failure(let error):
            throw error
        case .none:
            throw NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock not configured"])
        }
    }
}
