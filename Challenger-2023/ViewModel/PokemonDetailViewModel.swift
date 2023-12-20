//
//  PokemonDetailViewModel.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 18/12/2023.
//

import Foundation
import Combine

class PokemonDetailViewModel: ObservableObject {
    private let pokemonService: PokemonService
    @Published var pokemon: Pokemon
    @Published var details: PokemonDetails?
    @Published var isLoadingDetails: Bool = false
    private var cancellables: Set<AnyCancellable> = []
   
    @Published var isFavorite: Bool {
           didSet {
               if isFavorite {
                   FavoritesManager.shared.addFavorite(pokemonId: pokemon.id)
               } else {
                   FavoritesManager.shared.removeFavorite(pokemonId: pokemon.id)
               }
           }
       }
    
    init(pokemon: Pokemon, pokemonService: PokemonService = PokemonService.shared) {
        print("Initializing ViewModel for Pokémon with ID: \(pokemon.id)")
        self.pokemon = pokemon
        self.pokemonService = pokemonService
        self.isFavorite = FavoritesManager.shared.isFavorite(pokemonId: pokemon.id)
        print("Is Favorite: \(isFavorite)")
        fetchPokemonDetails()
    }

    func fetchPokemonDetails() {
        isLoadingDetails = true

        pokemonService.fetchPokemonDetails(for: pokemon)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching Pokémon details: \(error)")
                    self?.isLoadingDetails = false
                }
            }, receiveValue: { [weak self] details in
                self?.details = details
                self?.isLoadingDetails = false
            })
            .store(in: &cancellables)
    }
    
    func toggleFavorite() {
            if isFavorite {
                FavoritesManager.shared.removeFavorite(pokemonId: pokemon.id)
            } else {
                FavoritesManager.shared.addFavorite(pokemonId: pokemon.id)
            }
        }
}
