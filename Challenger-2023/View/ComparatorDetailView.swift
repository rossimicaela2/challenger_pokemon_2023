//
//  ComparatorDetailView.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 19/12/2023.
//

import SwiftUI

struct ComparatorDetailView: View {
    let leftPokemon: Pokemon
    let rightPokemon: Pokemon
    @Binding var selectedPokemons: Set<Pokemon>

    var body: some View {
            VStack(spacing: 16) {
                PokemonDetailView(viewModel: PokemonDetailViewModel(pokemon: leftPokemon))
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)

                PokemonDetailView(viewModel: PokemonDetailViewModel(pokemon: rightPokemon))
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .onDisappear {
                        // Esta acción se ejecutará cuando el usuario vuelva de visualizar la comparación
                        selectedPokemons.removeAll()
                    }
    }
}
