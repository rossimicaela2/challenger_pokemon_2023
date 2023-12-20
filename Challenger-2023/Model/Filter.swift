//
//  Filter.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 18/12/2023.
//

import Foundation

struct AbilitiesResponse: Decodable {
    let results: [AbilityFilter]
}

struct TypesResponse: Decodable {
    let results: [TypeFilter]
}

struct AbilityFilter: Decodable, Identifiable {
    let name: String
    let url: String

    var id: String {
        let components = url.components(separatedBy: "/")
        return components[components.count - 2]
    }
}

struct TypeFilter: Decodable, Identifiable {
    let name: String
    let url: String

    var id: String {
        let components = url.components(separatedBy: "/")
        return components[components.count - 2]
    }
}
