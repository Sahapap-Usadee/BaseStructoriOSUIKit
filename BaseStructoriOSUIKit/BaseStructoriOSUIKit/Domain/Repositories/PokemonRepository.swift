//
//  PokemonRepository.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation

protocol PokemonRepositoryProtocol {
    func fetchPokemonList(limit: Int, offset: Int) async throws -> PokemonList
    func fetchPokemonDetail(id: Int) async throws -> Pokemon
    func fetchPokemonDetail(name: String) async throws -> Pokemon
}

class PokemonRepositoryImpl: PokemonRepositoryProtocol {
    private let remoteDataSource: PokemonRemoteDataSourceProtocol

    init(
        remoteDataSource: PokemonRemoteDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchPokemonList(limit: Int, offset: Int) async throws -> PokemonList {
        do {
            // Fetch from remote
            let dto = try await remoteDataSource.fetchPokemonList(limit: limit, offset: offset)

            return dto.toDomain()
        } catch {
            throw error
        }
    }

    func fetchPokemonDetail(id: Int) async throws -> Pokemon {
        do {
            // Fetch from remote
            let dto = try await remoteDataSource.fetchPokemonDetail(id: id)

            return dto.toDomain()
        } catch {
            throw error
        }
    }

    func fetchPokemonDetail(name: String) async throws -> Pokemon {
        do {
            // Fetch from remote
            let dto = try await remoteDataSource.fetchPokemonDetail(name: name)

            return dto.toDomain()
        } catch {
            throw error
        }
    }
}
