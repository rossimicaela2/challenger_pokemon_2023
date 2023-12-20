//
//  ButtonStack.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 19/12/2023.
//

import Foundation
import SwiftUI

struct ButtonStack: View {
    @Binding var showFavorites: Bool
    @Binding var isComparisonSheetPresented: Bool
    @Binding var isHomePresented: Bool
    @Binding var isFavoritesPresented: Bool
    @Binding var selectedPokemons: Set<Pokemon>

    var body: some View {
        HStack(spacing: 24) {
            ButtonView(imageName: "house", label: "Home", action: {
                updateState(showFavorites: false, isComparisonSheet: false, isHome: true, isFavorites: false)
            }, isSelected: isHomePresented)

            ButtonView(imageName: "heart", label: "Favorites", action: {
                updateState(showFavorites: true, isComparisonSheet: false, isHome: false, isFavorites: true)
            }, isSelected: isFavoritesPresented)

            ButtonView(imageName: "arrow.left.and.right.circle.fill", label: "Comparator", action: {
                updateState(showFavorites: false, isComparisonSheet: true, isHome: false, isFavorites: false)
            }, isSelected: isComparisonSheetPresented)
        }
        .padding(.vertical, 8)
    }

    private func updateState(showFavorites: Bool, isComparisonSheet: Bool, isHome: Bool, isFavorites: Bool) {
        self.showFavorites = showFavorites
        self.isComparisonSheetPresented = isComparisonSheet
        self.isHomePresented = isHome
        self.isFavoritesPresented = isFavorites
        self.selectedPokemons.removeAll()
    }
}
