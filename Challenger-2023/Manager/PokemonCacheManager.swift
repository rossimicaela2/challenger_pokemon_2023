//
//  PokemonCacheManager.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 17/12/2023.
//

import Foundation

class PokemonCacheManager {
    static let shared = PokemonCacheManager()
    
    private let userDefaults = UserDefaults.standard
    private let cacheKey = "pokemon_cache"
    
    private init() {
        // Cargar la caché desde UserDefaults si está disponible
        if let cachedData = userDefaults.data(forKey: cacheKey),
           let cachedDetails = try? JSONDecoder().decode([Int: PokemonDetails].self, from: cachedData) {
            cache = cachedDetails
        }
    }
    
    private var cache: [Int: PokemonDetails] = [:] {
        didSet {
            // Guardar la caché en UserDefaults cuando se actualiza
            if let encodedData = try? JSONEncoder().encode(cache) {
                userDefaults.set(encodedData, forKey: cacheKey)
            }
        }
    }
    
    func cacheDetails(for pokemonId: Int, details: PokemonDetails) {
        cache[pokemonId] = details
    }

    func getDetails(for pokemonId: Int) -> PokemonDetails? {
        return cache[pokemonId]
    }
}
