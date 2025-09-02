//
//  HomeViewModel.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    // MARK: - Services & Use Cases
    public let userService: UserServiceProtocol
    private let getPokemonListUseCase: GetPokemonListUseCaseProtocol

    // MARK: - Published Properties
    @Published var title: String = "Pokemon List"
    @Published var description: String = "ยินดีต้อนรับสู่ Pokemon App ที่ใช้ Clean Architecture"
    @Published var isLoading: Bool = false
    @Published var pokemonList: [PokemonListItem] = []
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Pagination Properties
    @Published var hasMoreData: Bool = true
    private var currentOffset: Int = 0
    private let limit: Int = 20

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        userService: UserServiceProtocol,
        getPokemonListUseCase: GetPokemonListUseCaseProtocol
    ) {
        self.userService = userService
        self.getPokemonListUseCase = getPokemonListUseCase
        loadInitialData()
    }
    
    // MARK: - Public Methods
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
    
    func handleError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            
            if error is SessionError {
                // Session expired will be handled by SessionExpiredHandler automatically
                return
            }
            
            self?.errorMessage = error.localizedDescription
            self?.showError = true
        }
    }
    
    // MARK: - Private Methods
    private func loadInitialData() {
        loadPokemonList()
    }
    
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
}
