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
