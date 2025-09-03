//
//  PokemonDTO.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 2/9/2568 BE.
//

import Foundation

// MARK: - Pokemon List DTO
struct PokemonListResponseDTO: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItemDTO]
}

struct PokemonListItemDTO: Codable {
    let name: String
    let url: String
}

// MARK: - Pokemon Detail DTO
struct PokemonDetailDTO: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let baseExperience: Int?
    let sprites: PokemonSpritesDTO
    let types: [PokemonTypeSlotDTO]
    let abilities: [PokemonAbilitySlotDTO]
    
    enum CodingKeys: String, CodingKey {
        case id, name, height, weight, sprites, types, abilities
        case baseExperience = "base_experience"
    }
}

struct PokemonSpritesDTO: Codable {
    let frontDefault: String?
    let frontShiny: String?
    let frontFemale: String?
    let frontShinyFemale: String?
    let backDefault: String?
    let backShiny: String?
    let backFemale: String?
    let backShinyFemale: String?
    let other: PokemonOtherSpritesDTO?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case frontFemale = "front_female"
        case frontShinyFemale = "front_shiny_female"
        case backDefault = "back_default"
        case backShiny = "back_shiny"
        case backFemale = "back_female"
        case backShinyFemale = "back_shiny_female"
        case other
    }
}

struct PokemonOtherSpritesDTO: Codable {
    let officialArtwork: PokemonOfficialArtworkDTO?
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct PokemonOfficialArtworkDTO: Codable {
    let frontDefault: String?
    let frontShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

struct PokemonTypeSlotDTO: Codable {
    let slot: Int
    let type: PokemonTypeDTO
}

struct PokemonTypeDTO: Codable {
    let name: String
    let url: String
}

struct PokemonAbilitySlotDTO: Codable {
    let slot: Int
    let isHidden: Bool
    let ability: PokemonAbilityDTO
    
    enum CodingKeys: String, CodingKey {
        case slot, ability
        case isHidden = "is_hidden"
    }
}

struct PokemonAbilityDTO: Codable {
    let name: String
    let url: String
}

// MARK: - DTO to Domain Mappers
extension PokemonListResponseDTO {
    func toDomain() -> PokemonList {
        return PokemonList(
            count: count,
            next: next,
            previous: previous,
            results: results.map { $0.toDomain() }
        )
    }
}

extension PokemonListItemDTO {
    func toDomain() -> PokemonListItem {
        return PokemonListItem(name: name, url: url)
    }
}

extension PokemonDetailDTO {
    func toDomain() -> Pokemon {
        let imageURL = sprites.other?.officialArtwork?.frontDefault 
                    ?? sprites.frontDefault 
                    ?? ""
        
        return Pokemon(
            id: id,
            name: name,
            height: height,
            weight: weight,
            imageURL: imageURL,
            types: types.map { $0.toDomain() },
            abilities: abilities.map { $0.toDomain() },
            baseExperience: baseExperience
        )
    }
}

extension PokemonTypeSlotDTO {
    func toDomain() -> PokemonType {
        return PokemonType(name: type.name, slot: slot)
    }
}

extension PokemonAbilitySlotDTO {
    func toDomain() -> PokemonAbility {
        return PokemonAbility(name: ability.name, isHidden: isHidden, slot: slot)
    }
}
