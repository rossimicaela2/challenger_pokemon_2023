//
//  PokemonListViewTest.swift
//  Challenger-2023Tests
//
//  Created by Micaela Rossi on 19/12/2023.
//

import XCTest
@testable import Challenger_2023

final class PokemonListViewTest: XCTestCase {
    
    var viewModel: PokemonListViewModel!
    var pokemonListView: PokemonListView!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        viewModel = PokemonListViewModel()
        pokemonListView = PokemonListView(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPokemonListIsDisplayed() {
        let viewModel = PokemonListViewModel()
        let pokemonListView = PokemonListView(viewModel: viewModel)

        let expectation = XCTestExpectation(description: "Carga de Pokémon")

        // Simula la aparición de la vista (llama al método onAppear)
        pokemonListView.onAppear()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Asegúrate de que la lista de Pokémon no esté vacía después de la carga
            XCTAssertFalse(viewModel.pokemons.isEmpty, "La lista de Pokémon debería contener elementos después de la carga")
            
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)  // Ajusta el tiempo de espera según sea necesario
    }

    func testSearchByName() {
        let viewModel = PokemonListViewModel()
        let pokemonListView = PokemonListView(viewModel: viewModel)

        let expectation = XCTestExpectation(description: "Búsqueda de Pokémon por nombre")

        // Simula la aparición de la vista (llama al método onAppear)
        pokemonListView.onAppear()

        // Realiza la búsqueda por nombre después de un tiempo de espera
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let pokemonNameToSearch = "bulbasaur"
            pokemonListView.searchText = pokemonNameToSearch

            // Verifica que la lista de Pokémon filtrada contenga resultados
            XCTAssertTrue(viewModel.filteredPokemons(searchText: pokemonNameToSearch, showFavorites: false).count > 0, "La búsqueda por nombre debería devolver resultados")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)  // Ajusta el tiempo de espera según sea necesario
    }

}
