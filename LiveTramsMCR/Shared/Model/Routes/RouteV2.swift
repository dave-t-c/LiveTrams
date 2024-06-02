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
    let stopsDetail: [Stop]
    let polylineCoordinates: [RouteV2Coordinate]
    var id: Int {
        name.hashValue
    }
}

struct RouteV2Coordinate: Decodable, Encodable, Equatable, Hashable {
    let latitude: Double
    let longitude: Double
}
