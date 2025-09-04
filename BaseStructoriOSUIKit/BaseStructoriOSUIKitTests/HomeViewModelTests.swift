//
//  HomeViewModelTests.swift
//  BaseStructoriOSUIKitTests
//
//  Created by sahapap on 4/9/2568 BE.
//

import Testing
import Combine
import Foundation
@testable import BaseStructoriOSUIKit

@Suite("HomeViewModel Tests")
struct HomeViewModelTests {
    
    let mockUserManager: MockUserManager
    let mockGetPokemonListUseCase: MockGetPokemonListUseCase
    let sut: HomeViewModel
    
    init() {
        mockUserManager = MockUserManager()
        mockGetPokemonListUseCase = MockGetPokemonListUseCase()
        sut = HomeViewModel(
            userManager: mockUserManager,
            getPokemonListUseCase: mockGetPokemonListUseCase
        )
    }
    
    // MARK: - Initial State Tests
    
    @Test("Initial state should have correct default values")
    func initialState() {
        #expect(!sut.isLoading)
        #expect(sut.pokemonList.isEmpty)
        #expect(sut.errorMessage == nil)
        #expect(!sut.showError)
        #expect(sut.hasMoreData)
    }
    
    // MARK: - LoadInitialData Tests
    
    @Test("Load initial data should update loading state and fetch pokemon list")
    func loadInitialDataSuccess() async {
        // Arrange
        let expectedPokemonList = PokemonList(
            count: 2,
            next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
            previous: nil,
            results: [
                PokemonListItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                PokemonListItem(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/")
            ]
        )
        mockGetPokemonListUseCase.mockResult = .success(expectedPokemonList)
        
        // Act
        await sut.loadInitialData()
        
        // Assert
        #expect(!sut.isLoading)
        #expect(sut.pokemonList.count == 2)
        #expect(sut.pokemonList[0].name == "bulbasaur")
        #expect(sut.pokemonList[1].name == "ivysaur")
        #expect(sut.errorMessage == nil)
        #expect(!sut.showError)
        #expect(sut.hasMoreData) // Should be true because next is not nil
    }
    
    @Test("Load initial data should handle failure correctly")
    func loadInitialDataFailure() async {
        // Arrange
        let expectedError = NetworkError.noData
        mockGetPokemonListUseCase.mockResult = .failure(expectedError)
        
        // Act
        await sut.loadInitialData()
        
        // Assert
        #expect(!sut.isLoading)
        #expect(sut.pokemonList.isEmpty)
        #expect(sut.errorMessage == "ไม่มีข้อมูลตอบกลับ")
        #expect(sut.showError)
    }
    
    // MARK: - LoadMoreData Tests
    
    @Test("Load more data should append new pokemon to existing list")
    func loadMoreDataSuccess() async {
        // Arrange - Set initial data
        let initialPokemonList = PokemonList(
            count: 1,
            next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
            previous: nil,
            results: [PokemonListItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")]
        )
        mockGetPokemonListUseCase.mockResult = .success(initialPokemonList)
        await sut.loadInitialData()
        
        // Arrange - Set more data
        let morePokemonList = PokemonList(
            count: 2,
            next: nil,
            previous: nil,
            results: [PokemonListItem(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/")]
        )
        mockGetPokemonListUseCase.mockResult = .success(morePokemonList)
        
        // Act
        await sut.loadMoreData()

        // Assert
        #expect(!sut.isLoading)
        #expect(sut.pokemonList.count == 2)
        #expect(sut.pokemonList[0].name == "bulbasaur")
        #expect(sut.pokemonList[1].name == "ivysaur")
        #expect(!sut.hasMoreData) // Should be false because next is nil
    }
    
    // MARK: - Pagination Tests
    @Test("Has more data should be false when next is nil")
    func hasMoreDataFalseWhenNextIsNil() async {
        // Arrange
        let pokemonList = PokemonList(
            count: 10,
            next: nil,
            previous: nil,
            results: Array(1...10).map { PokemonListItem(name: "pokemon\($0)", url: "https://pokeapi.co/api/v2/pokemon/\($0)/") }
        )
        mockGetPokemonListUseCase.mockResult = .success(pokemonList)
        
        // Act
        await sut.loadInitialData()

        // Assert
        #expect(!sut.hasMoreData)
    }
    
    @Test("Has more data should be true when next is not nil")
    func hasMoreDataTrueWhenNextExists() async {
        // Arrange
        let pokemonList = PokemonList(
            count: 20,
            next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
            previous: nil,
            results: Array(1...20).map { PokemonListItem(name: "pokemon\($0)", url: "https://pokeapi.co/api/v2/pokemon/\($0)/") }
        )
        mockGetPokemonListUseCase.mockResult = .success(pokemonList)
        
        // Act
        await sut.loadInitialData()

        // Assert
        #expect(sut.hasMoreData)
    }
    
    // MARK: - Helper Methods
    
    private func createMockPokemonList(count: Int, hasNext: Bool = false) -> PokemonList {
        return PokemonList(
            count: count,
            next: hasNext ? "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20" : nil,
            previous: nil,
            results: Array(1...count).map { 
                PokemonListItem(name: "pokemon\($0)", url: "https://pokeapi.co/api/v2/pokemon/\($0)/") 
            }
        )
    }
}

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
