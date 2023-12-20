//
//  ButtonView.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 19/12/2023.
//

import Foundation
import SwiftUI

struct ButtonView: View {
    let imageName: String
    let label: String
    let action: () -> Void
    let isSelected: Bool

    var body: some View {
        VStack {
            Button(action: action) {
                Image(systemName: imageName)
                    .foregroundColor(isSelected ? .black : .gray)
                    .font(.title)
            }
            .padding(4)
            .background(Color.gray.opacity(0.2))
            .clipShape(Circle())
            .padding(.bottom, 2)
            .padding(.horizontal, 16)

            Text(label)
                .font(.caption)
                .foregroundColor(isSelected ? .black : .gray)
        }
    }
}
