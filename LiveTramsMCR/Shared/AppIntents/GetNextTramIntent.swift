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
        
        let serviceRequester = ServicesRequest()
        let services = try await serviceRequester.requestDepartureBoardServices(tlaref: stop)
        let trams = services.trams
        
        if trams.isEmpty && services.messages.isEmpty {
            return .result(dialog: "There is currently no live service information for \(stop)")
        }
        
        if trams.isEmpty && !services.messages.isEmpty {
            return .result(dialog: "There is currently no live service information for \(stop), however there is a service update: \(services.messages.first!)")
        }
        
        let nextTram = trams.first!
        
        return .result(dialog: "The next tram from \(stop) is to \(nextTram.destination) in \(nextTram.wait) mins")
    }
    
}

private struct StopNameOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [String] {
        let stopRequester = StopRequest()
        let stops = try await stopRequester.requestStopsAsync()
        return stops.map { $0.stopName }
    }
}
