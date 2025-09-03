//
//  GetPokemonListUseCase.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation

// MARK: - GetPokemonList UseCase
protocol GetPokemonListUseCaseProtocol {
    func execute(limit: Int, offset: Int) async throws -> PokemonList
}

class GetPokemonListUseCase: GetPokemonListUseCaseProtocol {
    private let repository: PokemonRepositoryProtocol

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func execute(limit: Int = 20, offset: Int = 0) async throws -> PokemonList {
        return try await repository.fetchPokemonList(limit: limit, offset: offset)
    }
}
