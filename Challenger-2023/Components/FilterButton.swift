//
//  FilterButton.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 17/12/2023.
//

import Foundation
import SwiftUI

struct FilterButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(.gray)
                .padding(.trailing, 16) // Ajusta el espaciado según sea necesario
        }
    }
}
