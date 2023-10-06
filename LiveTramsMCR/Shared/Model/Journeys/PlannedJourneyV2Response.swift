//
//  PlannedJourneyV2.swift
//  LiveTramsMCR
//
//  Created by David Cook on 06/10/2023.
//

import Foundation
struct PlannedJourneyV2Response: Identifiable, Decodable, Encodable, Equatable, Hashable {
    let plannedJourney: PlannedJourneyV2
    let visualisedJourney: VisualisedJourney
    let nextService: NextService?
    let serviceUpdates: [String]
    let travelZones: [Int]
    var id: Int {
        travelZones[0]
    }
    
}

struct PlannedJourneyV2: Identifiable, Decodable, Encodable, Equatable, Hashable {
    let originStop: Stop
    let destinationStop: Stop
    let interchangeStop: Stop?
    let stopsFromOrigin: [Stop]
    let routesFromOrigin: [RouteV2]
    let terminiFromOrigin: [StopKeys]
    let requiresInterchange: Bool
    let stopsFromInterchange: [Stop]?
    let routesFromInterchange: [RouteV2]?
    let terminiFromInterchange: [StopKeys]?
    let minutesFromOrigin: Int
    let minutesFromInterchange: Int?
    let totalJourneyTimeMinutes: Int
    var id: Stop {
        originStop
    }
    
}

struct VisualisedJourney: Identifiable, Decodable, Encodable, Equatable, Hashable {
    let polylineFromOrigin: [[Double]]
    let polylineFromInterchange: [[Double]]?
    
    var id: [Double]{
        polylineFromOrigin[0]
    }
}

struct NextService: Identifiable, Decodable, Encodable, Equatable, Hashable {
    let destination: StopKeys
    let wait: Int
    
    var id: StopKeys {
        destination
    }
}
