//
//  PokemonService.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 18/12/2023.
//

import Foundation
import Combine

class PokemonService {
    static let shared = PokemonService()
    var lastFetchedResponse: PokemonListResponse?

    private init() {}

    func fetchPokemons() -> AnyPublisher<PokemonListResponse, Error> {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonListResponse.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { response in
                            self.lastFetchedResponse = response
                        })
            .eraseToAnyPublisher()
    }

    func fetchPokemonDetails(for pokemon: Pokemon) -> AnyPublisher<PokemonDetails, Error> {
        if let cachedDetails = PokemonCacheManager.shared.getDetails(for: pokemon.id) {
            return Just(cachedDetails)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } 
        
        guard let url = URL(string: pokemon.url) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonDetails.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { details in
                // Al recibir los detalles, también actualiza el caché
                PokemonCacheManager.shared.cacheDetails(for: pokemon.id, details: details)
            })
            .eraseToAnyPublisher()
    }

    func fetchPokemonWithType(typeName: String) -> AnyPublisher<[Pokemon], Error> {
        guard let url = URL(string: "https://pokeapi.co/api/v2/type/\(typeName.lowercased())/") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TypeListResponse.self, decoder: JSONDecoder())
            .map { $0.pokemon.map { $0.pokemon } }
            .eraseToAnyPublisher()
    }

    func fetchPokemonWithAbility(abilityName: String) -> AnyPublisher<[Pokemon], Error> {
        guard let url = URL(string: "https://pokeapi.co/api/v2/ability/\(abilityName.lowercased())/") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: AbilityListResponse.self, decoder: JSONDecoder())
            .map { $0.pokemon.map { $0.pokemon } }
            .eraseToAnyPublisher()
    }
    
    func fetchMorePokemons(url: URL) -> AnyPublisher<PokemonListResponse, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonListResponse.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { response in
                           self.lastFetchedResponse = response
                       })
            .eraseToAnyPublisher()
    }
    
    func getNextUrl(from response: PokemonListResponse) -> URL? {
        guard let nextUrlString = response.next,
            let nextUrl = URL(string: nextUrlString) else {
                return nil
        }
        return nextUrl
    }

}
