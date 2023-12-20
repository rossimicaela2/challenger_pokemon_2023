import XCTest
@testable import Challenger_2023

class PokemonDetailViewTests: XCTestCase {

    func testPokemonDetailView() throws {
        // Arrange
        let pokemon = Pokemon(id: 5, name: "Jigglypuff", url: "https://pokeapi.co/api/v2/pokemon/5/")
        let viewModel = PokemonDetailViewModel(pokemon: pokemon)
        let view = PokemonDetailView(viewModel: viewModel)

        // Act
        // No hay acciones específicas en la vista para realizar en este momento

        // Assert
        XCTAssertTrue(view.viewModel.pokemon.name.capitalized == "Jigglypuff", "La vista debería contener el nombre del Pokémon")
        XCTAssertTrue(view.viewModel.details != nil, "La vista debería tener detalles del Pokémon")
        XCTAssertTrue(view.viewModel.details?.height ?? 0 > 0, "La vista debería contener la altura del Pokémon")
        XCTAssertTrue(view.viewModel.details?.weight ?? 0 > 0, "La vista debería contener el peso del Pokémon")
    }
}
