//
//  FormattedServices.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 23/04/2022.
//

import Foundation
import OrderedCollections

struct FormattedServices: Identifiable, Codable {
    let destinations: [String: [Tram]]
    let messages: [String]
    var id: UUID {
        UUID()
    }
}

struct FormattedServicesData {
}

