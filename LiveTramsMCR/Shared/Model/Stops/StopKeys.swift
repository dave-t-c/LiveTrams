//
//  StopKeys.swift
//  LiveTramsMCR
//
//  Created by David Cook on 16/04/2023.
//

import Foundation

struct StopKeys: Identifiable, Decodable, Encodable, Equatable, Hashable {
    let stopName: String
    let tlaref: String
    var id: String {
        tlaref
    }
}
