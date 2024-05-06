//
//  Stop.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 23/04/2022.
//

import Foundation
import MapKit

struct Stop: Identifiable, Codable, Equatable, Hashable{
    let atcoCode: String
    let latitude: Double
    let line: String
    let longitude: Double
    let roadCrossing: String?
    let stopName: String
    let street: String?
    let tlaref: String
    let stopZone: String
    let routes: [SimpleRouteV2]?
    var id: Int {
        tlaref.hashValue
    }
}
