//
//  AbilitiesFilterView.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 18/12/2023.
//

import Foundation
import SwiftUI

struct AbilitiesFilterView: View {
    var items: [String]
    @Binding var selectedAbility: String?
    var onSelection: () -> Void

    var body: some View {
        ForEach(items, id: \.self) { item in
            HStack {
                Text(item)
                Spacer()
                if selectedAbility == item {
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
        if selectedAbility == item {
            selectedAbility = nil
        } else {
            selectedAbility = item
        }
    }
}

struct AbilityView: View {
    let abilityName: String

    var body: some View {
        Text(abilityName)
            .padding(.leading, 4)
    }
}

