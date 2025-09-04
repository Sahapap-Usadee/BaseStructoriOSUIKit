//
//  HomeViewModel.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import Foundation
import Combine

// MARK: - Home ViewModel Input Protocol
protocol HomeViewModelInput {
    func loadInitialData() async
    func refreshData() async
    func loadMoreData() async
}

// MARK: - Home ViewModel Output Protocol
protocol HomeViewModelOutput: ObservableObject {
    var isLoading: Bool { get }
    var pokemonList: [PokemonListItem] { get }
    var errorMessage: String? { get }
    var showError: Bool { get }
    var hasMoreData: Bool { get }
}

// MARK: - Home ViewModel
class HomeViewModel: HomeViewModelOutput {
    
    // MARK: - Services & Use Cases
    public let userManager: UserManagerProtocol
    private let getPokemonListUseCase: GetPokemonListUseCaseProtocol
    
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var pokemonList: [PokemonListItem] = []
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var hasMoreData: Bool = true
    
    // MARK: - Pagination Properties
    private var currentOffset: Int = 0
    private let limit: Int = 20
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        userManager: UserManagerProtocol,
        getPokemonListUseCase: GetPokemonListUseCaseProtocol
    ) {
        self.userManager = userManager
        self.getPokemonListUseCase = getPokemonListUseCase
    }
}

// MARK: - Home ViewModel Input Implementation
extension HomeViewModel: HomeViewModelInput {
    
    func loadInitialData() async {
        await loadPokemonList()
    }
    
    func refreshData() async {
        currentOffset = 0
        pokemonList.removeAll()
        hasMoreData = true
        await loadPokemonList()
    }
    
    func loadMoreData() async {
        guard !isLoading && hasMoreData else { return }
        await loadPokemonList()
    }
    
    // MARK: - Private Methods
    private func loadPokemonList() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        do {
            let response = try await getPokemonListUseCase.execute(
                limit: limit,
                offset: currentOffset
            )
            
            if currentOffset == 0 {
                pokemonList = response.results
            } else {
                pokemonList.append(contentsOf: response.results)
            }
            
            currentOffset += limit
            hasMoreData = response.next != nil
            isLoading = false
            
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        isLoading = false
        errorMessage = error.localizedDescription
        showError = true
    }
}
