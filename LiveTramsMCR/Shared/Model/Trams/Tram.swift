//
//  Tram.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 23/04/2022.
//

import Foundation

struct Tram: Identifiable, Codable, Hashable {
    let destination: String
    let carriages: String
    let status: String
    let wait: String
    var id: UUID {
        UUID()
    }
}
