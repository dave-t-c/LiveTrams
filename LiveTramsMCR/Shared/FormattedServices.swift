//
//  FormattedServices.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 23/04/2022.
//

import Foundation

struct FormattedServices: Identifiable, Codable {
    let destinations: [String: [Tram]]
    let messages: [String]
    var id: UUID {
        UUID()
    }
}

struct FormattedServicesData {
    let testFormattedServicesData: [FormattedServices] = [
        FormattedServices(destinations: ["Old Trafford" : [Tram(destination: "Old Trafford", carriages: "Single", status: "Due", wait: "3"), Tram(destination: "Old Trafford", carriages: "Single", status: "Due", wait: "15")],
                                         "Altrincham" : [Tram(destination: "Altrincham", carriages: "Single", status: "Due", wait: "3"), Tram(destination: "Altrincham", carriages: "Single", status: "Due", wait: "15")]], messages: ["We are currently experiencing delays across the network and are working to resolve as quickly as possible"]),
    ]
}

