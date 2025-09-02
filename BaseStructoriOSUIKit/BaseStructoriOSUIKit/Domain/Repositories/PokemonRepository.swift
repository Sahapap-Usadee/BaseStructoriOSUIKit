//
//  PokemonRepository.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation

// MARK: - Repository Protocol
protocol PokemonRepositoryProtocol {
    func fetchPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse
    func fetchPokemonDetail(id: Int) async throws -> Pokemon
    func fetchPokemonDetail(name: String) async throws -> Pokemon
}

// MARK: - Custom Errors
enum PokemonError: Error, LocalizedError {
    case pokemonNotFound
    case invalidPokemonData
    case networkFailure(String)
    
    var errorDescription: String? {
        switch self {
        case .pokemonNotFound:
            return "ไม่พบข้อมูล Pokémon"
        case .invalidPokemonData:
            return "ข้อมูล Pokémon ไม่ถูกต้อง"
        case .networkFailure(let message):
            return "เกิดข้อผิดพลาดในการเชื่อมต่อ: \(message)"
        }
    }
}
