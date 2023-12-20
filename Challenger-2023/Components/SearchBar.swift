//
//  SearchBar.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 17/12/2023.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                

            TextField("Search Pokémon", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.trailing, 8)
        }
        .padding(.leading, 2)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
            .previewLayout(.fixed(width: 300, height: 50))
    }
}
