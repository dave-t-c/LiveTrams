//
//  PlannedJourneyV2.swift
//  LiveTramsMCR
//
//  Created by David Cook on 06/10/2023.
//

import Foundation
struct PlannedJourneyV2Response: Identifiable, Decodable, Encodable, Equatable, Hashable {
    let plannedJourney: PlannedJourney
    let visualisedJourney: VisualisedJourney
    let nextService: NextService
    let serviceUpdates: [String]
    let travelZones: [Int]
    var id: Stop {
        plannedJourney.originStop
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
