//
//  GetPokemonDetailUseCase.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation

// MARK: - GetPokemonDetail UseCase
protocol GetPokemonDetailUseCaseProtocol {
    func execute(id: Int) async throws -> Pokemon
    func execute(name: String) async throws -> Pokemon
}

class GetPokemonDetailUseCase: GetPokemonDetailUseCaseProtocol {
    private let repository: PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: Int) async throws -> Pokemon {
        return try await repository.fetchPokemonDetail(id: id)
    }
    
    func execute(name: String) async throws -> Pokemon {
        return try await repository.fetchPokemonDetail(name: name)
    }
}
