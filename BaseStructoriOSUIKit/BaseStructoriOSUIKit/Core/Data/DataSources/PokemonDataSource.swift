//
//  PokemonDataSource.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation

// MARK: - Pokemon Remote Data Source Protocol
protocol PokemonRemoteDataSourceProtocol {
    func fetchPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponseDTO
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetailDTO
    func fetchPokemonDetail(name: String) async throws -> PokemonDetailDTO
}

// MARK: - Pokemon Remote Data Source Implementation
class PokemonRemoteDataSource: PokemonRemoteDataSourceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponseDTO {
        let endpoint = "/pokemon?limit=\(limit)&offset=\(offset)"
        return try await networkService.request(
            endpoint: endpoint,
            method: .GET,
            headers: nil,
            body: nil,
            type: PokemonListResponseDTO.self
        )
    }
    
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetailDTO {
        let endpoint = "/pokemon/\(id)"
        return try await networkService.request(
            endpoint: endpoint,
            method: .GET,
            headers: nil,
            body: nil,
            type: PokemonDetailDTO.self
        )
    }
    
    func fetchPokemonDetail(name: String) async throws -> PokemonDetailDTO {
        let endpoint = "/pokemon/\(name.lowercased())"
        return try await networkService.request(
            endpoint: endpoint,
            method: .GET,
            headers: nil,
            body: nil,
            type: PokemonDetailDTO.self
        )
    }
}
