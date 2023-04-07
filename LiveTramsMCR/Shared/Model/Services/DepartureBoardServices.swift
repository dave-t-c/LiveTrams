//
//  DepartureBoardServices.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 01/04/2023.
//

import Foundation

struct DepartureBoardServices: Identifiable, Codable {
    let trams: [Tram]
    let messages: [String]
    var id: UUID {
        UUID()
    }
}
