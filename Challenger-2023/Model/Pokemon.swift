//
//  Pokemon.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 15/12/2023.
//

import SwiftUI

struct Pokemon: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let url: String
    // estas propiedades adicionales
    var imageURL: String?
    var type: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)

        // Extraer el ID del último componente numérico en la URL
        if let pokemonID = url.components(separatedBy: "/").compactMap({ Int($0) }).last {
            id = pokemonID
        } else {
            // En caso de error, asignar un valor predeterminado
            id = 0
        }
    }
    
    init(id: Int, name: String, url: String, imageURL: String? = nil, type: String? = nil) {
            self.id = id
            self.name = name
            self.url = url
            self.imageURL = imageURL
            self.type = type
        }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
            return lhs.id == rhs.id
        }
}

enum PokemonType: String {
    case grass, fire, water, electric, poison, bug

    var color: Color {
        switch self {
        case .grass: return .green
        case .fire: return .red
        case .water: return .blue
        case .electric: return .yellow
        case .poison, .bug: return .purple
        }
    }
}
