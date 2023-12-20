//
//  FavoritesManager.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 19/12/2023.
//

import Foundation
import SwiftUI

class FavoritesManager {
    static let shared = FavoritesManager()

    internal let favoritesKey = "FavoritePokemon"

    internal var favorites: Set<Int> {
        get {
            if let favoritesArray = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
                return Set(favoritesArray)
            }
            return Set<Int>()
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: favoritesKey)
        }
    }

    func addFavorite(pokemonId: Int) {
        var currentFavorites = favorites
        currentFavorites.insert(pokemonId)
        favorites = currentFavorites
    }

    func removeFavorite(pokemonId: Int) {
        var currentFavorites = favorites
        currentFavorites.remove(pokemonId)
        favorites = currentFavorites
    }

    func removeAllFavorite() {
        favorites.removeAll()
    }
    
    func isFavorite(pokemonId: Int) -> Bool {
        return favorites.contains(pokemonId)
    }
}

