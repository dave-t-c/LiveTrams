//
//  RouteV2.swift
//  LiveTramsMCR
//
//  Created by David Cook on 16/04/2023.
//

import Foundation

struct RouteV2: Identifiable, Decodable, Encodable, Equatable, Hashable {
    let name: String
    let colour: String
    let stops: [StopKeys]
    var id: String {
        name
    }
}
