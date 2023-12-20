//
//  PokemonDetailView.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 17/12/2023.
//

import SwiftUI
import Kingfisher

struct PokemonDetailView: View {
    @ObservedObject var viewModel: PokemonDetailViewModel

    var body: some View {
        ScrollView {
            VStack {
                // Título
                Text(viewModel.pokemon.name.capitalized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 16)
                    .padding(.leading, 16)

                HStack {
                    Spacer()
                        Button(action: {
                            viewModel.isFavorite.toggle()
                        }) {
                            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(viewModel.isFavorite ? .red : .black)
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.7))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .shadow(radius: 5)
                        .padding(.trailing, 16)

                       
                    }
                
                // Imagen más grande y centrada
                if let frontImageURL = viewModel.details?.sprites?.frontDefault {
                    KFImage(URL(string: frontImageURL))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)  // Ajusta el tamaño según tus preferencias
                        .background(Circle().fill(Color.blue.opacity(0.2)))
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .clipShape(Circle())
                    // Elimina el padding horizontal
                }

                TypeListView(types: viewModel.details?.types ?? [], hiddenTitle: true)

                // Detalles del Pokémon
                if let details = viewModel.details {
                    // Altura y peso
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Height")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("\(details.height ?? 0) cm")
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Weight")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("\(details.weight ?? 0) kg")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                if let details = viewModel.details {
                    // Lista de habilidades
                    if let abilities = details.abilities {
                        AbilitySectionView(abilities: abilities)
                    }
 
                    // Stats con barras de porcentaje
                    if let stats = details.stats {
                        StatsSectionView(stats: stats)
                    }

                   
                } else {
                    // Muestra el loading mientras se cargan los detalles
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 50, height: 50)
                        .onAppear {
                            // Llama a fetchPokemonDetails cuando aparece la vista
                            viewModel.fetchPokemonDetails()
                        }
                }
            }
            .padding(.bottom, 16)
        }
    }
}

struct AbilitySectionView: View {
    let abilities: [Ability]

    var body: some View {
        HStack {
            Text("Abilities:")
                .font(.headline)
                .fontWeight(.bold)
            ForEach(abilities, id: \.ability?.name) { ability in
                AbilityView(abilityName: ability.ability?.name ?? "")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}

struct StatsSectionView: View {
    let stats: [Stat]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Stats:")
                .font(.headline)
                .fontWeight(.bold)

            ForEach(stats, id: \.stat?.name) { stat in
                if let baseStat = stat.baseStat {
                    StatBarView(statName: stat.stat?.name?.capitalized ?? "", baseStat: baseStat)
                        .padding(.leading, 16)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}

