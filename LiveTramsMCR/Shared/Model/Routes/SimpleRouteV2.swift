//
//  SimpleRouteV2.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 30/05/2023.
//

import Foundation

struct SimpleRouteV2: Identifiable, Decodable, Encodable, Equatable, Hashable {
    let name: String
    let colour: String
    let stops: [StopKeys]
    var id: String {
        name
    }
}
