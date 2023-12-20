//
//  PokemonListViewModelTests.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 19/12/2023.
//

import XCTest
@testable import Challenger_2023

class PokemonListViewModelTests: XCTestCase {

    var viewModel: PokemonListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = PokemonListViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchPokemons() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetching Pokémon")

        // Act
        viewModel.fetchPokemons()

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // Asegúrate de ajustar el tiempo límite según sea necesario
            XCTAssertTrue(self.viewModel.pokemons.count > 0, "La lista de Pokémon no debería estar vacía después de la recuperación")
            XCTAssertFalse(self.viewModel.isLoading, "isLoading debería ser false después de la recuperación")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10) // Ajusta el tiempo límite según sea necesario
    }
   
}
