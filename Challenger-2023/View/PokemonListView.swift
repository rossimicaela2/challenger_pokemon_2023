//
//  PokemonListView.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 17/12/2023.
//
import Foundation
import SwiftUI
import Network

struct PokemonListView: View {
    @ObservedObject var viewModel = PokemonListViewModel()
    @State var searchText = ""
    @State var isFilterSheetPresented = false
    @State private var scrollViewProxy: ScrollViewProxy?
    @State private var showFavorites = false
    @State private var selectedPokemons: Set<Pokemon> = Set()
    @State private var isComparisonSheetPresented = false
    @State private var isHomePresented = true
    @State private var isFavoritesPresented = false
    @State private var isSelectionModeActive = false
    @State private var isComparisonDetailViewPresented = false // Nueva variable de estado

    var body: some View {
        NavigationView {
            VStack {
                Text("Use the advanced search to find Pokémon by type or ability.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                    .padding(.top, 16)
                HStack {
                    SearchBar(text: $searchText)
                        .padding(.horizontal)

                    Spacer()

                    FilterButton {
                        isFilterSheetPresented = true
                    }
                }
                .sheet(isPresented: $isFilterSheetPresented) {
                    FilterSheet(viewModel: viewModel)
                }

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    PokemonGridLazyVGrid(
                        viewModel: viewModel,
                        searchText: $searchText,
                        scrollViewProxy: $scrollViewProxy,
                        showFavorites: $showFavorites,
                        selectedPokemons: $selectedPokemons,
                        isModeComparator: $isComparisonSheetPresented
                    )
                    .padding(8)
                }

                ButtonStack(
                        showFavorites: $showFavorites,
                        isComparisonSheetPresented: $isComparisonSheetPresented,
                        isHomePresented: $isHomePresented,
                        isFavoritesPresented: $isFavoritesPresented,
                        selectedPokemons: $selectedPokemons
                    )
                
                if selectedPokemons.count >= 2 {
                     let firstPokemon = selectedPokemons[selectedPokemons.index(selectedPokemons.startIndex, offsetBy: 0)]
                     let secondPokemon = selectedPokemons[selectedPokemons.index(selectedPokemons.startIndex, offsetBy: 1)]
                    NavigationLink(destination: ComparatorDetailView(leftPokemon: firstPokemon, rightPokemon: secondPokemon, selectedPokemons: $selectedPokemons), isActive: $isComparisonDetailViewPresented) {
                        EmptyView()
                    }
                    .onAppear {
                        if isComparisonSheetPresented && selectedPokemons.count == 2 {
                            isComparisonDetailViewPresented = true
                        }
                    }
                }
                
            }
            .navigationTitle("Pokédex")
            .onAppear {
                if NetworkMonitor.shared.isConnected {
                    viewModel.fetchPokemons()
                }
            }
        }
    }
}

struct PokemonGridLazyVGrid: View {
    @ObservedObject var viewModel: PokemonListViewModel
    @Binding var searchText: String
    @Binding var scrollViewProxy: ScrollViewProxy?
    @State private var isLoadingMoreInView = false
    @Binding var showFavorites: Bool
    @Binding var selectedPokemons: Set<Pokemon>
    @Binding var isModeComparator: Bool

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 8) {
                    ForEach(Array(viewModel.filteredPokemons(searchText: searchText, showFavorites: showFavorites).enumerated()), id: \.element.id) { index, pokemon in
                        NavigationLink(destination: PokemonDetailView(viewModel: PokemonDetailViewModel(pokemon: pokemon))) {
                            PokemonGridCell(
                                pokemon: pokemon,
                                details: viewModel.details[pokemon.id],
                                selected: selectedPokemons.contains(pokemon),
                                onSelect: {
                                    if isModeComparator {
                                        if selectedPokemons.contains(pokemon) {
                                            selectedPokemons.remove(pokemon)
                                        } else {
                                            selectedPokemons.insert(pokemon)
                                        }
                                    }
                                },
                                isModeComparator: isModeComparator
                            )
                            .aspectRatio(1, contentMode: .fit)
                            .onAppear {
                                let thresholdIndex = viewModel.pokemons.count - 5
                                if index == thresholdIndex {
                                    guard !isLoadingMoreInView else { return }
                                    isLoadingMoreInView = true

                                    viewModel.fetchMorePokemons {
                                        isLoadingMoreInView = false
                                    }
                                }
                            }
                        }
                    }
                    if isLoadingMoreInView {
                        ProgressView()
                            .padding(8)
                    }
                }
            }
        }
    }
}
