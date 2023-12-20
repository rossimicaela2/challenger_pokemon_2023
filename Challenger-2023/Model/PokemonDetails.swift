//
//  PokemonDetails.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 17/12/2023.
//

import Foundation

struct PokemonDetails: Codable {
    let abilities: [Ability]?
    let baseExperience: Int?
    let height: Int?
    let id: Int
    let moves: [Move]?
    let name: String?
    let sprites: Sprites?
    let stats: [Stat]?
    let types: [Type]?
    let weight: Int?
}

struct Ability: Codable {
    let ability: NamedResource?
    let isHidden: Bool?
    let slot: Int?
}

struct NamedResource: Codable {
    let name: String?
    let url: String?
}

struct Move: Codable {
    let move: NamedResource?
    let versionGroupDetails: [VersionGroupDetail]?
}

struct VersionGroupDetail: Codable {
    let levelLearnedAt: Int?
    let moveLearnMethod: NamedResource?
    let versionGroup: NamedResource?
}

struct Sprites: Codable {
    let frontDefault: String?
    let backDefault: String?
    let backFemale: String?
    let backShiny: String?
    let backShinyFemale: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    let other: OtherSprites?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        case other = "other"
    }
}

struct OtherSprites: Codable {
    let dreamWorld: DreamWorldSprites?
    let officialArtwork: OfficialArtwork?
    let home: HomeSprites?
}

struct DreamWorldSprites: Codable {
    let frontDefault: String?
    let frontFemale: String?
}

struct OfficialArtwork: Codable {
    let frontDefault: String?
    let frontShiny: String?
}

struct HomeSprites: Codable {
    let frontDefault: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    let frontFemale: String?
}

struct Stat: Codable {
    let baseStat: Int?
    let effort: Int?
    let stat: NamedResource?

    private enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseStat = try container.decodeIfPresent(Int.self, forKey: .baseStat)
        effort = try container.decodeIfPresent(Int.self, forKey: .effort)
        stat = try container.decodeIfPresent(NamedResource.self, forKey: .stat)
    }
}

struct Type: Codable {
    let slot: Int?
    let type: NamedResource
}
