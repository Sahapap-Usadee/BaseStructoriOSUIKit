//
//  PokemonRepositoryImpl.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation

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
        } catch let error as EnhancedNetworkError {
            switch error {
            case .unauthorized, .tokenExpired:
                throw SessionError.tokenExpired
            default:
                throw PokemonError.networkFailure(error.localizedDescription)
            }
        } catch {
            throw PokemonError.networkFailure(error.localizedDescription)
        }
    }
    
    func fetchPokemonDetail(id: Int) async throws -> Pokemon {
        do {
            // Fetch from remote
            let dto = try await remoteDataSource.fetchPokemonDetail(id: id)
            
            return dto.toDomain()
        } catch let error as EnhancedNetworkError {
            switch error {
            case .unauthorized, .tokenExpired:
                throw SessionError.tokenExpired
            case .serverError(404, _):
                throw PokemonError.pokemonNotFound
            default:
                throw PokemonError.networkFailure(error.localizedDescription)
            }
        } catch {
            throw PokemonError.networkFailure(error.localizedDescription)
        }
    }
    
    func fetchPokemonDetail(name: String) async throws -> Pokemon {
        do {
            // Fetch from remote
            let dto = try await remoteDataSource.fetchPokemonDetail(name: name)
            
            return dto.toDomain()
        } catch let error as EnhancedNetworkError {
            switch error {
            case .unauthorized, .tokenExpired:
                throw SessionError.tokenExpired
            case .serverError(404, _):
                throw PokemonError.pokemonNotFound
            default:
                throw PokemonError.networkFailure(error.localizedDescription)
            }
        } catch {
            throw PokemonError.networkFailure(error.localizedDescription)
        }
    }
}
