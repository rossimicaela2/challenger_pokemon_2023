//
//  TypesFilterView.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 18/12/2023.
//

import Foundation
import SwiftUI

struct TypesFilterView: View {
    var items: [String]
    @Binding var selectedType: String?
    var onSelection: () -> Void

    var body: some View {
        ForEach(items, id: \.self) { item in
            HStack {
                Text(item)
                Spacer()
                if selectedType == item {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                toggleSelection(item)
                onSelection()
            }
            .listRowBackground(Color.blue.opacity(0.2))
        }
    }

    private func toggleSelection(_ item: String) {
        if selectedType == item {
            selectedType = nil
        } else {
            selectedType = item
        }
    }
}

struct TypeView: View {
    let typeName: String
    let typeColor: Color

    var body: some View {
        HStack {
            Text(typeName)
                .fixedSize()
                .foregroundColor(typeColor)
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 8).fill(typeColor.opacity(0.2)))
        }
    }
}

