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
    func loadInitialData()
    func refreshData()
    func loadMoreData()
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
    
    func loadInitialData() {
        loadPokemonList()
    }
    
    func refreshData() {
        currentOffset = 0
        pokemonList.removeAll()
        hasMoreData = true
        loadPokemonList()
    }
    
    func loadMoreData() {
        guard !isLoading && hasMoreData else { return }
        loadPokemonList()
    }
    
    // MARK: - Private Methods
    private func loadPokemonList() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let response = try await self.getPokemonListUseCase.execute(
                    limit: self.limit,
                    offset: self.currentOffset
                )
                
                await MainActor.run {
                    if self.currentOffset == 0 {
                        self.pokemonList = response.results
                    } else {
                        self.pokemonList.append(contentsOf: response.results)
                    }
                    
                    self.currentOffset += self.limit
                    self.hasMoreData = response.next != nil
                    self.isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    self.handleError(error)
                }
            }
        }
    }
    
    private func handleError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.errorMessage = error.localizedDescription
            self?.showError = true
        }
    }
}
