//
//  PlannedJourney.swift
//  LiveTramsMCR
//
//  Created by David Cook on 14/10/2022.
//

import Foundation

struct PlannedJourney: Identifiable, Decodable, Encodable, Equatable, Hashable {
    let originStop: Stop
    let destinationStop: Stop
    let interchangeStop: Stop?
    let routesFromOrigin: [Route]
    let stopsFromOrigin: [Stop]
    let terminiFromOrigin: [Stop]
    let routesFromInterchange: [Route]?
    let stopsFromInterchange: [Stop]?
    let terminiFromInterchange: [Stop]?
    let requiresInterchange: Bool
    let routeDetails: String?
    var id: Stop {
        originStop
    }
}
