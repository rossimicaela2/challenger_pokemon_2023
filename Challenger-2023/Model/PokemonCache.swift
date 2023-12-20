//
//  PokemonCache.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 17/12/2023.
//

import Foundation

struct PokemonCache: Codable {
    var details: [Int: Data]?

    // Implementa el método de codificación manualmente
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Codifica los detalles como un diccionario de datos
        let encodedDetails = try details?.mapValues { try? JSONEncoder().encode($0) }
        try container.encode(encodedDetails, forKey: .details)
    }

    // Implementa el método de decodificación manualmente
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decodifica los detalles como un diccionario de datos
        let decodedDetails = try container.decodeIfPresent([Int: Data].self, forKey: .details)
        
        // Convierte los datos a instancias de PokemonDetails
        details = decodedDetails?.compactMapValues { try? JSONDecoder().decode(PokemonDetails.self, from: $0) } as! [Int : Data]
    }

    enum CodingKeys: String, CodingKey {
        case details
    }
}
