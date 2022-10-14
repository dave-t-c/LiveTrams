//
//  Route.swift
//  LiveTramsMCR
//
//  Created by David Cook on 12/10/2022.
//

import Foundation

struct Route: Identifiable, Decodable, Encodable, Equatable, Hashable {
    let name: String
    let colour: String
    let stops: [Stop]
    var id: String {
        name
    }
}
