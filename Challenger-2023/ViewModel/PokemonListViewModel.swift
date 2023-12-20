import Foundation
import SwiftUI
import Combine

class PokemonListViewModel: ObservableObject {
   
    private let pokemonService = PokemonService.shared

    @Published var pokemons: [Pokemon] = []
    @Published var details: [Int: PokemonDetails] = [:]
    var cancellables: Set<AnyCancellable> = Set()
    @Published var isLoading: Bool = false
    @Published var pokemonListResponse: PokemonListResponse?

    @Published var favoritePokemons: [Pokemon] = []
    
    init() {
        fetchPokemons()
    }

    func fetchPokemons() {
        isLoading = true

        pokemonService.fetchPokemons()
            .map(\.results)
            .receive(on: DispatchQueue.main)  // Asegúrate de recibir en el hilo principal
            .flatMap { pokemons in
                Publishers.MergeMany(pokemons.map { self.pokemonService.fetchPokemonDetails(for: $0) })
                    .collect()
                    .map { (pokemons, $0) }
            }
            .receive(on: DispatchQueue.main)  // Asegúrate de recibir en el hilo principal
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching Pokémon list: \(error)")
                }
            }, receiveValue: { [weak self] (pokemons, details) in
                for (pokemon, detail) in zip(pokemons, details) {
                    self?.details[pokemon.id] = detail
                }
                self?.pokemons = pokemons
                self?.pokemonListResponse = self?.pokemonService.lastFetchedResponse // Guarda la respuesta
                self?.isLoading = false
            })
            .store(in: &cancellables)
        
    }
    
    // busqueda de pokemons
    func filteredPokemons(searchText: String, showFavorites: Bool) -> [Pokemon] {
        let pokemonList: [Pokemon] = showFavorites ? favoritesPokemons() : pokemons
        
        if searchText.isEmpty {
            return pokemonList
        } else {
            return pokemonList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private func favoritesPokemons() -> [Pokemon] {
        let favoritePokemonIds = FavoritesManager.shared.favorites
        return pokemons.filter { favoritePokemonIds.contains($0.id) }
    }
    
    func getPokemonByTypeAndAbility(types: String?, abilities: String?) {
        isLoading = true
        var newPokemons: [Pokemon] = []
        let dispatchGroup = DispatchGroup()

        if let type = types {
            dispatchGroup.enter()
            let typePublisher = pokemonService.fetchPokemonWithType(typeName: type)
            typePublisher
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching Pokémon by type \(type): \(error)")
                    }
                    dispatchGroup.leave()
                }, receiveValue: { pokemons in
                    newPokemons += pokemons
                })
                .store(in: &cancellables)
        }

        if let ability = abilities {
            dispatchGroup.enter()
            let abilityPublisher = pokemonService.fetchPokemonWithAbility(abilityName: ability)
            abilityPublisher
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching Pokémon by ability \(ability): \(error)")
                    }
                    dispatchGroup.leave()
                }, receiveValue: { pokemons in
                    newPokemons += pokemons
                })
                .store(in: &cancellables)
        }

        dispatchGroup.notify(queue: .main) {
            print("New Pokémon List:")
            for pokemon in newPokemons {
                print("- \(pokemon.name)")
            }

            let detailsPublishers = newPokemons.map { self.pokemonService.fetchPokemonDetails(for: $0) }
            Publishers.MergeMany(detailsPublishers)
                .collect()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching Pokémon details: \(error)")
                        self.isLoading = false
                    }
                }, receiveValue: { [weak self] details in
                    guard let strongSelf = self else { return }

                    for (pokemon, detail) in zip(newPokemons, details) {
                        strongSelf.details[pokemon.id] = detail
                    }

                    strongSelf.pokemons = newPokemons
                    strongSelf.isLoading = false
                })
                .store(in: &self.cancellables)
        }
    }
    
    func fetchMorePokemons(completion: @escaping () -> Void) {
        guard let nextUrlString = pokemonListResponse?.next,
              let nextUrl = URL(string: nextUrlString) else {
                  completion() // Llama al bloque de finalización si no hay más Pokémon
                  return
        }

        isLoading = true

        pokemonService.fetchMorePokemons(url: nextUrl)
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .flatMap { pokemons in
                Publishers.MergeMany(pokemons.map { self.pokemonService.fetchPokemonDetails(for: $0) })
                    .collect()
                    .map { (pokemons, $0) }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break // No hay error, sigue con el flujo
                case .failure(let error):
                    print("Error fetching more Pokémon list: \(error)")
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] (pokemons, details) in
                for (pokemon, detail) in zip(pokemons, details) {
                    self?.details[pokemon.id] = detail
                }
                self?.pokemons.append(contentsOf: pokemons)
                // Imprime los nuevos Pokémon agregados
                print("Nuevos Pokémon agregados:")
                for pokemon in pokemons {
                    print("- \(pokemon.name)")
                }
                self?.pokemonListResponse = self?.pokemonService.lastFetchedResponse
            })
            .store(in: &cancellables)
    }


}

struct PokemonListResponse: Decodable {
    let results: [Pokemon]
    let next: String?
}

struct TypeListResponse: Decodable {
    let pokemon: [PokemonResponse]
}

struct AbilityListResponse: Decodable {
    let pokemon: [PokemonResponse]
}

struct PokemonResponse: Decodable {
    let pokemon: Pokemon
}
