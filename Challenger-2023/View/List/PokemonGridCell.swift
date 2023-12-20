//
//  PokemonGridCell.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 17/12/2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct PokemonGridCell: View {
    let pokemon: Pokemon
    let details: PokemonDetails?
    @State private var isLoadingImage: Bool = true
    let selected: Bool
    let onSelect: () -> Void
    let isModeComparator: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Text(pokemon.name.capitalized)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        TypeListView(types: details?.types ?? [], hiddenTitle: true)
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if let imageURL = details?.sprites?.frontDefault {
                        KFImage(URL(string: imageURL))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .onAppear {
                                isLoadingImage = false
                            }
                    } else {
                        LoadingView(isLoading: $isLoadingImage)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                if isModeComparator {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            onSelect()
                        }) {
                            Image(systemName: selected ? "square.fill" : "square")
                                .foregroundColor(selected ? .gray : .black)
                        }
                        .padding(4)
                        .background(Color.white.opacity(0.7))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .shadow(radius: 5)
                        .padding(.trailing, 4)
                    }
                }
            }
        }
        .padding(6)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}
