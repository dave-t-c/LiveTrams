//
//  Route.swift
//  LiveTramsMCR
//
//  Created by David Cook on 12/10/2022.
//

import Foundation

struct Route: Identifiable, Decodable, Encodable, Equatable, Hashable {
    let Name: String
    let Colour: String
    let Stops: [Stop]
    var id: String {
        Name
    }
}
