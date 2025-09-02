//
//  HomeDetailViewModel.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation
import Combine

// MARK: - HomeDetail ViewModel Input Protocol
protocol HomeDetailViewModelInput {
    func loadPokemonDetail()
    func refreshData()
}

// MARK: - HomeDetail ViewModel Output Protocol
protocol HomeDetailViewModelOutput: ObservableObject {
    var pokemon: Pokemon? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var showError: Bool { get }
    var pokemonName: String { get }
    var pokemonImageURL: String? { get }
}

// MARK: - HomeDetail ViewModel
class HomeDetailViewModel: HomeDetailViewModelOutput {

    // MARK: - Use Cases
    private let getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol

    // MARK: - Published Properties
    @Published var pokemon: Pokemon?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    // MARK: - Computed Properties
    var pokemonName: String {
        return pokemon?.name.capitalized ?? "Unknown Pokemon"
    }

    var pokemonImageURL: String? {
        return pokemon?.imageURL
    }

    var pokemonIdString: String {
        return "#\(String(format: "%03d", pokemonId))"
    }

    var pokemonHeight: String {
        guard let height = pokemon?.height else { return "Unknown" }
        let heightInMeters = Double(height) / 10.0
        return String(format: "%.1f m", heightInMeters)
    }

    var pokemonWeight: String {
        guard let weight = pokemon?.weight else { return "Unknown" }
        let weightInKg = Double(weight) / 10.0
        return String(format: "%.1f kg", weightInKg)
    }

    var pokemonTypes: String {
        guard let types = pokemon?.types else { return "Unknown" }
        return types.map { $0.name.capitalized }.joined(separator: ", ")
    }

    var pokemonAbilities: String {
        guard let abilities = pokemon?.abilities else { return "Unknown" }
        return abilities.map { $0.name.capitalized }.joined(separator: ", ")
    }


    var baseExperience: String {
        guard let exp = pokemon?.baseExperience else { return "Unknown" }
        return "\(exp) XP"
    }

    // MARK: - Properties
    let pokemonId: Int

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(
        pokemonId: Int,
        getPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol
    ) {
        self.pokemonId = pokemonId
        self.getPokemonDetailUseCase = getPokemonDetailUseCase
    }
}

// MARK: - HomeDetail ViewModel Input Implementation
extension HomeDetailViewModel: HomeDetailViewModelInput {
    
    func loadPokemonDetail() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        showError = false
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let pokemonDetail = try await self.getPokemonDetailUseCase.execute(id: self.pokemonId)
                
                await MainActor.run {
                    self.pokemon = pokemonDetail
                    self.isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    self.handleError(error)
                }
            }
        }
    }
    
    func refreshData() {
        loadPokemonDetail()
    }
    
    // MARK: - Private Methods
    private func handleError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            
            self?.errorMessage = error.localizedDescription
            self?.showError = true
        }
    }
}
