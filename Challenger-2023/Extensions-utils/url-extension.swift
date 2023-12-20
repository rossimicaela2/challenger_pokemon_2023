//
//  url-extension.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 15/12/2023.
//

import Foundation

extension URL {
    var id: Int? {
        return lastPathComponent.isEmpty ? nil : Int(lastPathComponent)
    }
}
