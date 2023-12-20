//
//  LoadingView.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 17/12/2023.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    @Binding var isLoading: Bool

    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .opacity(isLoading ? 1 : 0)
    }
}

