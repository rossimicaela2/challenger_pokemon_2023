//
//  TypeListView.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 18/12/2023.
//

import SwiftUI

struct TypeListView: View {
    let types: [Type]
    let hiddenTitle: Bool

    init(types: [Type], hiddenTitle: Bool = true) {
        self.types = types
        self.hiddenTitle = hiddenTitle
    }

    var body: some View {
        HStack() {
            if !hiddenTitle {
                Text("Types:")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.horizontal, 12)
            }
            VStack(alignment: .leading) {
                if types.isEmpty {
                    HStack {
                        Text("empty")
                            .foregroundColor(.white)
                    }
                } else {
                    ForEach(types, id: \.type.name) { type in
                        if let typeName = type.type.name,
                           let pokemonType = PokemonType(rawValue: typeName) {
                            TypeView(typeName: typeName, typeColor: pokemonType.color)
                        } else if let typeName = type.type.name {
                            // Utiliza el color gray como valor predeterminado
                            TypeView(typeName: typeName, typeColor: .gray)
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
            .padding(.top, hiddenTitle ? 0 : 2)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

