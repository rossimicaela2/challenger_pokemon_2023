//
//  FilterSheet.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 18/12/2023.
//

import Foundation
import SwiftUI

struct FilterSheet: View {
    @ObservedObject var viewModel: PokemonListViewModel  
    @State private var abilities: [AbilityFilter] = []
    @State private var types: [TypeFilter] = []
    @State private var isAbilitiesExpanded = false
    @State private var isTypesExpanded = false
    @Environment(\.presentationMode) var presentationMode

    @State  var selectedAbility: String? = nil
    @State  var selectedType: String? = nil

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Filtrar por:")) {
                    DisclosureGroup(
                        isExpanded: $isAbilitiesExpanded,
                        content: {
                            Group { // Utiliza Group en lugar de VStack
                                List {
                                    AbilitiesFilterView(items: abilities.map { $0.name }, selectedAbility: $selectedAbility) {
                                        // Handle selection if needed
                                    }
                                    .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                                }
                                .frame(height: isAbilitiesExpanded ? 150 : 0) // Ajusta la altura del contenido interno
                            }
                        },
                        label: {
                            Label("Habilidades", systemImage: "chevron.right.circle")
                        }
                    )
                    .onChange(of: isAbilitiesExpanded) { _ in
                        if isAbilitiesExpanded {
                            fetchAbilities()
                        }
                    }
                    
                    DisclosureGroup(
                        isExpanded: $isTypesExpanded,
                        content: {
                            Group { // Utiliza Group en lugar de VStack
                                List {
                                    TypesFilterView(items: types.map { $0.name }, selectedType: $selectedType) {
                                        // Handle selection if needed
                                    }
                                    .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                                }
                                .frame(height: isTypesExpanded ? 150 : 0) // Ajusta la altura del contenido interno
                            }
                        },
                        label: {
                            Label("Tipos", systemImage: "chevron.right.circle")
                        }
                    )
                    .onChange(of: isTypesExpanded) { _ in
                        if isTypesExpanded {
                            fetchTypes()
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Filtros")
            .navigationBarItems(trailing:
                Button(action: {
                   
                    // Llama a la función para actualizar la lista de Pokémon
                   if  selectedType != nil || selectedAbility != nil {
                        viewModel.getPokemonByTypeAndAbility(types: selectedType, abilities: selectedAbility)
                    } else {
                        // Si no se seleccionaron habilidades ni tipos, simplemente actualiza la lista
                        viewModel.fetchPokemons()
                    }
                
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cerrar")
                }
            )
        }
    }

    private func fetchAbilities() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/ability") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let abilitiesResponse = try JSONDecoder().decode(AbilitiesResponse.self, from: data)
                    DispatchQueue.main.async {
                        abilities = abilitiesResponse.results
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
        .resume()
    }

    private func fetchTypes() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/type") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let typesResponse = try JSONDecoder().decode(TypesResponse.self, from: data)
                    DispatchQueue.main.async {
                        types = typesResponse.results
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
        .resume()
    }
}

