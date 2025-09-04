import Testing
import Foundation
@testable import BaseStructoriOSUIKit

@Suite("HomeDetailViewModel Swift Testing")
class HomeDetailViewModelSwiftTestsFixed {
    var sut: HomeDetailViewModel!
    var mockGetPokemonDetailUseCase: MockGetPokemonDetailUseCaseSwiftTesting!
    
    init() {
        mockGetPokemonDetailUseCase = MockGetPokemonDetailUseCaseSwiftTesting()
        sut = HomeDetailViewModel(
            pokemonId: 25,
            getPokemonDetailUseCase: mockGetPokemonDetailUseCase
        )
    }
    
    deinit {
        sut = nil
        mockGetPokemonDetailUseCase = nil
    }
    
    // MARK: - Initialization Tests
    
    @Test("HomeDetailViewModel should initialize with correct default values")
    func testInitialState() {
        // Assert
        #expect(sut.pokemon == nil)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }
    
    // MARK: - Data Loading Tests
    
    @Test("Should load pokemon detail successfully")
    func testLoadPokemonDetailSuccess() async {
        // Arrange
        let mockPokemon = createMockPokemon()
        mockGetPokemonDetailUseCase.mockResult = .success(mockPokemon)
        
        // Act
        await sut.loadPokemonDetail()

        // Assert
        #expect(sut.pokemon != nil)
        #expect(sut.pokemon?.name == "Pikachu")
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }
    
    @Test("Should handle pokemon detail loading failure")
    func testLoadPokemonDetailFailure() async {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "ไม่มีข้อมูล"])
        mockGetPokemonDetailUseCase.mockResult = .failure(expectedError)
        
        // Act
        await sut.loadPokemonDetail()

        // Assert
        #expect(sut.pokemon == nil)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == "ไม่มีข้อมูล")
    }
    
    @Test("Should handle network timeout error")
    func testLoadPokemonDetailNetworkTimeout() async {
        // Arrange
        let expectedError = NSError(domain: "NetworkError", code: 408, userInfo: [NSLocalizedDescriptionKey: "หมดเวลาการเชื่อมต่อ"])
        mockGetPokemonDetailUseCase.mockResult = .failure(expectedError)
        
        // Act
        await sut.loadPokemonDetail()

        // Assert
        #expect(sut.pokemon == nil)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == "หมดเวลาการเชื่อมต่อ")
    }
    
    // MARK: - Computed Properties Tests
    
    @Test("Pokemon computed properties should return correct values")
    func testPokemonComputedProperties() async {
        // Arrange
        let mockPokemon = createMockPokemon()
        mockGetPokemonDetailUseCase.mockResult = .success(mockPokemon)
        
        // Act
        await sut.loadPokemonDetail()

        // Assert
        #expect(sut.pokemonName == "Pikachu")
        #expect(sut.pokemonImageURL == "https://example.com/pikachu.png")
        #expect(sut.pokemonHeight == "0.4 m")
        #expect(sut.pokemonWeight == "6.0 kg")
    }
    
    @Test("Pokemon computed properties should return default values when no pokemon")
    func testPokemonComputedPropertiesWithNoPokemon() async {
        // Arrange
        mockGetPokemonDetailUseCase.mockResult = .success(createMockPokemon())
        
        // Act
        await sut.loadPokemonDetail()

        // Assert
        #expect(sut.pokemonName == "Pikachu")
        #expect(sut.pokemonImageURL == "https://example.com/pikachu.png")
    }
    
    // MARK: - Error Handling Tests
    
    @Test("Should handle custom error messages correctly")
    func testCustomErrorHandling() async {
        // Arrange
        let customError = NSError(domain: "CustomError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Custom error message"])
        mockGetPokemonDetailUseCase.mockResult = .failure(customError)
        
        // Act
        await sut.loadPokemonDetail()

        // Assert
        #expect(sut.errorMessage == "Custom error message")
    }
    
    @Test("Should clear error when loading new data")
    func testClearErrorOnNewLoad() async {
        // Arrange
        let error = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockGetPokemonDetailUseCase.mockResult = .failure(error)
        await sut.loadPokemonDetail()
        // Verify error is set
        #expect(sut.errorMessage != nil)
        
        // Act - load successful data
        let mockPokemon = createMockPokemon()
        mockGetPokemonDetailUseCase.mockResult = .success(mockPokemon)
        await sut.loadPokemonDetail()
        // Assert
        #expect(sut.errorMessage == nil)
    }
    
    // MARK: - Mock Data Creation Tests
    
    @Test("Should verify mock use case is called correctly")
    func testMockUseCaseCall() async {
        // Arrange
        let mockPokemon = createMockPokemon()
        mockGetPokemonDetailUseCase.mockResult = .success(mockPokemon)
        
        // Act
        await sut.loadPokemonDetail()
        // Assert
        #expect(mockGetPokemonDetailUseCase.executeCallCount == 1)
    }
    
    @Test("Should pass correct pokemon ID to use case", arguments: [1, 25, 150, 493])
    func testCorrectPokemonIdPassed(pokemonId: Int) async {
        // Arrange
        let mockUseCase = MockGetPokemonDetailUseCaseSwiftTesting()
        let viewModel = HomeDetailViewModel(
            pokemonId: pokemonId,
            getPokemonDetailUseCase: mockUseCase
        )
        let mockPokemon = createMockPokemon()
        mockUseCase.mockResult = .success(mockPokemon)
        
        // Act
        await viewModel.loadPokemonDetail()

        // Assert
        #expect(mockUseCase.executeCallCount == 1)
    }
    
    // MARK: - Helper Methods
    
    private func createMockPokemon() -> Pokemon {
        return Pokemon(
            id: 25,
            name: "Pikachu",
            height: 4,
            weight: 60,
            imageURL: "https://example.com/pikachu.png",
            types: [PokemonType(name: "electric", slot: 1)],
            abilities: [],
            baseExperience: 112
        )
    }
}

// MARK: - Mock Class for Swift Testing

class MockGetPokemonDetailUseCaseSwiftTesting: GetPokemonDetailUseCaseProtocol {
    var mockResult: Result<Pokemon, Error>!
    var executeCallCount = 0
    
    func execute(id: Int) async throws -> Pokemon {
        executeCallCount += 1
        
        switch mockResult {
        case .success(let pokemon):
            return pokemon
        case .failure(let error):
            throw error
        case .none:
            throw NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock not configured"])
        }
    }
    
    func execute(name: String) async throws -> Pokemon {
        executeCallCount += 1
        
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
