//
//  PlannedJourney.swift
//  LiveTramsMCR
//
//  Created by David Cook on 14/10/2022.
//

import Foundation

struct PlannedJourney: Identifiable, Decodable, Encodable, Equatable, Hashable {
    var id = UUID()
    let OriginStop: Stop
    let DestinationStop: Stop
    let InterchangeStop: Stop
    let RoutesFromOrigin: [Route]
    let StopsFromOrigin: [Stop]
    let TerminiFromOrigin: [Stop]
    let RoutesFromInterchange: [Route]
    let StopsFromInterchange: [Stop]
    let TerminiFromInterchange: [Stop]
    let RequiresInterchange: Bool
    let RouteDetails: String
}
