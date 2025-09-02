//
//  Pokemon.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation

// MARK: - Domain Entities
struct Pokemon {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let imageURL: String
    let types: [PokemonType]
    let abilities: [PokemonAbility]
    let baseExperience: Int?
}

struct PokemonType {
    let name: String
    let slot: Int
}

struct PokemonAbility {
    let name: String
    let isHidden: Bool
    let slot: Int
}

struct PokemonListItem {
    let name: String
    let url: String
    
    var id: Int? {
        // Extract ID from URL: https://pokeapi.co/api/v2/pokemon/1/
        let components = url.components(separatedBy: "/")
        guard let idString = components.dropLast().last, let id = Int(idString) else {
            return nil
        }
        return id
    }
}

struct PokemonListResponse {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItem]
}
