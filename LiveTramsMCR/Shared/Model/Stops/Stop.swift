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
    let ids: [Int]
    let latitude: Double
    let line: String
    let longitude: Double
    let roadCrossing: String
    let stopName: String
    let street: String
    let tlaref: String
    let stopZone: String
    var id: Int {
        ids[0]
    }
}

let testData = [
    Stop(atcoCode: "9400ZZMAABM1",
         ids: [
             755,
             756
         ],
         latitude: 53.510510781,
         line: "Bury",
         longitude: -2.2354932857,
         roadCrossing: "",
         stopName: "Abraham Moss",
         street: "Off Crescent Road",
         tlaref: "ABM",
         stopZone: "2"),
    
    Stop(
        atcoCode: "9400ZZMAAIR1",
        ids: [
            695,
            696
        ],
        latitude: 53.3654118101,
        line: "Airport",
        longitude: -2.272215482,
        roadCrossing: "",
        stopName: "Manchester Airport",
        street: "Off Malaga Avenue",
        tlaref: "AIR",
        stopZone: "4"
    ),
    Stop(
        atcoCode: "9400ZZMAALT1",
        ids: [
            728,
            729
        ],
        latitude: 53.3872652199,
        line: "Altrincham",
        longitude: -2.3475466688,
        roadCrossing: "",
        stopName: "Altrincham",
        street: "Off Stamford New Road",
        tlaref: "ALT",
        stopZone: "4"
    ),
    Stop(
        atcoCode: "9400ZZMAANC1",
        ids: [
            815,
            816
        ],
        latitude: 53.4743206528,
        line: "Eccles",
        longitude: -2.2860954196,
        roadCrossing: "The Quays",
        stopName: "Anchorage",
        street: "Anchorage Quay",
        tlaref: "ANC",
        stopZone : "2"
    )
]
