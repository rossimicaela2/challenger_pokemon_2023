//
//  StatBarView.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 19/12/2023.
//

import Foundation
import SwiftUI

struct StatBarView: View {
    let statName: String
    let baseStat: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(statName)
                    .fontWeight(.bold)
                Spacer()
                Text("\(baseStat)%")
                    .foregroundColor(.blue)
            }

            // Barra de porcentaje
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.blue.opacity(0.3))
                        .frame(width: geometry.size.width, height: 12)
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.blue)
                        .frame(width: CGFloat(baseStat) * (geometry.size.width / 100), height: 12)
                }
            }
            .frame(height: 12)
        }
    }
}
