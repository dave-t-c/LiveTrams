//
//  AppIntent.swift
//  LiveTramsMCRWatchOSExtension
//
//  Created by David Cook on 10/01/2024.
//

import WidgetKit
import AppIntents

struct StopQuery: EntityQuery {
    func entities(for identifiers: [StopDetail.ID]) async throws -> [StopDetail] {
        let stops = try await StopRequest().requestStopsAsync()
        let stopDetails =  stops.map { stop in
            return StopDetail(id: stop.tlaref.hashValue, tlaref: stop.tlaref, stopName: stop.stopName)
        }

        return stopDetails.filter { identifiers.contains($0.id)}
    }

    func suggestedEntities() async throws -> [StopDetail] {
        let stops = try await StopRequest().requestStopsAsync()
        return stops.map { stop in
            return StopDetail(id: stop.tlaref.hashValue, tlaref: stop.tlaref, stopName: stop.stopName)
        }
    }

    func defaultResult() async -> StopDetail? {
        try? await suggestedEntities().first
    }
}

struct StopDetail: AppEntity {
    let id: Int
    let tlaref: String
    let stopName: String

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Stop"
    static var defaultQuery = StopQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(stopName)")
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Stop name")
    var stopName: String


    init(stopDetail: String) {
        self.stopName = stopDetail
    }


    init() {
    }
}


