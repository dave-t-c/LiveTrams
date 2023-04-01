//
//  GetNextTramIntent.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 01/04/2023.
//

import AppIntents

struct GetNextTramIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Get Live Trams"
    
    static var description = IntentDescription("Get live trams for a given stop")
    
    @Parameter(title: "Stop", optionsProvider: StopNameOptionsProvider())
    var stop: String?
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        
        guard let stop = stop else {
            throw $stop.needsValueError("Which stop?")
        }
        
        return .result(dialog: "Ok, doing something with \(stop)")
    }
    
}

private struct StopNameOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [String] {
        let stopRequester = StopRequest()
        let stops = try await stopRequester.requestStopsAsync()
        return stops.map { $0.stopName }
    }
}
