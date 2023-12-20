import XCTest
@testable import Challenger_2023

class PokemonDetailViewModelTests: XCTestCase {

    func testToggleFavorite() throws {
        FavoritesManager.shared.removeAllFavorite()
        let pokemon = Pokemon(id: 5, name: "Jigglypuff", url: "https://pokeapi.co/api/v2/pokemon/5/")
        // Arrange
        let viewModel = PokemonDetailViewModel(pokemon: pokemon)
        
        let view = PokemonDetailView(viewModel: viewModel)

        view.viewModel.toggleFavorite()

        // Assert
        XCTAssertFalse(view.viewModel.isFavorite, "La propiedad isFavorite del ViewModel debería ser false después de sacar el Pokémon a favoritos")
        

       
        
    }
}
